
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:intl/intl.dart';
import 'package:vendas_mais_manager/components/cielo.components.dart';
import 'package:vendas_mais_manager/components/rabbitmq.component.dart';
import 'package:vendas_mais_manager/constants/order.actions.execute.constants.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';
import 'package:vendas_mais_manager/enums/status.order.enum.dart';
import 'package:vendas_mais_manager/models/request/order.request.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.interface.dart';
import 'package:vendas_mais_manager/repositories/notification.repository.dart';
import 'package:vendas_mais_manager/repositories/notification.repository.interface.dart';
import 'package:vendas_mais_manager/repositories/order.repository.dart';
import 'package:vendas_mais_manager/repositories/order.repository.interface.dart';
import 'package:vendas_mais_manager/repositories/payment.repository.dart';
import 'package:vendas_mais_manager/repositories/payment.repository.interface.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';
import 'package:vendas_mais_manager/stores/order.store.dart';
import 'package:vendas_mais_manager/view_model/order.view.model.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/view_model/statistic.view.model.dart';

class OrderController {
  static final String FORMAT_DATE = 'dd/MM/yyyy HH:mm a';
  IOrderRepository repository;
  IEstablishmentRepository establishmentRepository;
  IPaymentRepository paymentRepository;
  INotificationRepository notificationRepository;
  CieloComponent cieloComponent;
  ConnectComponent connect;
  RabbitMQComponent rabbitMQComponent;

  OrderController(){
    repository = new OrderRepository();
    establishmentRepository = new EstablishmentRepository();
    paymentRepository = new PaymentRepository();
    notificationRepository = new NotificationRepository();
    cieloComponent = new CieloComponent();
    connect = new ConnectComponent();
    rabbitMQComponent = new RabbitMQComponent();
  }

  OrderController.test(this.repository, this.establishmentRepository, this.paymentRepository, this.notificationRepository, this.cieloComponent, this.connect, this.rabbitMQComponent);

  Future<OrderViewModel> getAll(String id) async {
    OrderViewModel viewModel = OrderViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.list = await repository.getAll(id);
    }
    return viewModel;
  }

  Future<OrderViewModel> getTab(String id, int tab) async {
    OrderViewModel viewModel = OrderViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.list = await repository.getTab(id, tab);
    }

    return viewModel;
  }

  Future<List<OrderData>> applyFilters(OrderStore orderStore, AppStore appStore) async {
    appStore.setLoading(true);
    orderStore.setStatus();
    List<OrderData> list = orderStore.listAll;

    if(orderStore.activeDate){
      list = list.where((i) =>
      DateTime(i.dateCreate.toDate().year, i.dateCreate.toDate().month, i.dateCreate.toDate().day).difference(orderStore.startDate.toDate()).inDays >= 0 //&&
        && DateTime(i.dateCreate.toDate().year, i.dateCreate.toDate().month, i.dateCreate.toDate().day).difference(orderStore.endDate.toDate()).inDays <= 0
      ).toList();
    }

    if(orderStore.status.length > 0){
      list = list.where((i) =>
      (orderStore.status.contains(i.status))).toList();
    }

    list.sort((a, b) => b.orderCode.compareTo(a.orderCode));

    appStore.setLoading(false);
    return list;
  }

  Future<StatisticViewModel> getStatistic(String idEstablishment) async {
    var viewModel = StatisticViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.data = await repository.getStatistic(idEstablishment);
    }
    return viewModel;
  }

  Future<ValidateResponse> updateStatus(AppStore store, OrderData orderData, StatusOrder status) async {
    ValidateResponse response = new ValidateResponse();
    store.setLoading(true);
    if(await connect.checkConnect()) {
      orderData.dateUpdate = Timestamp.now();

      _setHistoric(orderData, status);

      orderData.status = status.index;

      repository.updateStatus(orderData);

      if (status == StatusOrder.READY_FOR_DELIVERY) {
        await _sendOrderQueue(store.connectionRabbit, orderData, ActionOrder.SET_DELIVERY_ORDER);
      } else {
        if(status == StatusOrder.IN_PRODUCTION){
          await _sendOrderQueue(store.connectionRabbit, orderData, ActionOrder.ORDER_APPROVED);
        }
        await _notifyClient(orderData.clientId, orderData.orderCode, status);
      }
      response.success = true;
    } else {
      response.failConnect();
    }
    store.setLoading(false);
    return response;
  }

  Future<Null> _notifyClient(String clientId, int orderCode, StatusOrder status) async{
    await notificationRepository.create(
        clientId, "Aqui Tem Delivery",
        StatusOrderText.getSubjectNotify(
            status, orderCode.toString()));
  }

  void _setHistoric(OrderData orderData, StatusOrder status){
    DateTime dateUpdate = orderData.dateUpdate.toDate();
    String dateText = DateFormat(FORMAT_DATE).format(dateUpdate);
    if (status == StatusOrder.IN_PRODUCTION) {
      orderData.historic.add("Aprovado" + " as " + dateText);
    }
    orderData.historic.add(
        StatusOrderText.getTitle(status).toLowerCase() + " as " + dateText);
    orderData.setHistoricText();
  }

  
  Future<ValidateResponse> getCountOrdersPending(AppStore store) async {
    ValidateResponse response = new ValidateResponse();
    store.setLoading(true);
    if(store.isLoggedIn()) {
      if (await connect.checkConnect()) {
        store.setCountOrderPending(
            await repository.getCountOrdersPending(store.establishment.id));
        response.success = true;
      } else {
        response.failConnect();
      }
    } else {
      response.message = "Faça o Login!";
    }
    store.setLoading(false);
    return response;
  }

  Future<ValidateResponse> cancel(AppStore store, OrderData orderData) async {
    store.setLoading(true);
    ValidateResponse validate;
    if(await connect.checkConnect()) {
      String value = (orderData.amount *100).toStringAsFixed(0);
      if (!orderData.payment.inDelivery) {
        validate = await cieloComponent.cancelSale(
            orderData.payment.paymentId, value);
      } else {
        validate = new ValidateResponse();
        validate.success = true;
      }

      if (validate.success) {
        orderData.reasonBy = "Estabelecimento";
        orderData.dateUpdate = Timestamp.now();
        DateTime dateUpdate = orderData.dateUpdate.toDate();
        String dateText = DateFormat(FORMAT_DATE).format(dateUpdate);
        orderData.historic.add(
            StatusOrderText.getTitle(StatusOrder.CANCELED) + " as " + dateText);
        orderData.setHistoricText();
        repository.cancel(orderData);
      } else {
        orderData.reason = "";
        orderData.reasonBy = "";
      }
    } else {
      validate = new ValidateResponse();
      validate.failConnect();
    }

    store.setLoading(false);
    return validate;
  }

  Future<Null> _sendOrderQueue(Client connectionRabbit ,OrderData orderData, String action) async{
    OrderRequest orderRequest = new OrderRequest.from(orderData.id, orderData.orderCode.toString(), orderData.idEstablishment, action);
    await rabbitMQComponent.sendMessage(connectionRabbit, "orders", orderRequest.toMap().toString());
  }

}
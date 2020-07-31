import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vendas_mais_manager/components/cielo.components.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/components/rabbitmq.component.dart';
import 'package:vendas_mais_manager/constants/error.message.constants.dart';
import 'package:vendas_mais_manager/controllers/order.controller.dart';
import 'package:vendas_mais_manager/enums/status.order.enum.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';
import 'package:vendas_mais_manager/models/entities/payment.order.entities.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.dart';
import 'package:vendas_mais_manager/repositories/notification.repository.dart';
import 'package:vendas_mais_manager/repositories/order.repository.dart';
import 'package:vendas_mais_manager/repositories/payment.repository.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';
import 'package:vendas_mais_manager/view_model/order.view.model.dart';
import 'package:vendas_mais_manager/view_model/statistic.view.model.dart';

class MockOrderRepository extends Mock implements OrderRepository  {}
class MockEstablishmentRepository extends Mock implements EstablishmentRepository  {}
class MockPaymentRepository extends Mock implements PaymentRepository  {}
class MockNotificationRepository extends Mock implements NotificationRepository  {}
class MockCieloComponent extends Mock implements CieloComponent  {}
class MockConnect extends Mock implements ConnectComponent  {}
class MockAppStore extends Mock implements AppStore  {}
class MockRabbitMQComponent extends Mock implements RabbitMQComponent  {}

void main(){
  OrderController controller;
  MockOrderRepository orderRepository;
  MockEstablishmentRepository establishmentRepository;
  MockPaymentRepository paymentRepository;
  MockCieloComponent cieloComponent;
  MockNotificationRepository notificationRepository;
  MockConnect connect;
  MockAppStore appStore;
  MockRabbitMQComponent rabbitMQComponent;
  
  setUp(() {
    appStore = MockAppStore();
    orderRepository = MockOrderRepository();
    establishmentRepository = MockEstablishmentRepository();
    paymentRepository = MockPaymentRepository();
    notificationRepository = MockNotificationRepository();
    cieloComponent = MockCieloComponent();
    connect = MockConnect();
    appStore = MockAppStore();
    rabbitMQComponent = MockRabbitMQComponent();
    controller = OrderController.test(orderRepository, establishmentRepository, paymentRepository, notificationRepository, cieloComponent, connect, rabbitMQComponent);
  });

  group('Listagem de pedidos', ()
  {

    test("Teste de listagem de todos os pedidos", () async {
      List<OrderData> listMock = [];
      OrderData orderData = OrderData();
      listMock.add(orderData);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.getAll("1")).thenAnswer((_) async =>
          Future.value(listMock));
      OrderViewModel viewModel = await controller.getAll("1");
      expect(viewModel.list.length, listMock.length);
    });

    test("Teste de listagem de pedidos por tab - sem registros", () async {
      List<OrderData> listMock = [];

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.getTab("1", 0)).thenAnswer((_) async =>
          Future.value(listMock));
      OrderViewModel viewModel = await controller.getTab("1", 0);
      expect(listMock, viewModel.list);
    });

    test("Teste de listagem de pedidos por tab", () async {
      List<OrderData> listMock = [];
      OrderData orderData = OrderData();
      listMock.add(orderData);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.getTab("1", 0)).thenAnswer((_) async =>
          Future.value(listMock));
      OrderViewModel viewModel = await controller.getTab("1", 0);
      expect(viewModel.list.length, listMock.length);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      OrderViewModel viewModel = await controller.getTab("1", 0);
      expect([], viewModel.list);
      expect(false, viewModel.checkConnect);
    });
  });

  group('Get Estatisticas', ()
  {
    test("Teste para trazer dados das vendas", () async {
      Map data = {};

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.getStatistic("1")).thenAnswer((_) async =>
          Future.value(data));
      StatisticViewModel viewModel = await controller.getStatistic("1");
      expect(data, viewModel.data);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      StatisticViewModel viewModel = await controller.getStatistic("1");
      expect({}, viewModel.data);
      expect(false, viewModel.checkConnect);
    });
  });

  group('Atualização de status', ()
  {
    OrderData mockOrder(){
      OrderData orderData = new OrderData();
      orderData.dateUpdate = Timestamp.now();
      orderData.historic = [];
      orderData.clientId = "1A";
      orderData.orderCode = 1;

      return orderData;
    }
    test("Teste de atualização de status", () async {
      OrderData data = mockOrder();

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.updateStatus(data)).thenAnswer((_) async =>
          Future.value(null));

      when(rabbitMQComponent.sendMessage(any, any, any)).thenAnswer((_) async =>
          Future.value(true));

      when(notificationRepository.create(data.clientId, StatusOrderText.getTitleNotify(StatusOrder.IN_PRODUCTION),
          StatusOrderText.getSubjectNotify(StatusOrder.IN_PRODUCTION, data.orderCode.toString()))).thenAnswer((_) async =>
          Future.value());

      ValidateResponse response = await controller.updateStatus(appStore, data, StatusOrder.IN_PRODUCTION);
      expect(response.success, true);
      expect(data.status, StatusOrder.IN_PRODUCTION.index);
      expect(data.historic.length, 2);
      expect(data.historicText != "", true);
    });


    test("Teste de falha de conexão", () async {
      OrderData data = mockOrder();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response =  await controller.updateStatus(appStore, data, StatusOrder.IN_PRODUCTION);
      expect(ErrorMessages.connectInternet, response.message);
      expect(false, response.success);
    });
  });

  group('Cancelar pedido', ()
  {
    OrderData mockOrder(){
      OrderData orderData = new OrderData();
      orderData.dateUpdate = Timestamp.now();
      orderData.historic = [];
      orderData.clientId = "1A";
      orderData.orderCode = 1;
      orderData.amount = 50.03;
      orderData.payment = new PaymentOrder();
      orderData.payment.inDelivery = false;
      orderData.payment.paymentId = "1A";
      orderData.reason = "Teste";
      return orderData;
    }
    test("Cancelar pedido - pagamento no cartão automatico", () async {
      OrderData data = mockOrder();
      ValidateResponse response = new ValidateResponse();
      response.success = true;
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(cieloComponent.cancelSale(data.payment.paymentId, "5003")).thenAnswer((_) async =>
          Future.value(response));

      when(orderRepository.cancel(data)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse responseFinal = await controller.cancel(appStore, data);
      expect(responseFinal.success, true);
      expect(data.reasonBy, "Estabelecimento");
      expect(data.historic.length, 1);
      expect(data.reason, "Teste");
    });

    test("Fail Cancelar pedido - pagamento no cartão automatico", () async {
      OrderData data = mockOrder();
      ValidateResponse response = new ValidateResponse();
      response.success = false;
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(cieloComponent.cancelSale(data.payment.paymentId, "5003")).thenAnswer((_) async =>
          Future.value(response));

      ValidateResponse responseFinal = await controller.cancel(appStore, data);
      expect(responseFinal.success, false);
      expect(data.reasonBy, "");
      expect(data.reason, "");
      expect(data.historic.length, 0);
    });

    test("Cancelar pedido - pagamento na entrega", () async {
      OrderData data = mockOrder();
      data.payment.inDelivery = true;
      ValidateResponse response = new ValidateResponse();
      response.success = true;
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.cancel(data)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse responseFinal = await controller.cancel(appStore, data);
      expect(responseFinal.success, true);
      expect(data.reasonBy, "Estabelecimento");
      expect(data.historic.length, 1);
      expect(data.reason, "Teste");
    });

    test("Fail Cancelar pedido - falha na conexão", () async {
      OrderData data = mockOrder();
      data.payment.inDelivery = true;

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse responseFinal = await controller.cancel(appStore, data);
      expect(ErrorMessages.connectInternet, responseFinal.message);
      expect(false, responseFinal.success);
    });
  });



}

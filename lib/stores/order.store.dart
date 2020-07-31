
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:vendas_mais_manager/enums/status.order.enum.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';

part 'order.store.g.dart';

class OrderStore = _OrderStore with _$OrderStore;

abstract class _OrderStore with Store {
  @observable
  bool activeDate = false;

  @observable
  Timestamp startDate = Timestamp.now();

  @observable
  Timestamp endDate = Timestamp.now();

  @observable
  List<dynamic> status = [];

  List<String> options = ['Entregue', 'Em Andamento', "Cancelado"];

  @observable
  List<String> tags = [];

  @observable
  List<OrderData> listAll = [];

  @observable
  List<OrderData> listFiltered = [];

  @observable
  double amount = 0;

  @action
  setListOrderAll(List<OrderData> list){
    listAll = list;
  }

  @action
  setListOrderFiltered(List<OrderData> list){
    listFiltered = list;
    setAmount();
  }

  void setAmount() {
    amount = 0;
    for (OrderData x in listFiltered) {
      amount += x.amount;
    }
  }

  @action
  void setTags(List<String> tags){
    this.tags = tags;
  }

  void setStatus() {
    status = [];
    for (String x in tags) {
      if (x == 'Entregue') {
        status.add(StatusOrder.CONCLUDED.index);
      }
      if (x == 'Em Andamento') {
        status.add(StatusOrder.IN_PRODUCTION.index);
        status.add(StatusOrder.PENDING.index);
        status.add(StatusOrder.READY_FOR_DELIVERY.index);
        status.add(StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT.index);
        status.add(StatusOrder.OUT_FOR_DELIVERY.index);
        status.add(StatusOrder.DELIVERY_ARRIVED_CLIENT.index);
      }
      if (x == 'Cancelado') {
        status.add(StatusOrder.CANCELED.index);
      }
    }
  }

  @action
  void setStartDate(DateTime dateTime){
    if (dateTime != null) {
      startDate = Timestamp.fromDate(dateTime);
    }
  }

  @action
  void setEndDate(DateTime dateTime){
    if (dateTime != null) {
      endDate = Timestamp.fromDate(dateTime);
    }
  }

  @action
  void setActiveDate(bool value) {
    activeDate = value;
  }

  String getStartDateString() {
    var formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(startDate.toDate());
  }

  String getEndDateString() {
    var formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(endDate.toDate());
  }

  String getStatusText() {
    String text = '';
    for (String x in tags) {
      text += (text != "" ? "\n" : "") + x;
    }
    return text;
  }
}
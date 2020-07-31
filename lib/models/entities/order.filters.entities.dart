import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';
import 'package:vendas_mais_manager/enums/status.order.enum.dart';

class OrderFilters {
  bool activeDate = false;
  Timestamp startDate = Timestamp.now();
  Timestamp endDate = Timestamp.now();
  List<dynamic> status = [];
  List<String> options = ['Entregue', 'Em Andamento', "Cancelado"];
  List<String> tags = [];
  List<OrderData> listAll = [];
  List<OrderData> listFiltered = [];
  double amount = 0;

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

  void setAmount() {
    amount = 0;
    for (OrderData x in listFiltered) {
      amount += x.amount;
    }
  }

  void setTags() {
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
}

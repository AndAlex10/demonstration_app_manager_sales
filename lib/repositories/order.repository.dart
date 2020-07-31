
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';
import 'package:vendas_mais_manager/enums/status.delivery.enum.dart';
import 'package:vendas_mais_manager/enums/status.order.enum.dart';
import 'package:vendas_mais_manager/repositories/order.repository.interface.dart';

class OrderRepository implements IOrderRepository {

  @override
  Future<OrderData> getOrderId(String id) async {
    OrderData order;
    DocumentSnapshot doc = await Firestore.instance.collection("???").document(id).get();
    if(doc != null) {
      order = OrderData.fromDocument(doc);
    }
    return order;
  }

  @override
  Future<List<OrderData>> getTab(String id, int tab) async {
    List<OrderData> dataList = [];

    QuerySnapshot snapshot;

    List<dynamic> status = [];
    if (tab == 1) {
      status.add(StatusOrder.CONCLUDED.index);
    } else if (tab == 2) {
      status.add(StatusOrder.CANCELED.index);
    } else {
      status.add(StatusOrder.PENDING.index);
      status.add(StatusOrder.IN_PRODUCTION.index);
      status.add(StatusOrder.READY_FOR_DELIVERY.index);
      status.add(StatusOrder.OUT_FOR_DELIVERY.index);
    }

    snapshot = await Firestore.instance.collection("???")
        .where("???", isEqualTo: id)
        .where("???", whereIn: status)
        .getDocuments();

    for (DocumentSnapshot doc in snapshot.documents) {
      OrderData order = OrderData.fromDocument(doc);
      DocumentSnapshot docUser = await Firestore.instance
          .collection("???")
          .document(order.clientId)
          .get();
      order.setClient(docUser);

      dataList.add(order);
    }

    if (tab == 0) {
      dataList.sort((a, b) {
        var r = a.status.compareTo(b.status);
        if (r != 0) return r;
        return b.orderCode.compareTo(a.orderCode);
      });
    } else {
      dataList.sort((a, b) => b.orderCode.compareTo(a.orderCode));

    }
    return dataList;
  }

  @override
  Future<Map> getStatistic(String idEstablishment) async {
    double amount_1 = 0;
    double amount_2 = 0;
    double amount_3 = 0;
    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .where("???", isEqualTo: idEstablishment)
        .where('???', isEqualTo: StatusOrder.CONCLUDED.index)
        .getDocuments();

    for (DocumentSnapshot doc in snapshot.documents) {
      OrderData order = OrderData.fromDocument(doc);
      var data = order.dateCreate.toDate();

      DateTime month_1 = DateTime.now();
      DateTime month_2 = DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
      DateTime month_3 = DateTime(DateTime.now().year, DateTime.now().month - 2, DateTime.now().day);

      if (month_1.month == data.month && (month_1.year) == data.year) {
        amount_1 = amount_1 + order.amount;
      } else if (month_2.month == data.month && (month_2.year) == data.year) {
        amount_2 = amount_2 + order.amount;
      } else if (month_3.month == data.month && (month_3.year) == data.year) {
        amount_3 = amount_3 + order.amount;
      }
    }
    Map result = {"month1": amount_1, "month2": amount_2, "month3": amount_3};
    return result;
  }

  @override
  Future<Null> updateStatus(OrderData orderData) async {
    await Firestore.instance
        .collection("???")
        .document(orderData.id)
        .updateData(orderData.toMap());
  }

  @override
  void cancel(OrderData orderData) async {
    orderData.status = StatusOrder.CANCELED.index;
    orderData.rating = null;

    await Firestore.instance
        .collection("???")
        .document(orderData.id)
        .updateData({"???": StatusOrder.CANCELED.index});
  }

  @override
  Future<int> getCountOrdersPending(String id) async {

    QuerySnapshot snapshot = await Firestore.instance.collection("???")
        .where("???", isEqualTo: id)
        .where('???', isEqualTo: StatusOrder.PENDING.index)
        .getDocuments();
    return snapshot.documents.length;
  }

  @override
  Future<List<OrderData>> getAll(String id) async {
    List<OrderData> dataList = [];

    QuerySnapshot snapshot = await Firestore.instance.collection("???")
        .where("???", isEqualTo: id)
        .getDocuments();

    OrderData order;
    for (DocumentSnapshot doc in snapshot.documents) {
      order = OrderData.fromDocument(doc);
      DocumentSnapshot docUser = await Firestore.instance
          .collection("???")
          .document(order.clientId)
          .get();
      order.setClient(docUser);

      dataList.add(order);
    }

    dataList.sort((a, b) => b.orderCode.compareTo(a.orderCode));

    return dataList;
  }

  @override
  Future<String> searchDeliveryMan(OrderData orderData) async{
    QuerySnapshot snapshot = await Firestore.instance.collection("???")
        .where("???", isEqualTo: true)
        .where("???", isEqualTo: true)
        .where("???", isEqualTo: StatusDelivery.AVAILABLE.index)
        .getDocuments();

    if(snapshot.documents.length >= 1){
      await Firestore.instance
          .collection("???")
          .document(snapshot.documents[0].documentID)
          .updateData({"???": orderData.id, "???": StatusDelivery.PENDING.index});
      return snapshot.documents[0].documentID;
    }
    return null;
  }

}
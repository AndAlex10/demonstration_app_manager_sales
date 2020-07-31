
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/models/entities/payments.entity.dart';
import 'package:vendas_mais_manager/repositories/payment.repository.interface.dart';

class PaymentRepository implements IPaymentRepository {

  @override
  Future<Payments> getId(String idPayment, String idEstablishment) async{
    DocumentSnapshot doc = await Firestore.instance.collection("???").document(idEstablishment)
        .collection("???").document(idPayment).get();

    Payments payments;
    if(doc != null) {
      payments = Payments.fromDocument(doc);
    } else {
      payments = Payments();
      payments.title = "Não encontrada";
    }
    return payments;
  }

  @override
  Future<List<Payments>> getAll(String id) async {
    List<Payments> list = [];

    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(id)
        .collection("???")
        .where("???", isEqualTo: true)
        .getDocuments();

    for (DocumentSnapshot doc in snapshot.documents) {
      Payments payments = Payments.fromDocument(doc);
      list.add(payments);
    }

    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  @override
  void update(String idEstablishment, Payments data) async{
    await Firestore.instance.collection("???").document(idEstablishment)
        .collection("???")
        .document(data.id)
        .updateData(data.toMap());
  }
}
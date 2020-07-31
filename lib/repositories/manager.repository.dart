import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vendas_mais_manager/enums/status.order.enum.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';
import 'package:vendas_mais_manager/models/entities/manager.entity.dart';
import 'package:vendas_mais_manager/repositories/manager.repository.interface.dart';

class ManagerRepository implements IManagerRepository {

  @override
  Future<ManagerEntity> load() async {
    ManagerEntity manager;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser fbUser;

    if (fbUser == null) fbUser = await auth.currentUser();
    if (fbUser != null) {

      DocumentSnapshot docUser = await Firestore.instance
          .collection("???")
          .document(fbUser.uid)
          .get();

      if(docUser.data != null) {
        manager = ManagerEntity.fromMap(docUser.data);
      }
    }

    return manager;
  }

  @override
  void updateRating(String id) async {
    double rating = 0.00;
    int countRating = 0;
    QuerySnapshot snapshot = await Firestore.instance.collection("???")
        .where("???", isEqualTo: id)
        .where('???', whereIn: [StatusOrder.CANCELED.index, StatusOrder.CONCLUDED.index])
        .getDocuments();

    OrderData order;
    for (var i = 0; i < snapshot.documents.length; i++) {
      order = OrderData.fromDocument(snapshot.documents[i]);
      if(order.rating != null) {
        rating += order.rating;
        countRating ++;
      }

    }
    if(countRating > 0) {
      rating = rating / countRating;
      await Firestore.instance
          .collection("???")
          .document(id)
          .updateData({"???": double.parse(rating.toStringAsFixed(1))});
    }

  }



}

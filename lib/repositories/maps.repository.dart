
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/repositories/maps.repository.interface.dart';

class MapsRepository implements IMapsRepository {

  @override
  Future<String> getKeyMap() async{
    DocumentSnapshot snapshot = await Firestore.instance.collection("???").document("???").get();
    return snapshot.data["???"];
  }
}
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/models/entities/cielo.entities.dart';
import 'package:vendas_mais_manager/repositories/cielo.repository.interface.dart';


class CieloRepository implements ICieloRepository {

  @override
  Future<CieloData> get() async{
    DocumentSnapshot snapshot = await Firestore.instance.collection("???").document("???").get();

    CieloData cieloData = CieloData.fromDocument(snapshot);
    return cieloData;
  }

}
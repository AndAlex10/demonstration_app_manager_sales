import 'package:cloud_firestore/cloud_firestore.dart';
class MenuData {
  String id;
  String name;
  int order;
  String idCategoryAdditional;
  bool active;
  bool additional;

  MenuData();

  MenuData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'];
    order = document.data['order'];
    idCategoryAdditional = document.data["idCategoryAdditional"];
    active = document.data['active'];
    additional = document.data['additional'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "active": active
    };
  }
}
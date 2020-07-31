import 'package:cloud_firestore/cloud_firestore.dart';
class CategoryData {
  String id;
  String name;
  bool active;

  CategoryData();

  CategoryData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'];
    active = document.data['active'];

  }

  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "active": active
    };
  }
}
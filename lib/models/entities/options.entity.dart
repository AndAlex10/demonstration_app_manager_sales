import 'package:cloud_firestore/cloud_firestore.dart';

class OptionsData {
  String id;
  String title;
  double price;
  bool active;

  OptionsData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    price = snapshot.data["price"] + 0.0;
    active = snapshot.data["active"];
  }

  Map<String, dynamic> toMap(){
    return {
      "title": title,
      "price": price,
      "active": active
    };
  }
}
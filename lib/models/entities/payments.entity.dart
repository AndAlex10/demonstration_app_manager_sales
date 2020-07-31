import 'package:cloud_firestore/cloud_firestore.dart';
class Payments {
  String id;
  String title;
  String type;
  String method;
  bool active;
  String image;
  int order;
  String paymentId;

  Payments();

  Payments.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    title = document.data['title'];
    type = document.data['type'];
    method = document.data['method'];
    active = document.data['active'];
    order = document.data['order'];
    paymentId = document.data['paymentId'];
    image = 'images/methodspayment/' + method + '.png';
  }

  Payments.fromMap(Map data){
    id = data['id'];
    title = data['title'];
    type = data['type'];
    method = data['method'];
    active = data['active'];
    order = data['order'];
    image = 'images/methodspayment/' + method + '.png';
  }

  Map<String, dynamic> toMap(){
    return {
      "title": title,
      "type": type,
      "method": method,
      "active": active,
    };
  }
}
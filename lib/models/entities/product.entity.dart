import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/models/entities/options.entity.dart';

class ProductData {

  String category;
  String id;
  String title;
  String description;
  double price;
  bool active;
  bool options;

  List images;
  List<OptionsData> optionsList = [];

  ProductData();

  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"] + 0.0;
    active = snapshot.data["active"];
    images = snapshot.data["images"];

    options = snapshot.data["options"];
    if (options == null) {
      options = false;
    }
  }

  Map<String, dynamic> toMap(){
    return {
      "title": title,
      "description": description,
      "price": price,
      "active": active
    };
  }

}
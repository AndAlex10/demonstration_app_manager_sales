
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/models/entities/menu.entity.dart';
import 'package:vendas_mais_manager/models/entities/options.entity.dart';
import 'package:vendas_mais_manager/models/entities/product.entity.dart';
import 'package:vendas_mais_manager/repositories/product.repository.interface.dart';

class ProductRepository implements IProductRepository {

  @override
  Future<List<ProductData>> getAll(String idEstablishment, MenuData menuData, String search) async {
    List<ProductData> list = [];

    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(idEstablishment)
        .collection("???")
        .document(menuData.id)
        .collection("???")
        .getDocuments();

    for (DocumentSnapshot doc in snapshot.documents) {
      ProductData productData = ProductData.fromDocument(doc);
      productData.category = menuData.id;
      setOptions(productData, idEstablishment, menuData);
      list.add(productData);
    }

    if (search != '') {
      list = list.where((i) => i.title.toLowerCase().contains(search.toLowerCase())).toList();
    }

    list.sort((a, b) => a.title.compareTo(b.title));
    return list;
  }

  @override
  void update(String idEstablishment, ProductData data) async{
    await Firestore.instance.collection("???").document(idEstablishment)
        .collection("???")
        .document(data.category)
        .collection("???")
        .document(data.id)
        .updateData(data.toMap());
  }

  @override
  void updateOption(String idEstablishment, ProductData productData, OptionsData data) async{
    await Firestore.instance.collection("???").document(idEstablishment)
        .collection("???")
        .document(productData.category)
        .collection("???")
        .document(productData.id)
        .collection("???")
        .document(data.id)
        .updateData(data.toMap());
  }

  @override
  void setOptions(ProductData productData, String idEstablishment,  MenuData menuData) async{
    if (productData.options) {
      QuerySnapshot list = await Firestore.instance
          .collection("???")
          .document(idEstablishment)
          .collection("???")
          .document(menuData.id)
          .collection("???")
          .document(productData.id)
          .collection("???")
          .getDocuments();

      for (DocumentSnapshot doc in list.documents) {
        OptionsData optionsData = OptionsData.fromDocument(doc);
        productData.optionsList.add(optionsData);
      }
    }
  }


}
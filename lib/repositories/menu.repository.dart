import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/models/entities/menu.entity.dart';
import 'package:vendas_mais_manager/repositories/menu.repository.interface.dart';

class MenuRepository implements IMenuRepository{

  @override
  Future<List<MenuData>> getAll(String idEstablishment) async {
    List<MenuData> list = [];
    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(idEstablishment)
        .collection("???")
        .where("???", isEqualTo: true)
        .getDocuments();

    MenuData data;
    for (var i = 0; i < snapshot.documents.length; i++) {
      data = MenuData.fromDocument(snapshot.documents[i]);

      list.add(data);
    }
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  @override
  Future<void> update(String idEstablishment, MenuData data) async{
    await Firestore.instance.collection("???")
        .document(idEstablishment)
        .collection("???")
        .document(data.id)
        .updateData(data.toMap());
  }


}
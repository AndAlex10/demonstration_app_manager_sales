import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/models/entities/establishment.entity.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.interface.dart';

class EstablishmentRepository implements IEstablishmentRepository {

  @override
  Future<EstablishmentData> getId(String idEstablishment) async {
    DocumentSnapshot establishmentDoc = await Firestore.instance
        .collection("???")
        .document(idEstablishment)
        .get();
    EstablishmentData establishmentData =
        EstablishmentData.fromDocument(establishmentDoc);
    return establishmentData;
  }

  @override
  void openClose(EstablishmentData establishmentData) async {
    if (establishmentData.id != null) {
      if (establishmentData.open) {
        establishmentData.open = false;
      } else {
        establishmentData.open = true;
      }
      await Firestore.instance
          .collection("???")
          .document(establishmentData.id)
          .updateData(establishmentData.toMap());
    }
  }

  @override
  Future<bool> refreshAddress(EstablishmentData data, PlacesDetailsResponse detail) async {
    bool result = false;
    data.refreshAddress(detail);
    Firestore.instance
        .collection("???")
        .document(data.id)
        .updateData(data.toMap());

    result = true;
    return result;
  }

  @override
  Future<bool> alter(EstablishmentData data) async {
    await Firestore.instance
        .collection("???")
        .document(data.id)
        .updateData(data.toMap());

    return true;
  }
}

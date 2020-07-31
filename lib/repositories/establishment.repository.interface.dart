import 'package:vendas_mais_manager/models/entities/establishment.entity.dart';
import 'package:google_maps_webservice/places.dart';

abstract class IEstablishmentRepository {
  Future<EstablishmentData> getId(String idEstablishment);

  void openClose(EstablishmentData establishmentData);

  Future<bool> refreshAddress(EstablishmentData data, PlacesDetailsResponse detail);

  Future<bool> alter(EstablishmentData data);
}

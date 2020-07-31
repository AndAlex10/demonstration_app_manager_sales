import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/maps.repository.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/repositories/maps.repository.interface.dart';

class ApiMapsController extends Model  {

  IMapsRepository repository;
  ConnectComponent connect;

  ApiMapsController(){
    repository = new MapsRepository();
    connect = new ConnectComponent();
  }

  bool isLoading = false;

  String key;

  GoogleMapsPlaces _places;

  ApiMapsController.test(this.repository, this.connect);

  Future<ValidateResponse> getKeyMap() async{
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      key = await repository.getKeyMap();
      _places = GoogleMapsPlaces(apiKey: key);
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

  Future<PlacesDetailsResponse> getPlaceDetail(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      return detail;
    }

    return null;

  }



}

import 'package:vendas_mais_manager/models/entities/establishment.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.interface.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class EstablishmentController {

  IEstablishmentRepository repository;
  ConnectComponent connect;

  EstablishmentController(){
    repository = new EstablishmentRepository();
    connect = new ConnectComponent();
  }

  EstablishmentController.tests(this.repository, this.connect);

  Future<EstablishmentData> getId(String idEstablishment) async{
    return await repository.getId(idEstablishment);
  }

  Future<ValidateResponse> openClose(EstablishmentData establishmentData) async {
    ValidateResponse response = new ValidateResponse();
    if (await connect.checkConnect()) {
       repository.openClose(establishmentData);
       response.success = true;
    } else {
      response.failConnect();
    }
    return response;
  }

  Future<ValidateResponse> refreshAddress(
      EstablishmentData data, PlacesDetailsResponse detail) async {
    ValidateResponse response = new ValidateResponse();
    if (await connect.checkConnect()) {
      await repository.refreshAddress(data, detail);
      response.success = true;
    } else {
      response.failConnect();
    }
    return response;
  }

  Future<ValidateResponse> alter(AppStore store, String name, String cnpj, String number,
      String phone, String complement) async {
    ValidateResponse response = new ValidateResponse();
    store.setLoading(true);
    if (await connect.checkConnect()) {
      if(store.establishment != null) {
        EstablishmentData data = store. establishment;
        data.name = name;
        data.cnpj = cnpj;
        data.number = number;
        data.phone = phone;
        data.complement = complement;
        response.success = await repository.alter(data);
        store.setEstablishment(data);
      }  else {
        response.success = false;
      }
    } else {
      response.failConnect();
    }
    store.setLoading(false);
    return response;
  }

}
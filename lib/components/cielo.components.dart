
import 'package:flutter_cielo/flutter_cielo.dart';
import 'package:vendas_mais_manager/constants/error.message.constants.dart';
import 'package:vendas_mais_manager/models/entities/cielo.entities.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/cielo.repository.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';


class CieloComponent {
  CieloEcommerce cielo;
  CieloRepository repository;
  CieloData cieloData;
  Client client;
  CieloComponent(){
    repository = new CieloRepository();
    client = Client();
  }

  CieloComponent.tests(this.repository);

  Future<Null> getSecretsKey() async{
    cieloData = await repository.get();
    cielo = CieloEcommerce(
        environment: Environment.SANDBOX, // ambiente de desenvolvimento
        merchant: Merchant(
          merchantId: cieloData.merchantId,
          merchantKey: cieloData.merchantKey,
        ));
  }

  Future<ValidateResponse> cancelSale(String paymentId, String amount) async{
    await getSecretsKey();
    ValidateResponse validate = new ValidateResponse();
    Map data;
    String url = "https://apisandbox.cieloecommerce.cielo.com.br/1/sales/$paymentId/void?amount=$amount";
    Map<String, String> header = {"Content-Type": "application/json",
      "MerchantId": cieloData.merchantId,
      "MerchantKey": cieloData.merchantKey};
    try {
      final response = await client.put(url, headers: header);
      String returnText = response.body;
      data = json.decode(returnText);

      if (data["ReturnCode"] == "0") {
        validate.success = true;
      } else {
        validate.message = data["ReturnMessage"];
      }
    } catch (e){
      validate.message = ErrorMessages.failCancelSale;
    }

    return validate;
  }

}
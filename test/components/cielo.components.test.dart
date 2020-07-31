import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vendas_mais_manager/components/cielo.components.dart';
import 'package:vendas_mais_manager/models/entities/cielo.entities.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/cielo.repository.dart';
import 'package:vendas_mais_manager/repositories/cielo.repository.interface.dart';
import 'dart:convert';

class CieloRepositoryMock extends Mock implements CieloRepository  {}

void main(){
  CieloComponent cieloComponent;
  ICieloRepository repository;
  setUp(() {
    repository = CieloRepositoryMock();
    cieloComponent = CieloComponent.tests(repository);
  });

  group('Cielo tests', ()
  {
    test("Testing the cancelSale", () async{
      CieloData cieloData = new CieloData();
      when(repository.get()).thenAnswer((_) async =>
          Future.value(cieloData));
      cieloComponent.client = MockClient((request) async{
        final mapJson = {'ReturnCode':"0"};
        return Response(json.encode(mapJson),200);
      });

      ValidateResponse validateResponse = await cieloComponent.cancelSale("paymentId", "500");
      expect(validateResponse != null, true);
      expect(validateResponse.success, true);
    });

    test("Testing the cancelSale - fail", () async{
      CieloData cieloData = new CieloData();
      when(repository.get()).thenAnswer((_) async =>
          Future.value(cieloData));
      cieloComponent.client = MockClient((request) async{
        final mapJson = {'ReturnCode':"2", "ReturnMessage":  "error"};
        return Response(json.encode(mapJson),200);
      });

      ValidateResponse validateResponse = await cieloComponent.cancelSale("paymentId", "500");
      expect(validateResponse != null, true);
      expect(validateResponse.success, false);
    });

  });

}
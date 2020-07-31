import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/controllers/establishment.controller.dart';
import 'package:vendas_mais_manager/models/entities/establishment.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.interface.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class EstablishmentRepositoryMock extends Mock implements EstablishmentRepository {}
class MockConnect extends Mock implements ConnectComponent  {}
class PlacesDetailsResponseMock extends Mock implements PlacesDetailsResponse  {}
class MockAppStore extends Mock implements AppStore  {}

void main(){
  EstablishmentController controller;
  ConnectComponent connect;
  IEstablishmentRepository repository;
  AppStore appStore;
  setUp(() {
    repository = EstablishmentRepositoryMock();
    connect = MockConnect();
    appStore = MockAppStore();
    controller = EstablishmentController.tests(repository, connect);
  });

  group('Establishment tests - Abrir e fechar', ()
  {
    test("Teste para abrir ou fechar estabelecimento", () async {
      EstablishmentData establishmentData = new EstablishmentData();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.openClose(establishmentData)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.openClose(establishmentData);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      EstablishmentData establishmentData = new EstablishmentData();

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.openClose(establishmentData);
      expect(false, response.success);
    });
  });

  group('Establishment tests - Alterar endereço', ()
  {
    test("Teste para Alterar endereço", () async {
      EstablishmentData establishmentData = new EstablishmentData();
      PlacesDetailsResponse detail = PlacesDetailsResponseMock();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.refreshAddress(establishmentData, detail)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.refreshAddress(establishmentData, detail);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      EstablishmentData establishmentData = new EstablishmentData();
      PlacesDetailsResponse detail = PlacesDetailsResponseMock();

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.refreshAddress(establishmentData, detail);
      expect(false, response.success);
    });
  });

  group('Establishment tests - Alterar dados', ()
  {
    test("Teste para Alterar dados do estabelecimento", () async {

      when(appStore.establishment).thenAnswer((_)  =>
      new EstablishmentData());
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.alter(any)).thenAnswer((_) async =>
          Future.value(true));

      ValidateResponse response = await controller.alter(appStore, "test", "015151515", "151", "545484848", "");
      expect(response.success, true);
    });

    test("Teste para Alterar dados do estabelecimento - nulo", () async {

      when(appStore.establishment).thenAnswer((_)  =>
      null);
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.alter(any)).thenAnswer((_) async =>
          Future.value(true));

      ValidateResponse response = await controller.alter(appStore, "test", "015151515", "151", "545484848", "");
      expect(response.success, false);
    });

    test("Teste de falha de conexão", () async {

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.alter(appStore, "test", "015151515", "151", "545484848", "");
      expect(false, response.success);
    });
  });
}

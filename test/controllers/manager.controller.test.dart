import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/controllers/manager.controller.dart';
import 'package:vendas_mais_manager/models/entities/manager.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/manager.repository.dart';
import 'package:vendas_mais_manager/repositories/manager.repository.interface.dart';

class ManagerRepositoryMock extends Mock implements ManagerRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  ManagerController controller;
  ConnectComponent connect;
  IManagerRepository repository;
  setUp(() {
    repository = ManagerRepositoryMock();
    connect = MockConnect();
    controller = ManagerController.tests(repository, connect);
  });

  group('Establishment tests', ()
  {
    test("Test load", () async {
      ManagerEntity data = new ManagerEntity();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.load()).thenAnswer((_) async =>
          Future.value(data));
      ManagerEntity response = await controller.load();
      expect(response != null, true);
    });

    test("Teste de falha de conexão", () async {

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ManagerEntity response = await controller.load();
      expect(false, response != null);
    });
  });

  group('Manager tests - atualizar avaliação', ()
  {
    test("atualizar avaliação", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.updateRating(any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.updateRating("1L");
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.updateRating("1L");
      expect(false, response.success);
    });
  });

}
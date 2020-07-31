import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/controllers/api.maps.controller.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/maps.repository.dart';
import 'package:vendas_mais_manager/repositories/maps.repository.interface.dart';

class MapsRepositoryMock extends Mock implements MapsRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  ApiMapsController controller;
  ConnectComponent connect;
  IMapsRepository repository;

  setUp(() {
    repository = MapsRepositoryMock();
    connect = MockConnect();
    controller = ApiMapsController.test(repository, connect);
  });

  group('Api Maps tests', ()
  {
    test("Teste para trazer key do google maps", () async {
      String key = "1A";

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getKeyMap()).thenAnswer((_) async =>
          Future.value(key));
      ValidateResponse response = await controller.getKeyMap();
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.getKeyMap();
      expect(false, response.success);
    });
  });
}
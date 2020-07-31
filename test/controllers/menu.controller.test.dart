import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/controllers/menu.controller.dart';
import 'package:vendas_mais_manager/models/entities/menu.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/menu.repository.dart';
import 'package:vendas_mais_manager/repositories/menu.repository.interface.dart';
import 'package:vendas_mais_manager/view_model/menu.view.model.dart';

class MenuRepositoryMock extends Mock implements MenuRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}


void main(){
  MenuController controller;
  ConnectComponent connect;
  IMenuRepository repository;
  setUp(() {
    repository = MenuRepositoryMock();
    connect = MockConnect();
    controller = MenuController.tests(repository, connect);
  });

  group('Menu tests Get All', ()
  {
    test("Test get All", () async {
      List<MenuData> list = [];
      list.add(new MenuData());
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getAll("1L")).thenAnswer((_) async =>
          Future.value(list));
      MenuViewModel response = await controller.getAll("1L");
      expect(response != null, true);
      expect(response.list.length > 0, true);
      expect(response.checkConnect, true);
    });

    test("Teste de falha de conexão", () async {

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      MenuViewModel response = await controller.getAll("1L");
      expect(false, response.checkConnect);
    });
  });

  group('Menu tests Update', ()
  {
    test("update", () async {
      MenuData data = new MenuData();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.update("1L", data)).thenAnswer((_) async =>
          Future.value(Null));
      ValidateResponse response = await controller.update("1L", data, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      MenuData data = new MenuData();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.update("1L", data, true);
      expect(false, response.success);
    });
  });

}
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/controllers/product.controller.dart';
import 'package:vendas_mais_manager/models/entities/menu.entity.dart';
import 'package:vendas_mais_manager/models/entities/product.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/product.repository.dart';
import 'package:vendas_mais_manager/repositories/product.repository.interface.dart';
import 'package:vendas_mais_manager/view_model/products.view.model.dart';


class ProductRepositoryMock extends Mock implements ProductRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  ProductController controller;
  ConnectComponent connect;
  IProductRepository repository;
  setUp(() {
    repository = ProductRepositoryMock();
    connect = MockConnect();
    controller = ProductController.tests(repository, connect);
  });

  group('Products tests Get All', ()
  {
    test("Test get All", () async {
      List<ProductData> list = [];
      MenuData menuData = new MenuData();
      list.add(new ProductData());
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getAll("1L", menuData, "")).thenAnswer((_) async =>
          Future.value(list));
      ProductsViewModel response = await controller.getAll("1L", menuData, "");
      expect(response != null, true);
      expect(response.list.length > 0, true);
      expect(response.checkConnect, true);
    });

    test("Teste de falha de conexão", () async {
      MenuData menuData = new MenuData();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ProductsViewModel response = await controller.getAll("1L", menuData, "");
      expect(false, response.checkConnect);
    });
  });

  group('Products tests Update', ()
  {
    test("update", () async {
      ProductData data = new ProductData();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.update("1L", data)).thenAnswer((_) async =>
          Future.value(Null));
      ValidateResponse response = await controller.update("1L", data, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      ProductData data = new ProductData();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.update("1L", data, true);
      expect(false, response.success);
    });
  });

}
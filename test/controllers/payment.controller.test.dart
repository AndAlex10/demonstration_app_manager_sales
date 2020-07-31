import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/controllers/payment.controller.dart';
import 'package:vendas_mais_manager/models/entities/payments.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/payment.repository.dart';
import 'package:vendas_mais_manager/repositories/payment.repository.interface.dart';
import 'package:vendas_mais_manager/view_model/payment.view.model.dart';

class PaymentRepositoryMock extends Mock implements PaymentRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  PaymentController controller;
  ConnectComponent connect;
  IPaymentRepository repository;
  setUp(() {
    repository = PaymentRepositoryMock();
    connect = MockConnect();
    controller = PaymentController.tests(repository, connect);
  });

  group('Payment tests Get All', ()
  {
    test("Test get All", () async {
      List<Payments> list = [];
      list.add(new Payments());
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getAll("1L")).thenAnswer((_) async =>
          Future.value(list));
      PaymentViewModel response = await controller.getAll("1L");
      expect(response != null, true);
      expect(response.list.length > 0, true);
      expect(response.checkConnect, true);
    });

    test("Teste de falha de conexão", () async {

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      PaymentViewModel response = await controller.getAll("1L");
      expect(false, response.checkConnect);
    });
  });

  group('Payment tests Update', ()
  {
    test("update", () async {
      Payments data = new Payments();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.update("1L", data)).thenAnswer((_) async =>
          Future.value(Null));
      ValidateResponse response = await controller.update("1L", data, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      Payments data = new Payments();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.update("1L", data, true);
      expect(false, response.success);
    });
  });

}
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/controllers/coupon.controller.dart';
import 'package:vendas_mais_manager/models/entities/coupon.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/coupon.repository.dart';
import 'package:vendas_mais_manager/repositories/coupon.repository.interface.dart';

class CouponRepositoryMock extends Mock implements CouponRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}


void main(){
  CouponController controller;
  ConnectComponent connect;
  ICouponRepository repository;

  setUp(() {
    repository = CouponRepositoryMock();
    connect = MockConnect();
    controller = CouponController.test(repository, connect);
  });

  group('Coupon tests - criar um novo cupom', ()
  {
    test("Teste para criar um novo cupom", () async {
      String value = "10.00";
      String idEstablishment = "1A";
      Coupon coupon = new Coupon();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.save(idEstablishment, coupon)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.save(idEstablishment, coupon, value);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      String value = "10.00";
      String idEstablishment = "1A";
      Coupon coupon = new Coupon();

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.save(idEstablishment, coupon, value);
      expect(false, response.success);
    });
  });

  group('Coupon tests - deletar um cupom', ()
  {
    test("Teste para delete um cupom", () async {
      String idCoupon = "2L";
      String idEstablishment = "1A";
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.delete(idEstablishment, idCoupon)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.delete(idEstablishment, idCoupon);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      String idCoupon = "2L";
      String idEstablishment = "1A";

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.delete(idEstablishment, idCoupon);
      expect(false, response.success);
    });
  });
}
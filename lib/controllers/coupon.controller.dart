
import 'package:vendas_mais_manager/constants/error.message.constants.dart';
import 'package:vendas_mais_manager/models/entities/coupon.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/coupon.repository.dart';
import 'package:vendas_mais_manager/repositories/coupon.repository.interface.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';

class CouponController {

  ICouponRepository repository;
  ConnectComponent connect;

  CouponController(){
    repository = new CouponRepository();
    connect = new ConnectComponent();
  }

  CouponController.test(this.repository, this.connect);

  Future<ValidateResponse> delete(String idEstablishment, String idCoupon) async {
    ValidateResponse response = new ValidateResponse();
    if(idCoupon != null) {
      if (await connect.checkConnect()) {
        repository.delete(idEstablishment, idCoupon);
        response.success = true;
      } else {
        response.failConnect();
      }
    } else {
      response.message = ErrorMessages.notFoundCoupon;
    }
    return response;
  }

  Future<ValidateResponse> save(String idEstablishment, Coupon coupon, String value) async {
    ValidateResponse response = new ValidateResponse();
    coupon.value = double.parse(value);
    if (await connect.checkConnect()) {
      repository.save(idEstablishment, coupon);
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

}
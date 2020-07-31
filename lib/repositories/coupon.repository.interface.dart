import 'package:vendas_mais_manager/models/entities/coupon.entity.dart';

abstract class ICouponRepository {

  Future<Coupon> get(String code, String idEstablishment);

  Future<String> generateCode(String idEstablishment);

  void save(String idEstablishment, Coupon coupon);

  void delete(String idEstablishment, String idCoupon);
}
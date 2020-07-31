
import 'package:vendas_mais_manager/models/entities/payments.entity.dart';

abstract class IPaymentRepository {

  Future<Payments> getId(String idPayment, String idEstablishment);

  Future<List<Payments>> getAll(String id);

  void update(String idEstablishment, Payments data);
}
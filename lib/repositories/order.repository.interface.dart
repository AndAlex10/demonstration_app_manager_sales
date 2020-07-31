
import 'package:vendas_mais_manager/models/entities/order.entity.dart';

abstract class IOrderRepository {

  Future<OrderData> getOrderId(String id);

  Future<List<OrderData>> getTab(String id, int tab);

  Future<Map> getStatistic(String idEstablishment);

  void updateStatus(OrderData orderData);

  void cancel(OrderData orderData);

  Future<int> getCountOrdersPending(String id);

  Future<List<OrderData>> getAll(String id);

  Future<String> searchDeliveryMan(OrderData orderData);

}
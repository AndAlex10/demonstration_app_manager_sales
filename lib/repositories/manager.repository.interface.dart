import 'package:vendas_mais_manager/models/entities/manager.entity.dart';

abstract class IManagerRepository {

  Future<ManagerEntity> load();

  void updateRating(String id);



}

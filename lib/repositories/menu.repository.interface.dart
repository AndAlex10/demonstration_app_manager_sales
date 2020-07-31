import 'package:vendas_mais_manager/models/entities/menu.entity.dart';

abstract class IMenuRepository{

  Future<List<MenuData>> getAll(String idEstablishment);

  Future<void> update(String idEstablishment, MenuData data);

}
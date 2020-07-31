import 'package:vendas_mais_manager/models/entities/menu.entity.dart';
import 'package:vendas_mais_manager/models/entities/options.entity.dart';
import 'package:vendas_mais_manager/models/entities/product.entity.dart';

abstract class IProductRepository {

  Future<List<ProductData>> getAll(String idEstablishment, MenuData menuData, String search);

  void update(String idEstablishment, ProductData data);

  void updateOption(String idEstablishment, ProductData productData, OptionsData data);

  void setOptions(ProductData productData, String idEstablishment,  MenuData menuData);


}
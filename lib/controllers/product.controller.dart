
import 'package:vendas_mais_manager/models/entities/menu.entity.dart';
import 'package:vendas_mais_manager/models/entities/options.entity.dart';
import 'package:vendas_mais_manager/models/entities/product.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/product.repository.dart';
import 'package:vendas_mais_manager/repositories/product.repository.interface.dart';
import 'package:vendas_mais_manager/view_model/products.view.model.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';

class ProductController {

  IProductRepository repository;
  ConnectComponent connect;

  ProductController(){
    repository = new ProductRepository();
    connect = new ConnectComponent();
  }

  ProductController.tests(this.repository, this.connect);

  Future<ProductsViewModel> getAll(String idEstablishment, MenuData menuData, String search) async {
    var viewModel = new ProductsViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.list = await repository.getAll(idEstablishment, menuData, search);
    }

    return viewModel;
  }

  Future<ValidateResponse> update(String idEstablishment, ProductData data, bool active) async{
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      data.active = active;
      repository.update(idEstablishment, data);
      response.success = true;
    } else {
      response.failConnect();
    }
    return response;
  }

  Future<ValidateResponse> updateOption(String idEstablishment, ProductData productData, OptionsData data, bool active) async{
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      data.active = active;
      repository.updateOption(idEstablishment, productData, data);
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }
}
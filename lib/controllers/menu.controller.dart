
import 'package:vendas_mais_manager/models/entities/menu.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/menu.repository.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/repositories/menu.repository.interface.dart';
import 'package:vendas_mais_manager/view_model/menu.view.model.dart';

class MenuController {

  IMenuRepository repository;
  ConnectComponent connect;

  MenuController(){
    repository = new MenuRepository();
    connect = new ConnectComponent();
  }

  MenuController.tests(this.repository, this.connect);

  Future<MenuViewModel> getAll(String idEstablishment) async{
    MenuViewModel viewModel = MenuViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.list = await repository.getAll(idEstablishment);
    }
    return viewModel;
  }

  Future<ValidateResponse> update(String idEstablishment, MenuData data, bool active) async{
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      data.active = active;
      await repository.update(idEstablishment, data);
      response.success = true;
    } else {
      response.failConnect();
    }
    return response;
  }
}
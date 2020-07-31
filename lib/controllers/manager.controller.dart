
import 'package:vendas_mais_manager/models/entities/manager.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/manager.repository.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/repositories/manager.repository.interface.dart';

class ManagerController {

  IManagerRepository repository;
  ConnectComponent connect;

  ManagerController(){
    repository = new ManagerRepository();
    connect = new ConnectComponent();
  }

  ManagerController.tests(this.repository, this.connect);

  Future<ManagerEntity> load() async {
    ManagerEntity managerEntity;
    if(await connect.checkConnect()) {
      managerEntity = await repository.load();
    }
    return managerEntity;
  }


  Future<ValidateResponse> updateRating(String id) async {
    ValidateResponse response = new ValidateResponse();
    if (id != null) {
      if (await connect.checkConnect()) {
        repository.updateRating(id);
        response.success = true;
      } else {
        response.failConnect();
      }
    }
    return response;
  }

}
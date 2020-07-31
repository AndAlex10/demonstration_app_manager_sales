
import 'package:vendas_mais_manager/constants/error.message.constants.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.dart';
import 'package:vendas_mais_manager/repositories/signInEmailAccount.repository.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/repositories/signInEmailAccount.repository.interface.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class SignInEmailAccountController {

  ISignInEmailAccountRepository repository;
  EstablishmentRepository establishmentRepository;
  ConnectComponent connect;

  SignInEmailAccountController(){
    repository = new SignInEmailAccountRepository();
    establishmentRepository = new EstablishmentRepository();
    connect = new ConnectComponent();
  }

  SignInEmailAccountController.tests(this.repository, this.establishmentRepository, this.connect);

  Future<ValidateResponse> signIn(AppStore store, String email, String pass) async {
    store.setLoading(true);
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      store.manager = await repository.signIn(email, pass);
      if (store.manager != null) {
        store.establishment = await establishmentRepository.getId(
            store.manager.idEstablishment);

        store.configFirebaseListeners();
        response.success = true;
      } else {
        response.message = ErrorMessages.failLogin;
      }

    } else {
      response.failConnect();
    }
    store.setLoading(false);
    return response;
  }

  Future<ValidateResponse> signOut(AppStore appStore) async {
    ValidateResponse response = new ValidateResponse();
    appStore.setManager(null);
    if(await connect.checkConnect()) {
      repository.signOut();
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

}
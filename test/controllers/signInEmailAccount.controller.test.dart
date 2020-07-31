import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/constants/error.message.constants.dart';
import 'package:vendas_mais_manager/controllers/signInEmailAccount.controller.dart';
import 'package:vendas_mais_manager/models/entities/establishment.entity.dart';
import 'package:vendas_mais_manager/models/entities/manager.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.dart';
import 'package:vendas_mais_manager/repositories/establishment.repository.interface.dart';
import 'package:vendas_mais_manager/repositories/signInEmailAccount.repository.dart';
import 'package:vendas_mais_manager/repositories/signInEmailAccount.repository.interface.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';


class SignInEmailAccountRepositoryMock extends Mock implements SignInEmailAccountRepository  {}
class EstablishmentRepositoryMock extends Mock implements EstablishmentRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class MockAppStore extends Mock implements AppStore  {}

void main(){
  SignInEmailAccountController controller;
  ConnectComponent connect;
  ISignInEmailAccountRepository repository;
  IEstablishmentRepository establishmentRepository;
  MockAppStore appStore;

  setUp(() {
    repository = SignInEmailAccountRepositoryMock();
    establishmentRepository = EstablishmentRepositoryMock();
    connect = MockConnect();
    controller = SignInEmailAccountController.tests(repository, establishmentRepository, connect);
    appStore = MockAppStore();
  });

  group('Sign In tests', ()
  {
    test("Test Sign In", () async {
      String email = "test@gmail.com";
      String pass = "123456";
      ManagerEntity managerEntity = new ManagerEntity();
      managerEntity.idEstablishment = "1L";

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signIn(any, any)).thenAnswer((_) async =>
          Future.value(managerEntity));

      when(appStore.manager).thenAnswer((_) =>managerEntity);

      when(establishmentRepository.getId("1L")).thenAnswer((_) async =>
          Future.value(new EstablishmentData()));

      ValidateResponse response = await controller.signIn(appStore, email, pass);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Test Sign In - Fail", () async {
      String email = "test@gmail.com";
      String pass = "123456";
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signIn(email, pass)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.signIn(appStore, email, pass);
      expect(response != null, true);
      expect(response.success, false);
      expect(response.message, ErrorMessages.failLogin);
    });

    test("Teste de falha de conexão", () async {
      String email = "test@gmail.com";
      String pass = "123456";
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.signIn(appStore, email, pass);
      expect(false, response.success);
    });
  });

  group('Sign Out tests', ()
  {
    test("sign out", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signOut()).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.signOut(appStore);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.signOut(appStore);
      expect(false, response.success);
    });
  });

}
import 'package:vendas_mais_manager/models/entities/manager.entity.dart';

abstract class ISignInEmailAccountRepository{

  Future<ManagerEntity> signIn(String email, String pass);

  Future<void> signOut();
}
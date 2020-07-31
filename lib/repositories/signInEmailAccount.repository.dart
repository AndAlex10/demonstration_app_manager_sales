import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vendas_mais_manager/models/entities/manager.entity.dart';
import 'package:vendas_mais_manager/repositories/signInEmailAccount.repository.interface.dart';

class SignInEmailAccountRepository implements ISignInEmailAccountRepository {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser fbUser;

  @override
  Future<ManagerEntity> signIn(String email, String pass) async {
    ManagerEntity userEntity;

    await auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      fbUser = user;

      if (fbUser != null) {
        DocumentSnapshot doc = await Firestore.instance
            .collection("???")
            .document(fbUser.uid)
            .get();

        if(doc.data != null) {
          userEntity = ManagerEntity.fromMap(doc.data);
        }
      }

    }).catchError((e) {
      userEntity = null;
    });

    return userEntity;
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }


}
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/controllers/signInEmailAccount.controller.dart';
import 'package:vendas_mais_manager/utils/validators.fields.dart';
import 'package:vendas_mais_manager/views/home.view.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class LoginView extends StatefulWidget {
  final bool out;

  LoginView(this.out);

  @override
  _LoginViewState createState() => _LoginViewState(this.out);
}

class _LoginViewState extends State<LoginView> {
  final bool out;
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _LoginViewState(this.out);


  SignInEmailAccountController _controller = new SignInEmailAccountController();

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));
          return Future.value(true);
        },
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("Entrar"),
              centerTitle: true,
            ),
            body: FutureBuilder(
                future: outAccount(out, appStore),
                builder: (context, snapshot) {
                  return Observer(
                    builder: (_) {
                      if (appStore.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Form(
                          key: _formKey,
                          child: ListView(
                            padding: EdgeInsets.all(16.0),
                            children: <Widget>[
                              TextFormField(
                                controller: _userController,
                                decoration: InputDecoration(
                                    hintText: "Usuário (Email)"),
                                validator: FieldValidator.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                  controller: _passController,
                                  decoration:
                                      InputDecoration(hintText: "Senha"),
                                  obscureText: true,
                                  validator: FieldValidator.validatePassword),
                              SizedBox(
                                height: 16.0,
                              ),
                              SizedBox(
                                height: 44.0,
                                child: RaisedButton(
                                  child: Text(
                                    "Entrar",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  textColor: Colors.white,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {}
                                    _controller
                                        .signIn(appStore, _userController.text,
                                            _passController.text)
                                        .then((result) async {
                                      if (result.success) {
                                        _onSuccess();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeView()));
                                      } else {
                                        await WidgetsCommons.message(
                                            context, result.message, true);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                })));
  }

  void _onSuccess() {
    WidgetsCommons.onSucess(_scaffoldKey, 'Login efetuado com sucesso!');
  }

  Future<Null> outAccount(bool out, AppStore store) async {
    if (out && store.isLoggedIn()) {
      SignInEmailAccountController account = new SignInEmailAccountController();
      account.signOut(store);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/controllers/signInEmailAccount.controller.dart';
import 'package:vendas_mais_manager/views/establishment/establishment.view.dart';
import 'package:vendas_mais_manager/views/login.view.dart';
import 'package:vendas_mais_manager/views/payments/payments.tab.view.dart';
import 'package:vendas_mais_manager/views/widgets/login.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';

class ConfigurationTabView extends StatefulWidget {
  @override
  _ConfigurationTabViewState createState() => _ConfigurationTabViewState();
}

class _ConfigurationTabViewState extends State<ConfigurationTabView> {
  SignInEmailAccountController _controller = new SignInEmailAccountController();

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return Scaffold(body: Observer(builder: (_) {
        if (appStore.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (!appStore.isLoggedIn()) {
          return GetLoginView();
        } else
          return ListView(
            children: <Widget>[
              optionsConfig(context, "Estabelecimento", EstablishmentView()),
              optionsConfig(context, "Formas de pagamento", PaymentsTabView()),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Card(
                  child: SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        'Sair',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.black87,
                      color: Colors.white,
                      onPressed: () async{
                        if (appStore.isLoggedIn()) {
                          await _controller
                              .signOut(appStore).then((val) async{
                                if(val.success) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) =>
                                          LoginView(false)));
                                } else {
                                  await WidgetsCommons.message(context, val.message, true);
                                }
                          });
                        }

                      },
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      side: new BorderSide(color: Colors.black12, width: 2.0)),
                ),
              )
            ],
          );
      },
    ));
  }
}

Widget optionsConfig(BuildContext context, String title, Widget widget) {
  return Card(
      child: ListTile(
          title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      IconButton(
        icon: Icon(Icons.arrow_forward_ios, size: 20.0),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widget));
        },
      ),
    ],
  )));
}

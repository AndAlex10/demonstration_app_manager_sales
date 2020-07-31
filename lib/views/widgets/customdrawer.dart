import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/controllers/establishment.controller.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';
import 'package:vendas_mais_manager/views/login.view.dart';
import 'package:vendas_mais_manager/views/widgets/drawer.tile.view.dart';

class CustomDrawer extends StatefulWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);
  @override
  _CustomDrawerState createState() => _CustomDrawerState(pageController);
}

class _CustomDrawerState extends State<CustomDrawer> {
  final PageController pageController;

  _CustomDrawerState(this.pageController);

  EstablishmentController _controller = new EstablishmentController();
  @override
  Widget build(BuildContext context) {
    var store = Provider.of<AppStore>(context);
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [Colors.white12, Colors.white],
              begin: Alignment.center,
              end: Alignment.bottomCenter)),
    );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 32.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 210.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        'É pra Já Delivery',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  !store.isLoggedIn()
                                      ? SizedBox(
                                    height: 44.0,
                                    child: RaisedButton(
                                      child: Text(
                                        "ENTRAR",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      textColor: Colors.white,
                                      color: Colors.green,
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginView(false)));
                                      },
                                    ),
                                  )
                                      : Container(
                                    width: 230.0,
                                    child: Text(
                                      store.establishment.name,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  store.isLoggedIn()
                                      ? SizedBox(
                                    height: 44.0,
                                    child: RaisedButton(
                                      child: Text(
                                        store.establishment == null
                                            ? "FECHADO"
                                            : store.establishment.open
                                            ? "ABERTO"
                                            : "FECHADO",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      textColor: Colors.white,
                                      color: store.establishment == null
                                          ? Colors.red
                                          : store.establishment.open
                                          ? Colors.green
                                          : Colors.red,
                                      onPressed: () async {
                                        await _controller.openClose(store.establishment).then((_){
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  )
                                      : SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              )
                            ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Inicio', pageController, 0),
              DrawerTile(Icons.list, 'Cardápio', pageController, 1),
              DrawerTile(
                  Icons.playlist_add_check, 'Pedidos', pageController, 2),
              DrawerTile(Icons.show_chart, 'Estatística ', pageController, 3),
              DrawerTile(Icons.star, 'Cupons', pageController, 4),
              DrawerTile(
                  Icons.brightness_5, 'Configurações', pageController, 5),
            ],
          )
        ],
      ),
    );
  }
}


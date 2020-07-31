import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/controllers/menu.controller.dart';
import 'package:vendas_mais_manager/view_model/menu.view.model.dart';
import 'package:vendas_mais_manager/views/products/menu.tile.view.dart';
import 'package:vendas_mais_manager/views/widgets/connect.fail.dart';
import 'package:vendas_mais_manager/views/widgets/login.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class MenuTabView extends StatefulWidget {
  @override
  _MenuTabViewState createState() => _MenuTabViewState();
}

class _MenuTabViewState extends State<MenuTabView> {
  final _controller = new MenuController();
  @override
  Widget build(BuildContext context) {
    var store = Provider.of<AppStore>(context);
    return Scaffold(
        body: Observer(builder: (_) {
            if (store.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (!store.isLoggedIn()) {
              return GetLoginView();
            }  else
              return FutureBuilder<MenuViewModel>(
                future: _controller.getAll(store.manager.idEstablishment),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.data.checkConnect) {
                    return Center(child: ConnectFail((){
                      setState(() { });}
                      ));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.list.length,
                      itemBuilder: (context, index) {
                        return MenuTileView(snapshot.data.list[index]);
                      },
                    );
                  }
                },
              );
          },
        ));
  }

}
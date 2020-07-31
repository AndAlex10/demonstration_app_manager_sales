import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';
import 'package:vendas_mais_manager/views/orders/order.view.dart';
import 'package:vendas_mais_manager/views/widgets/login.dart';
import 'package:badges/badges.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';

class OrderTabView extends StatefulWidget {
  @override
  _OrderTabViewState createState() => _OrderTabViewState();
}

class _OrderTabViewState extends State<OrderTabView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var store = Provider.of<AppStore>(context);
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: new PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: new Container(
                height: 50.0,
                child: new TabBar(
                  indicatorColor: WidgetsCommons.buttonColor(),
                  labelColor: Colors.black87,
                  labelStyle:
                  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(
                      icon: Badge(
                        shape: BadgeShape.square,
                        borderRadius: 5,
                        position: BadgePosition.topRight(top: -12, right: -20),
                        padding: EdgeInsets.all(2),
                        badgeContent: Observer(builder: (_) {
                          return Text(store.countOrderPending > 0 ? 'New(${store.countOrderPending})' : "",
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          );
                        }),
                        child: Text(
                          'Andamento',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    Tab(
                      text: 'Finalizados',
                    ),
                    Tab(
                      text: 'Cancelados',
                    ),
                  ],
                ),
              ),
            ),
            body:
            Observer(builder: (_) {
              if (store.isLoading)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (!store.isLoggedIn()) {
                return GetLoginView();
              } else {
                return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      OrdersView(0),
                      OrdersView(1),
                      OrdersView(2),
                    ]);
              }
            }))
    );
  }
}


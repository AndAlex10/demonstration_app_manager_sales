import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/controllers/order.controller.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';
import 'package:vendas_mais_manager/view_model/order.view.model.dart';
import 'package:vendas_mais_manager/views/orders/order.tile.view.dart';
import 'package:vendas_mais_manager/views/widgets/connect.fail.dart';
import 'package:vendas_mais_manager/views/widgets/login.dart';

class OrdersView extends StatefulWidget {
  final int orderTab;

  OrdersView(this.orderTab);

  @override
  _OrdersViewState createState() => _OrdersViewState(this.orderTab);
}

class _OrdersViewState extends State<OrdersView> {
  final int orderTab;

  _OrdersViewState(this.orderTab);

  OrderController _controller = new OrderController();

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<AppStore>(context);
    return Observer(builder: (_) {
      if (store.isLoggedIn()) {
        return FutureBuilder<OrderViewModel>(
          future: _controller.getTab(
              store.establishment.id, this.orderTab),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.data.checkConnect) {
              return Center(child: ConnectFail(() {
                setState(() {});
              }));
            } else if (store.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data.list
                    .map((data) => OrderTileView(data))
                    .toList(),
              );
            }
          },
        );
      } else {
        return GetLoginView();
      }
    });
  }
}

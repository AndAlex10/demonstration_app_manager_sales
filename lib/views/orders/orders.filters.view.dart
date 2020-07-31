import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/controllers/order.controller.dart';
import 'package:vendas_mais_manager/stores/order.store.dart';
import 'package:vendas_mais_manager/view_model/order.view.model.dart';
import 'package:vendas_mais_manager/views/orders/orders.list.view.dart';
import 'package:vendas_mais_manager/views/widgets/connect.fail.dart';
import 'package:vendas_mais_manager/views/widgets/login.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class OrdersFiltersView extends StatefulWidget {
  @override
  _OrdersFiltersViewState createState() => _OrdersFiltersViewState();
}

class _OrdersFiltersViewState extends State<OrdersFiltersView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _controller = new OrderController();

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    var orderStore = Provider.of<OrderStore>(context);
    return Scaffold(
        key: _scaffoldKey,
        body: Observer(
          builder: (_) {
            if (appStore.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (!appStore.isLoggedIn()) {
              return GetLoginView();
            } else {
              return FutureBuilder<OrderViewModel>(
                  future: _controller.getAll(appStore.establishment.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.data.checkConnect) {
                      return Center(child: ConnectFail(_refresh));
                    } else {
                      orderStore.setListOrderAll(snapshot.data.list);
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.black12, width: 2.0)),
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: <Widget>[
                                Observer(builder: (_) {
                                  return WidgetsCommons.widgetCheckBox(
                                      orderStore.activeDate,
                                      orderStore.setActiveDate,
                                      "Por período");
                                }),
                                Observer(builder: (_) {
                                  return WidgetsCommons.widgetDate(
                                      "Início",
                                      orderStore.activeDate
                                          ? orderStore.getStartDateString()
                                          : "Não Habilitado", () {
                                    _updateStartDate(orderStore);
                                  }, orderStore.activeDate);
                                }),
                                Observer(builder: (_) {
                                  return WidgetsCommons.widgetDate(
                                      "Final",
                                      orderStore.activeDate
                                          ? orderStore.getEndDateString()
                                          : "Não Habilitado", () {
                                    _updateEndDate(orderStore);
                                  }, orderStore.activeDate);
                                }),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    "Situação do pedido",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                ),
                                Observer(builder: (_) {
                                  return ChipsChoice<String>.multiple(
                                    value: orderStore.tags,
                                    options: ChipsChoiceOption.listFrom<String,
                                        String>(
                                      source: orderStore.options,
                                      value: (i, v) => v,
                                      label: (i, v) => v,
                                    ),
                                    onChanged: (val) => orderStore.setTags(val),
                                  );
                                }),
                                SizedBox(
                                  height: 30.0,
                                ),
                                _search(appStore, orderStore),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  });
            }
          },
        ));
  }

  _updateStartDate(OrderStore store) async {
    DateTime dateTime = await WidgetsCommons.getShowDate(context);
    store.setStartDate(dateTime);
  }

  _updateEndDate(OrderStore store) async {
    DateTime dateTime = await WidgetsCommons.getShowDate(context);
    store.setEndDate(dateTime);
  }

  Widget _search(AppStore appStore, OrderStore orderStore) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          height: 44.0,
          child: RaisedButton(
            child: Text(
              "Buscar",
              style: TextStyle(fontSize: 18.0),
            ),
            textColor: Colors.white,
            color: WidgetsCommons.buttonColor(),
            onPressed: () async {
              await _controller.applyFilters(orderStore, appStore).then((list) {
                if (list.length == 0) {
                  WidgetsCommons.message(
                      context, "Nenhum Pedido encontrado", true);
                } else {
                  orderStore.setListOrderFiltered(list);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrdersListView()));
                }
              });
            },
          ),
        ));
  }

  _refresh() {
    setState(() {});
  }
}

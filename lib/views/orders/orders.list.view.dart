import 'package:flutter/material.dart';
import 'package:vendas_mais_manager/views/orders/order.report.view.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/order.store.dart';

class OrdersListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var orderStore = Provider.of<OrderStore>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: WidgetsCommons.buttonColor(),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text(
            'Pedidos',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.black12, width: 2.0)),
            child: Padding(
                padding: EdgeInsets.all(9.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.black12, width: 2.0)),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Filtros",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Período: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 79, 79, 79),
                                      fontSize: 17.0),
                                ),
                                orderStore.activeDate
                                    ? Text(
                                        "${orderStore.getStartDateString()} á ${orderStore.getEndDateString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17.0),
                                      )
                                    : Text(
                                        "Nenhum",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17.0),
                                      )
                              ],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Situação do Pedido: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 79, 79, 79),
                                      fontSize: 17.0),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                                    child: Text(
                                      "${orderStore.getStatusText() == "" ? "Todos" : orderStore.getStatusText()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17.0),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Total: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 79, 79, 79),
                                      fontSize: 22.0),
                                ),
                                Text(
                                  "R\$${orderStore.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Pedidos",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 79, 79, 79),
                          fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: new NeverScrollableScrollPhysics(),
                      itemCount: orderStore.listFiltered.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return OrderReportView(orderStore.listFiltered[index]);
                      },
                    ),
                  ],
                ))));
  }
}

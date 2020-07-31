import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';
import 'package:vendas_mais_manager/enums/status.order.enum.dart';
import 'package:vendas_mais_manager/views/orders/order.detail.view.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';

class OrderReportView extends StatefulWidget {
  final OrderData order;

  OrderReportView(this.order);

  @override
  _OrderReportViewState createState() => _OrderReportViewState(this.order);
}

class _OrderReportViewState extends State<OrderReportView> {
  final OrderData order;
  DateTime date;
  StatusOrder statusOrder;

  _OrderReportViewState(this.order);

  @override
  void initState() {
    // TODO: implement initState
    date = order.dateCreate.toDate();
    statusOrder = StatusOrder.values[order.status];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => OrderDetailView(order)));
      },
      child: Card(
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.black12, width: 1.0)),
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${order.orderCode} - ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 79, 79, 79),
                            fontSize: 16.0),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).primaryColor,
                              size: 16.0,
                            ),
                            Text(
                              " ${DateFormat('dd/MM/yyyy HH:mm a').format(date)}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0),
                            ),
                          ]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: Text(
                          "${StatusOrderText.getTitle(StatusOrder.values[order.status])} ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.black54)),
                      ),
                      order.rating != null
                          ? Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 8.0,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14.0,
                                ),
                                Text(
                                  "${order.rating}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.amber),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Valor: ",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16.0),
                      ),
                      Text(
                        "R\$${order.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16.0),
                      ),
                    ],
                  ),
                  order.status != StatusOrder.CANCELED.index
                      ? SizedBox()
                      : Text(
                          "Motivo: " + order.reason,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14.0),
                          textAlign: TextAlign.start,
                        ),
                  Divider(),
                  Text(
                    "Ver Detalhes",
                    style: TextStyle(color: WidgetsCommons.buttonColor()),
                    textAlign: TextAlign.center,
                  )
                ],
              ))),
    );
  }
}

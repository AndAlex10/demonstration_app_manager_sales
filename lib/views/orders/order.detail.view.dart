import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendas_mais_manager/controllers/order.controller.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';
import 'package:vendas_mais_manager/constants/method.payment.constants.dart';
import 'package:vendas_mais_manager/enums/status.order.enum.dart';
import 'package:vendas_mais_manager/views/orders/order.items.tile.view.dart';
import 'package:vendas_mais_manager/views/orders/order.reason.view.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class OrderDetailView extends StatefulWidget {
  final OrderData order;
  OrderDetailView(this.order);

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState(this.order);
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final OrderData order;

  DateTime date;
  StatusOrder statusOrder;

  _OrderDetailViewState(this.order);

  OrderController _controller = new OrderController();

  @override
  void initState() {
    // TODO: implement initState
    date = order.dateCreate.toDate();
    statusOrder = StatusOrder.values[order.status];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Pedido"),
          centerTitle: true,
        ),
        body: Observer(builder: (_) {
          if (appStore.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {return Card(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child:ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    _detailOrder(),
                    _getStatusOrder(appStore)
            ])),
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.black12, width: 2.0)),
          );}})
        );
  }

  Widget _getStatusOrder(AppStore store) {
    statusOrder = StatusOrder.values[order.status];
    if (statusOrder == StatusOrder.PENDING) {
      return _pendentStatus(store);
    } else if (statusOrder != StatusOrder.CANCELED &&
        statusOrder != StatusOrder.CONCLUDED) {
      return _updateStatus(store);
    } else {
      return SizedBox(
        height: 2.0,
      );
    }
  }

  Widget _updateStatus(AppStore store) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          height: 44.0,
          child: RaisedButton(
            child: Text(
              StatusOrderText.getNextStatus(statusOrder),
              style: TextStyle(fontSize: 14.0),
            ),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: statusOrder.index < StatusOrder.READY_FOR_DELIVERY.index ? () {
              _controller.updateStatus(store, order, StatusOrder.values[statusOrder.index + 1]).then((val) async{
                if(val.success) {
                  store.setCountOrderPending(store.countOrderPending - 1);
                } else {
                  await WidgetsCommons.message(context, val.message, true);
                }
              });
            } : null,
          ),
        ));
  }

  Widget _pendentStatus(AppStore store) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 44.0,
              child: RaisedButton(
                child: Text(
                  '  REJEITAR  ',
                  style: TextStyle(fontSize: 18.0),
                ),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          OrderReasonView(order)));
                },
              ),
            ),
            SizedBox(
              height: 44.0,
              child: RaisedButton(
                child: Text(
                  '  APROVAR  ',
                  style: TextStyle(fontSize: 18.0),
                ),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async{
                  _controller.updateStatus(store, order, StatusOrder.IN_PRODUCTION).then((val){
                    if(val.success) {
                      setState(() {});
                    }
                  });

                },
              ),
            )
          ],
        ));
  }

  Widget _detailOrder(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Pedido ${order.orderCode}",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 16.0),
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

        order.rating != null ? Row(
          children: <Widget>[
            Text(
              "Avaliação: ",
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.grey),
            ),
            Icon(Icons.star, color: Colors.amber, size: 14.0,),
            Text(
              "${order.rating}",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.amber),
            ),
          ],
        ) : SizedBox(),
        Divider(),

        order.status == StatusOrder.CANCELED.index ? _reason() : SizedBox(),

        ListView.builder(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemCount: order.items.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return ItemOrderTileView(order.items[index]);
          },
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Cliente: ${order.nameClient.toUpperCase()}",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 16.0),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          order.address,
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 14.0),
        ),
        Text(
          "Número: " + order.number,
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 14.0),
        ),
        Container(
          width: 230.0,
          child: Text(
            "Complemento: " + order.complement,
            maxLines: 3,
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 14.0),
          ),
        ),
        Text(
          "Bairro: " + order.neighborhood,
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 14.0),
        ),
        FlatButton(
          child: Text(
            "Telefone: " + order.phone,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
                color: Theme.of(context).primaryColor),
          ),
          textColor: Colors.blue,
          padding: EdgeInsets.zero,
          onPressed: () {
            launch("tel:${order.phone}");
          },
        ),
        Divider(),


        Text(
          'Resumo do Pedido',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('SubTotal'),
            Text('R\$ ${order.productsPrice.toStringAsFixed(2)}')
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Desconto'),
            Text('R\$ ${order.discount.toStringAsFixed(2)}')
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Taxa de entrega'),
            Text(
              order.shipPrice == 0
                  ? "Grátis"
                  : 'R\$ ${order.shipPrice.toStringAsFixed(2)}',
              style: TextStyle(
                  color: order.shipPrice == 0
                      ? Colors.green
                      : Colors.black),
            )
          ],
        ),
        Divider(),
        SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'R\$ ${order.amount.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ],
        ),

        Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(order.payment.inDelivery ?  'Pagamento na entrega' : "Crédito pelo Aqui Tem",
                style: TextStyle(fontWeight: FontWeight.w500, color: order.payment.inDelivery ? Colors.red : Colors.black87)),
            order.payment.image != null
                ? Image.asset(
              order.payment.image,
              width: 25,
              height: 25,
              fit: BoxFit.contain,
            )
                : SizedBox(),
          ],
        ),

        order.payment.method.toUpperCase() == MethodPayment.money ?
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Troco: ', style: TextStyle(fontWeight: FontWeight.w500)),
            Text(order.change == 0 ? 'Não precisa' : "para R\$${order.change.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w400)),

          ],
        ) : SizedBox(),
        Divider(),

        SizedBox(
          height: 5.0,
        ),
        Text(
          'Histórico',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(order.historicText),
        Divider(),
      ],

    );
  }


  Widget _reason(){
    return
      Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child:  Container(
            width: 800.0,
            child:  Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Motivo do cancelamento',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              order.reason,
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 14.0),
              textAlign: TextAlign.start,
            ),

            Text(
              "Cancelado por: " + order.reasonBy,
              style: TextStyle(
                  fontWeight: FontWeight.w300, fontSize: 14.0),
              textAlign: TextAlign.start,
            ),
          ],
        ))),
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black38, width: 2.0)),
      );
  }
}

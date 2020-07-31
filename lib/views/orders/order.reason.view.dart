
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/controllers/order.controller.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';
import 'package:vendas_mais_manager/utils/validators.fields.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class OrderReasonView extends StatelessWidget {
  final OrderData orderData;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _reasonController = TextEditingController();
  final _controller = new OrderController();

  OrderReasonView(this.orderData);

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text('Motivo da Rejeição'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor),
        key: _scaffoldKey,
        body:  Observer(builder: (_) {
      if (appStore.isLoading) {
        return Center(child: CircularProgressIndicator());
      } else { return Form(
          key: _formKey,
          child: Container(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                            labelText: 'Digite o motivo aqui',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                                fontSize: 22.0,
                                fontStyle: FontStyle.normal,
                                color: Colors.black)),
                        enabled: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        validator: FieldValidator.validateReason,
                      ),
                      RaisedButton(
                        child: Text(
                          'Confirmar cancelamento',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: WidgetsCommons.buttonColor(),
                        onPressed:  () async {
                          if(_formKey.currentState.validate()) {
                            orderData.reason = _reasonController.text;
                            await _controller.cancel(appStore, orderData).then((val) async{
                              if(val.success) {
                                WidgetsCommons.onSucess(_scaffoldKey, "Pedido cancelado!");
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.of(context).pop();
                              } else {
                                await WidgetsCommons.message(context, val.message, true);
                              }
                            });
                          }

                        }
                        ,
                      )

                    ],
                  )
                ],
              )),

        );}})
    );
  }
}



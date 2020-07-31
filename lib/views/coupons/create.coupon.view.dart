import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendas_mais_manager/controllers/coupon.controller.dart';
import 'package:vendas_mais_manager/models/entities/coupon.entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vendas_mais_manager/utils/validators.fields.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class CreateCouponView extends StatefulWidget {
  final Coupon data;
  CreateCouponView(this.data);

  @override
  _CreateCouponViewState createState() => _CreateCouponViewState(data);
}

class _CreateCouponViewState extends State<CreateCouponView> {
  final Coupon data;
  final _valueController = TextEditingController();
  final format = DateFormat("dd-MM-yyyy");
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _controller = new CouponController();

  _CreateCouponViewState(this.data);

  @override
  void initState() {
    if (data.id != '') {
      _valueController.text = data.value.toStringAsFixed(2);
    } 
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text('Cadastros de Cupons'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor),
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              data.id != "" ?
              Column(children: <Widget>[
                Text(
                  "Código",
                  style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 45.0,),
                  Text(
                    data.code,
                    style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(icon: Icon(Icons.content_copy, color: WidgetsCommons.buttonColor(),), onPressed: () {
                    Clipboard.setData(new ClipboardData(text: data.code));
                    WidgetsCommons.onSucess(_scaffoldKey, "Código copiado!");
                  }),
                ],),

                SizedBox(
                  height: 15.0,
                )
              ],) : SizedBox(),

              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(
                    labelText: 'Valor R\$', labelStyle: TextStyle(fontSize: 25.0)),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                enabled: true,
                validator: FieldValidator.validateValue,
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  child: Text(
                    data.dateExpirationFormat != null
                        ? 'Data Expiração : ' + data.dateExpirationFormat
                        : 'Data Expiração',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    DateTime date = await WidgetsCommons.getShowDate(context);
                    if(date != null) {
                      data.dateExpiration = Timestamp.fromDate(date);
                      var formatter = new DateFormat('dd/MM/yyyy');
                      data.dateExpirationFormat = formatter.format(data.dateExpiration.toDate());
                      setState(() { });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 44.0,
              ),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  child: Text(
                    'Salvar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await _controller.save(appStore.establishment.id, data, _valueController.text).then((result) async{
                        if(result.success){
                          _onSuccess();
                        } else {
                          await WidgetsCommons.message(context, result.message, true);
                        }
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  child: Text(
                    'Excluir',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: data.id != ''
                      ? () async {
                          await _controller.delete(appStore.establishment.id, data.id).then((val) async{
                            if(val.success) {
                              Navigator.of(context).pop();
                            } else {
                              await WidgetsCommons.message(context, val.message, true);
                            }
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),
        ));
  }

  void _onSuccess() {
    WidgetsCommons.onSucess(_scaffoldKey, 'Cupom salvo com sucesso!');
    Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() {

      });
    });
  }


}

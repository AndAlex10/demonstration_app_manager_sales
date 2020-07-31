import 'package:flutter/material.dart';
import 'package:vendas_mais_manager/controllers/payment.controller.dart';
import 'package:vendas_mais_manager/models/entities/payments.entity.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class PaymentsTileView extends StatefulWidget {
  final Payments data;
  PaymentsTileView(this.data);

  @override
  _PaymentsTileViewState createState() => _PaymentsTileViewState(data);
}

class _PaymentsTileViewState extends State<PaymentsTileView> {

  final Payments data;
  _PaymentsTileViewState(this.data);

  PaymentController _controller = new PaymentController();

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return Card( child:ListTile(
          leading: Image.asset(
            data.image,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
          Expanded(child: Text(data.title, style: TextStyle(fontSize: 17.0, color: Colors.black),)),
              Checkbox(
                value: data.active,
                onChanged: (bool value) async{
                  await _controller.update(appStore.manager.idEstablishment, data, value).then((val) async{
                    if(val.success) {
                      setState(() {});
                    } else {
                      await WidgetsCommons.message(context, val.message, true);
                    }
                  });
                },
              ),
          ],),
        ),
        );
  }
}

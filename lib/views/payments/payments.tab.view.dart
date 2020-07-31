import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/controllers/payment.controller.dart';
import 'package:vendas_mais_manager/view_model/payment.view.model.dart';
import 'package:vendas_mais_manager/views/payments/payments.tile.view.dart';
import 'package:vendas_mais_manager/views/widgets/connect.fail.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';


class PaymentsTabView extends StatefulWidget {
  @override
  _PaymentsTabViewState createState() => _PaymentsTabViewState();
}

class _PaymentsTabViewState extends State<PaymentsTabView> {
  final _controller = new PaymentController();

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Formas de Pagamento"),
          centerTitle: true,
        ),
        body:
        Observer(builder: (_) {
          if (appStore.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }else
            return FutureBuilder<PaymentViewModel>(
              future: _controller.getAll(appStore.manager.idEstablishment),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.data.checkConnect) {
                  return Center(child: ConnectFail((){
                    setState(() {});
                  }));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.list.length,
                    itemBuilder: (context, index) {
                      return PaymentsTileView(snapshot.data.list[index]);
                    },
                  );
                  /**/

                }
              },
            );
        }));
  }
}

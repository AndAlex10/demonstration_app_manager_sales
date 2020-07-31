import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/controllers/order.controller.dart';
import 'package:vendas_mais_manager/view_model/statistic.view.model.dart';
import 'package:vendas_mais_manager/views/statistics/graphics.view.dart';
import 'package:vendas_mais_manager/views/widgets/connect.fail.dart';
import 'package:vendas_mais_manager/views/widgets/login.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class StatisticsView extends StatefulWidget {
  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  var _controller = new OrderController();

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return Scaffold(body: Observer(builder: (_) {
        if (appStore.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (!appStore.isLoggedIn()) {
          return GetLoginView();
        } else
          return FutureBuilder<StatisticViewModel>(
              future:
                  _controller.getStatistic(appStore.manager.idEstablishment),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.data.checkConnect) {
                  return Center(child: ConnectFail(() {
                    setState(() {});
                  }));
                } else {
                  return Container(
                    padding: new EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Vendas nos últimos 3 meses',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: Card(
                            child: GraphicMonthlyView.withSampleData(
                                snapshot.data.data),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              });
      },
    ));
  }
}

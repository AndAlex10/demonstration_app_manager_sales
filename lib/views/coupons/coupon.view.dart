import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/models/entities/coupon.entity.dart';
import 'package:vendas_mais_manager/views/coupons/coupon.tile.view.dart';
import 'package:vendas_mais_manager/views/coupons/create.coupon.view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/views/widgets/login.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class CouponTabView extends StatefulWidget {
  @override
  _CouponTabViewState createState() {
    return new _CouponTabViewState();
  }
}

class _CouponTabViewState extends State<CouponTabView> {
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
      }  else
        return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("establishments").document(appStore.manager.idEstablishment).collection("coupons")
              .where("dateExpiration", isGreaterThanOrEqualTo: DateTime.now())
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return Form(
                child: Column(
                  //padding: EdgeInsets.all(10.0),
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        Coupon data =
                            Coupon.fromDocument(snapshot.data.documents[index]);
                        return CouponTileView(data);
                      },
                    )),
                    SizedBox(
                      height: 14.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          'Adicionar Cupom',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Coupon data = Coupon();
                          data.id = '';
                          data.code = '';
                          data.value = 0.00;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CreateCouponView(data)));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                  ],
                ),
              );
            }
          },
        );
    }));
  }
}

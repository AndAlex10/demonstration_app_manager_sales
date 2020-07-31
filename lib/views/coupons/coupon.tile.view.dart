import 'package:flutter/material.dart';
import 'package:vendas_mais_manager/views/coupons/create.coupon.view.dart';
import 'package:vendas_mais_manager/models/entities/coupon.entity.dart';

class CouponTileView extends StatelessWidget {
  final Coupon data;

  CouponTileView(this.data);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateCouponView(data)));
        },
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(
                  " ${data.code} ",
                  style: TextStyle(
                      fontSize: 25.0,
                      //backgroundColor: Colors.grey,
                      color: Colors.brown, fontWeight: FontWeight.w500),

                ),
                SizedBox(height: 10.0,),
                Text(
                  ' DESCONTO: R\$' + data.value.toStringAsFixed(2),
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
                Text(
                  ' VALIDADE: ' + data.dateExpirationFormat,
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ],
            ),
          ),
        ));
  }
}

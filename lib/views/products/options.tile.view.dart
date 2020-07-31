
import 'package:flutter/material.dart';
import 'package:vendas_mais_manager/controllers/product.controller.dart';
import 'package:vendas_mais_manager/models/entities/options.entity.dart';
import 'package:vendas_mais_manager/models/entities/product.entity.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class OptionsTileView extends StatefulWidget {

  final ProductData productData;
  final OptionsData data;
  OptionsTileView(this.data, this.productData);
  @override
  _OptionsTileViewState createState() => _OptionsTileViewState(this.data, this.productData);
}

class _OptionsTileViewState extends State<OptionsTileView> {
  final ProductData productData;
  final OptionsData data;
  _OptionsTileViewState(this.data, this.productData);


  ProductController _controller = new ProductController();

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Checkbox(
            value: data.active,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool value) async {
              await _controller
                  .updateOption(appStore.manager.idEstablishment,
                  productData, data, value)
                  .then((val) async{
                if(val.success) {
                  setState(() {});
                } else {
                  await WidgetsCommons.message(context, val.message, true);
                }
              });
            },
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.title,
                    style: TextStyle(
                        fontSize: 19.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "R\$ ${data.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )),
        ],
      ),

    );
  }
}


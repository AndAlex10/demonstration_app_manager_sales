import 'package:flutter/material.dart';
import 'package:vendas_mais_manager/controllers/product.controller.dart';
import 'package:vendas_mais_manager/models/entities/product.entity.dart';
import 'package:vendas_mais_manager/views/products/options.tile.view.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class ProductTileView extends StatefulWidget {
  final ProductData data;

  ProductTileView(this.data);

  @override
  _ProductTileViewState createState() => _ProductTileViewState(data);
}

class _ProductTileViewState extends State<ProductTileView> {
  final ProductData data;

  _ProductTileViewState(this.data);

  ProductController _controller = new ProductController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<AppStore>(context);
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              value: data.active,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool value) async {
                await _controller
                    .update(store.manager.idEstablishment,
                        data, value)
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
                child: data.options ? _productWithOptions() : _productSimple()),
          ],
        ),
      ),
    );
  }

  Widget _productSimple() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          data.title,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 19.0, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        data.description != null
            ? Text(
                data.description,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              )
            : SizedBox(),
        Text(
          "R\$ ${data.price.toStringAsFixed(2)}",
          style: TextStyle(
              fontSize: 17.0, color: Colors.green, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget _productWithOptions() {
    return
    ExpansionTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                data.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 19.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              )
            ]),
        children:
            data.optionsList.map((op) => OptionsTileView(op, data)).toList());

  }
}

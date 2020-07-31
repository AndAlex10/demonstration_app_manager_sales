import 'package:flutter/material.dart';
import 'package:vendas_mais_manager/controllers/product.controller.dart';
import 'package:vendas_mais_manager/models/entities/menu.entity.dart';
import 'package:vendas_mais_manager/view_model/products.view.model.dart';
import 'package:vendas_mais_manager/views/products/product.tile.view.dart';
import 'package:vendas_mais_manager/views/widgets/connect.fail.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class ProductsTabView extends StatefulWidget {
  final MenuData menuData;
  ProductsTabView(this.menuData);
  @override
  _ProductsTabViewState createState() => _ProductsTabViewState(this.menuData);
}

class _ProductsTabViewState extends State<ProductsTabView> {
  final MenuData menuData;
  final _controller = new ProductController();
  _ProductsTabViewState(this.menuData);


  @override
  Widget build(BuildContext context) {
    var store = Provider.of<AppStore>(context);
    return Scaffold(
        appBar: AppBar(
        title: Text(this.menuData.name)),
        body:  FutureBuilder<ProductsViewModel>(
                future: _controller.getAll(store.manager.idEstablishment, menuData, ""),
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
                        return ProductTileView(snapshot.data.list[index]);
                      },
                    );
                  }
                },
              )
    );
  }
}
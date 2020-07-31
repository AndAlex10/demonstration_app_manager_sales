import 'package:flutter/material.dart';
import 'package:vendas_mais_manager/controllers/menu.controller.dart';
import 'package:vendas_mais_manager/models/entities/menu.entity.dart';
import 'package:vendas_mais_manager/views/products/products.tab.view.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class MenuTileView extends StatefulWidget {
  final MenuData data;

  MenuTileView(this.data);

  @override
  _MenuTileViewState createState() => _MenuTileViewState(data);
}

class _MenuTileViewState extends State<MenuTileView> {
  final MenuData data;

  _MenuTileViewState(this.data);

  MenuController _controller = new MenuController();

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Checkbox(
              value: data.active,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool value) async {
                await _controller.update(store.manager.idEstablishment, data, value).then((val) async{
                  if(val.success) {
                    setState(() {});
                  } else {
                    await WidgetsCommons.message(context, val.message, true);
                  }
                });
              },
            ),
            Expanded(
                child: Text(
              data.name,
              style: TextStyle(fontSize: 19.0, color: Colors.black, fontWeight: FontWeight.w400),
            )),
            IconButton(
              icon: Icon( Icons.arrow_forward_ios, size: 20.0),
              color: Theme.of(context).primaryColor,
              onPressed:  () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProductsTabView(data))
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

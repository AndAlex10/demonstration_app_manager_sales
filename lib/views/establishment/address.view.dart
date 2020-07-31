import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/controllers/api.maps.controller.dart';
import 'package:vendas_mais_manager/controllers/establishment.controller.dart';
import 'package:vendas_mais_manager/models/entities/establishment.entity.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class AddressListView extends StatefulWidget {

  final EstablishmentData data;

  AddressListView(this.data);
  @override
  _AddressListViewState createState() => _AddressListViewState(this.data);
}

class _AddressListViewState extends State<AddressListView> {

  final EstablishmentData data;

  _AddressListViewState(this.data);

  EstablishmentController _controller = EstablishmentController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Buscar Endereço'),
          centerTitle: true,
        ),
        body: Observer(builder: (_) {
            if (appStore.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return Form(
                child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: SizedBox(
                              height: 50.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black12)),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.search),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "Digite o endereço",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                textColor: Colors.black38,
                                color: Colors.white,
                                onPressed: () async{
                                  await _handlePressButton(data);
                                },
                              ),
                            )),

                      ],
                    ),
              );
            }
          },
        ));
  }

  void _onSuccess() {
    WidgetsCommons.onSucess(_scaffoldKey, 'Endereço Atualizado!');
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  Future<void> _handlePressButton(EstablishmentData data) async {
    ApiMapsController maps = new ApiMapsController();
    await maps.getKeyMap().then((val) async{
      if(val.success) {
        Prediction p = await PlacesAutocomplete.show(
          context: context,
          apiKey: maps.key,
          onError: onError,
          language: "pt",
          components: [Component(Component.country, "br")],
        );

        PlacesDetailsResponse response = await maps.getPlaceDetail(p);
        if (response != null) {
          _refreshAddress(data, response);
        }
      } else {
        await WidgetsCommons.message(context, val.message, true);
      }
    });


  }

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  void _refreshAddress(EstablishmentData data, PlacesDetailsResponse detail) async {
    await _controller.refreshAddress(data, detail).then((result) async{
      if(result.success){
        _onSuccess();
      } else {
        await WidgetsCommons.message(context, result.message, true);
      }
    });
  }
}

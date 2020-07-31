import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vendas_mais_manager/controllers/establishment.controller.dart';
import 'package:vendas_mais_manager/views/establishment/address.view.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';
import 'package:vendas_mais_manager/models/entities/establishment.entity.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';

class EstablishmentView extends StatefulWidget {
  @override
  _EstablishmentViewState createState() => _EstablishmentViewState();
}

class _EstablishmentViewState extends State<EstablishmentView> {
  final _docNumberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _neighborhoodCtrl = TextEditingController();
  final _complementCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codePostalCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _controller = EstablishmentController();

  @override
  Widget build(BuildContext context) {
    var appStore = Provider.of<AppStore>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Estabelecimento"),
          centerTitle: true,
        ),
        body: Observer(builder: (_) {
            if (appStore.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              setData(appStore.establishment);
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    WidgetsCommons.createTextFormField(
                        'Estabelecimento*', '', _nameCtrl, true, true),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField(
                        'CNPJ', '', _docNumberCtrl, false, true),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField(
                        'Endereço', '', _addressCtrl, false, false),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField(
                        'Número', '', _numberCtrl, false, true),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField(
                        'Bairro', '', _neighborhoodCtrl, false, false),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField(
                        'Complemento', '', _complementCtrl, false, true),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField(
                        'Cidade', '', _cityCtrl, false, false),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField(
                        'UF', '', _stateCtrl, false, false),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField(
                        'CEP', '', _codePostalCtrl, false, false),
                    SizedBox(
                      height: 16.0,
                    ),
                    WidgetsCommons.createTextFormField(
                        'Telefone', '', _phoneCtrl, false, true),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          'Atualizar Endereço',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AddressListView(appStore.establishment)));
                        }
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          'Alterar dados',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _controller.alter(appStore, _nameCtrl.text, _docNumberCtrl.text,
                                _numberCtrl.text, _phoneCtrl.text, _complementCtrl.text).then((result) async{
                                  if(result.success){
                                    WidgetsCommons.onSucess(_scaffoldKey, 'Salvo com sucesso!');
                                  } else {
                                    await WidgetsCommons.message(context, result.message, true);
                                  }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }

  void setData(EstablishmentData establishmentData){
    _nameCtrl.text = establishmentData.name;
    _docNumberCtrl.text = establishmentData.cnpj;
    _addressCtrl.text = establishmentData.address;
    _cityCtrl.text = establishmentData.city;
    _numberCtrl.text = establishmentData.number;
    _stateCtrl.text = establishmentData.state;
    _neighborhoodCtrl.text = establishmentData.neighborhood;
    _phoneCtrl.text = establishmentData.phone;
    _complementCtrl.text = establishmentData.complement;
    _codePostalCtrl.text = establishmentData.codePostal;
  }


}

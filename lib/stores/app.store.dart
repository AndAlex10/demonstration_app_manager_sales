
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobx/mobx.dart';
import 'package:vendas_mais_manager/config/firebase_messaging.dart';
import 'package:vendas_mais_manager/config/rabbitmq.config.dart';
import 'package:vendas_mais_manager/controllers/establishment.controller.dart';
import 'package:vendas_mais_manager/controllers/manager.controller.dart';
import 'package:vendas_mais_manager/models/entities/establishment.entity.dart';
import 'package:vendas_mais_manager/models/entities/order.entity.dart';
import 'package:vendas_mais_manager/models/entities/manager.entity.dart';
import "package:dart_amqp/dart_amqp.dart";

part 'app.store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  int countOrderPending = 0;

  @observable
  FirebaseMessaging fbMessaging;

  @observable
  ManagerEntity manager;

  @observable
  EstablishmentData establishment;

  @observable
  bool isLoading = false;

  @observable
  List<OrderData> orderList = [];

  Client connectionRabbit;

  _AppStore(this.fbMessaging){
    loadCurrentUser();
    configRabbitMQ();
  }

  @action
  void setLoading(bool loading){
    this.isLoading = loading;
  }

  bool isLoggedIn() {
    return manager != null && establishment != null;
  }

  @action
  void setManager(ManagerEntity manager){
    this.manager = manager;
  }

  @action
  void setCountOrderPending(int pCountOrderPending){
    countOrderPending = pCountOrderPending;
  }

  @action
  void setEstablishment(EstablishmentData data){
    this.establishment = data;
  }

  Future<bool> loadCurrentUser() async {
    if(this.manager == null && !this.isLoading) {
      ManagerController _controller = new ManagerController();
      this.manager = await _controller.load();

      if (this.manager != null) {
        await _controller.updateRating(manager.idEstablishment);
        await _loadEstablishment();
        configFirebaseListeners();
      }
      return true;
    } else {
      return false;
    }
  }

  Future<Null> _loadEstablishment() async {
    EstablishmentController _controllerEstablishment = new EstablishmentController();
    this.setEstablishment(await _controllerEstablishment.getId(manager.idEstablishment));
  }

  void configFirebaseListeners() {
    if (manager.idEstablishment != null) {
      FirebaseConfig.config(fbMessaging, manager.idEstablishment);
    }
  }

  void configRabbitMQ() async{
    RabbitMQConfig rabbitMQConfig = new RabbitMQConfig();
    try {
      ConnectionSettings settingsRabbitMQ = await rabbitMQConfig.connect();
      connectionRabbit = new Client(settings: settingsRabbitMQ);
    } on ConnectionFailedException catch(e){
      print(e.message);
    } catch(e){
      print(e.toString());
    }
  }

}
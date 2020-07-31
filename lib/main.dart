import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';
import 'package:vendas_mais_manager/stores/order.store.dart';
import 'package:vendas_mais_manager/views/home.view.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(VendaMaisApp());
}

class VendaMaisApp extends StatefulWidget {
  @override
  _VendaMaisAppState createState() => _VendaMaisAppState();
}

class _VendaMaisAppState extends State<VendaMaisApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppStore>(
          create:  (_) => AppStore(new FirebaseMessaging()),
        ),
        Provider<OrderStore>.value(
          value: OrderStore(),
        )
      ],
      child: MaterialApp(
              title: 'Home Delivery',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 251, 116, 2),
              ),
              debugShowCheckedModeBanner: false,
              home: HomeView()));

  }
}


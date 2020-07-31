import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:vendas_mais_manager/controllers/order.controller.dart';
import 'package:vendas_mais_manager/stores/app.store.dart';
import 'package:vendas_mais_manager/views/orders/orders.filters.view.dart';
import 'package:vendas_mais_manager/views/statistics/statistics.view.dart';
import 'package:vendas_mais_manager/views/products/menu.view.dart';
import 'package:vendas_mais_manager/views/establishment/configuration.view.dart';
import 'package:vendas_mais_manager/views/coupons/coupon.view.dart';
import 'package:vendas_mais_manager/views/orders/order.tab.view.dart';
import 'package:vendas_mais_manager/views/widgets/customdrawer.dart';
import 'package:vendas_mais_manager/views/widgets/widgets_commons.dart';

 class HomeView extends StatefulWidget {
   @override
   _HomeViewState createState() => _HomeViewState();
 }

 class _HomeViewState extends State<HomeView> {
   final _pageController = PageController();

   OrderController _controller = new OrderController();
   @override
   Widget build(BuildContext context) {
     var store = Provider.of<AppStore>(context);
     return PageView(
       controller: _pageController,
       physics: NeverScrollableScrollPhysics(),
       children: <Widget>[
         Scaffold(
           appBar: AppBar(
             title: Observer(builder: (_) {  return Text(store.isLoggedIn() ? store.establishment.name : "Venda+ Delivery" , style: TextStyle(color: Colors.white));}),
             centerTitle: true,
             backgroundColor: Theme.of(context).primaryColor,
             actions: <Widget>[
               Container(
                 padding: EdgeInsets.only(right: 8.0),
                 alignment: Alignment.center,
                 child: IconButton(icon: Icon(Icons.refresh), onPressed: () async{
                     await _controller.getCountOrdersPending(store).then((val) async{
                       if(!val.success){
                         await WidgetsCommons.message(context, val.message, true);
                       }
                     });
                 })
               )
             ],
           ),
           body:  OrderTabView(),
           drawer: CustomDrawer(_pageController),
         ),
         menu(context, "Cardápio", MenuTabView(), _pageController),
         menu(context, "Pedidos", OrdersFiltersView(), _pageController),
         menu(context, "Estatísticas", StatisticsView(), _pageController),
         menu(context, "Cupons", CouponTabView(), _pageController),
         menu(context, "Configurações", ConfigurationTabView(), _pageController),
       ],
     );
   }

   Widget menu(BuildContext context, String title, Widget widget,
       PageController pageController) {
     return WillPopScope(
         onWillPop: () async {
           pageController.jumpToPage(pageController.initialPage);
           return false;
         },
         child: Scaffold(
           appBar: AppBar(
             iconTheme: new IconThemeData(color: Colors.white),
             title: Text(title, style: TextStyle(color: Colors.white)),
             centerTitle: true,
             backgroundColor: Theme.of(context).primaryColor,
           ),
           drawer: CustomDrawer(pageController),
           body: widget,
         ));
   }
 }

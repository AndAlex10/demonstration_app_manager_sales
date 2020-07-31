
class PaymentOrder{
  String title;
  String method;
  String image;
  bool inDelivery;
  String paymentId;

  PaymentOrder();
  PaymentOrder.fromMap(Map data){
    title = data['title'];
    method = data['method'];
    image = data['image'];
    inDelivery = data['inDelivery'];
    paymentId = data['paymentId'];
  }

}
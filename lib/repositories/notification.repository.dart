
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/repositories/notification.repository.interface.dart';

class NotificationRepository implements INotificationRepository {

  @override
  Future<Null> create(String idUser, String title, String subject)async{
    await Firestore.instance.collection("???").add(
        {
          "???": title,
          "???": subject,
          "???": idUser,
        }
    );
  }
}
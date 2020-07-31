
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseConfig {

  static void config(FirebaseMessaging fbMessaging, String topic){
    fbMessaging.subscribeToTopic(topic);

    fbMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }
}


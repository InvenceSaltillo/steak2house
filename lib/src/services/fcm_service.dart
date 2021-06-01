import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:steak2house/src/services/user_service.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

class FCMService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  // P8 KeyId: FYUG65B8A3

  static Future _onBackGroundHandler(RemoteMessage message) async {
    print('_onBackGroundHandler ${message.messageId}');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('_onMessageHandler ${message.notification!.title}');

    Dialogs.instance.showSnackBar(
      DialogType.success,
      '${message.data['product']}',
      false,
    );
    // Get.to(() => MyCreditCards());
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('_onMessageOpenApp ${message.data}');
  }

  static Future initializeApp() async {
    // Push notifications

    await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();

    await UserService.instance.updateField(token!, 'fcmToken');

    print('FCM TOKEN $token');

    // Handlers

    FirebaseMessaging.onBackgroundMessage(_onBackGroundHandler);

    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('FCM STATUS ${settings.authorizationStatus}');
  }
}

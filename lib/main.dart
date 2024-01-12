import 'package:climarec/home.dart';
import 'package:climarec/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:climarec/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  //////print("Handling a background message: ${message.messageId}");
}

void main() async {
  //BISMILLAH
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // REQUEST NOTIFICATIONS PERMISSION
  await Permission.notification.request();
  //FIREBASE NOOTIFICATION

  // FirebaseMessaging _fcm=FirebaseMessaging.instance;

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    LocalNotificationsService().showFlutterNotification(message);
    // LocalNotificationsService().showAwesomeNotification(message);
  });
  await LocalNotificationsService().pushNotificationListener();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Climarec',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Climarec',
      ),
    );
  }
}

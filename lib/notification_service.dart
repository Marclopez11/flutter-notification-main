import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:climarec/constants.dart';
import 'package:climarec/url.dart';
import 'package:climarec/webview_cont.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LocalNotificationsService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const channelID = 'high_importance_channel';
  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse? notificationResponse) async {
    if (notificationResponse != null) {
      if (notificationResponse.payload != null) {
        final cont = Get.find<WebviewCont>();

        String url = extractUrl(notificationResponse.payload!);
        if (isURL(url)) {
          log('url' + url);
          cont.url.value = url;
          await cont.launchWebView(url);
        } else {
          await cont.launchWebView(AppUrls.webviewUrl);
        }
      }
    }
  }

  //INITIALIZE LOCAL NOTIFICATIONS
  void initializeNotifications() async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = const DarwinInitializationSettings();
    requestNotificationPermissions();
    var initializeSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: notificationTapBackground,
    );
    await pushNotificationListener();
  }

  //PERMISSION FOR NOTIFICATIONS
  static Future<void> requestNotificationPermissions() async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelID, channelID,
        playSound: true, importance: Importance.max);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void showFlutterNotification(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        bool isImgNotification = false;
        String largeIconPath = '';
        String bigPicturePath = '';
        String? url;

        if (Platform.isAndroid) {
          url = message.notification?.android?.imageUrl;
        } else {
          url = message.notification?.apple?.imageUrl;
        }

        isImgNotification = url != null;
        BigPictureStyleInformation? bigPictureStyleInformation;
        log(notification.apple?.imageUrl ?? "NOT IMAGE");
        if (isImgNotification) {
          final img = await loadImageAndConvertToBase64(url);
          bigPictureStyleInformation = BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(base64Encode(img)),
            hideExpandedLargeIcon: true,
            largeIcon:
                ByteArrayAndroidBitmap.fromBase64String(base64Encode(img)),
          );

          largeIconPath = await _downloadAndSaveFile(
            url,
            'largeIcon',
            Platform.isIOS,
          );
          bigPicturePath = await _downloadAndSaveFile(
            url,
            'bigPicture',
            Platform.isIOS,
          );
        }

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channelID, channelID,
                    icon: 'launch_background',
                    channelDescription: 'App notifications',
                    importance: Importance.max,
                    priority: Priority.max,
                    largeIcon: url == null
                        ? null
                        : FilePathAndroidBitmap(largeIconPath),
                    styleInformation:
                        url == null ? null : bigPictureStyleInformation),
                // ignore: unnecessary_null_comparison
                iOS: url == null
                    ? const DarwinNotificationDetails()
                    : DarwinNotificationDetails(attachments: [
                        DarwinNotificationAttachment(bigPicturePath)
                      ])),
            payload: message.data['click_action']);
      } else {
        print("ELSE ${message.toMap().toString()}");
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', e.toString());
    }
  }

  Future<List<int>> loadImageAndConvertToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    List<int> imageData = response.bodyBytes;
    return imageData;
  }

  Future<String> _downloadAndSaveFile(
      String url, String fileName, bool isIOS) async {
    final Directory? directory = isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
    final String filePath = '${directory!.path}/$fileName.png';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  void showNotifyTest() {
    try {
      flutterLocalNotificationsPlugin.show(
          0,
          " notification.title",
          "notification.body",
          NotificationDetails(
            android: AndroidNotificationDetails(
              channelID,
              channelID,
              icon: 'launch_background',
            ),
          ),
          payload: 'https://dotsinc.org');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  //LISTENER WHEN APP OPENED
  pushNotificationListener() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data['click_action'] != null) {
        final cont = Get.find<WebviewCont>();
        cont.url.value = 'HELLO URL FOUND';
        log('message');
        String body = extractUrl(message.data['click_action']);
        if (isURL(body)) {
          cont.url.value = body;
          await cont.launchWebView(body);
        } else {
          await cont.launchWebView(AppUrls.webviewUrl);
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      Get.snackbar('BACKGROUND FETCH', "HELLO ${message.data}");
      if (message.data['click_action'] != null) {
        final cont = Get.find<WebviewCont>();
        cont.url.value = 'HELLO URL FOUND';
        log(message.data.toString());
        String body = extractUrl(message.data['click_action']);
        if (isURL(body)) {
          cont.url.value = body;
          await cont.launchWebView(body);
        } else {
          await cont.launchWebView(AppUrls.webviewUrl);
        }
      }
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null && message.data['click_action'] != null) {
        final cont = Get.find<WebviewCont>();
        cont.url.value = 'HELLO URL FOUND';
        log('initial message');
        String body = extractUrl(message.data['click_action']);
        if (isURL(body)) {
          cont.url.value = body;
          await cont.launchWebView(body);
        } else {
          await cont.launchWebView(AppUrls.webviewUrl);
        }
      }
    });
  }
}

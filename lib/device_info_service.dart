import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveDeviceInfoService {
  //SAVE USER DEVICE INFO IN FIREBASE
  static Future<void> saveDeviceInfo() async {
    try {
      String? deviceID = await _getUserDeviceID();
      log('toke devide id ${deviceID}');

      String? deviceName = await _getUserDeviceName();
      log('toke devide id ${deviceName}');

      String? fcmToken = await _getFCMToken();

      log('toke devide id : ${fcmToken}');
      final document = await FirebaseFirestore.instance
          .collection('UserDevices')
          .doc(fcmToken)
          .get();
      //IF NOT EXIST
      if (!document.exists) {
        await FirebaseFirestore.instance
            .collection('UserDevices')
            .doc(deviceID)
            .set({
          'DeviceName': deviceName,
          'DeviceID': deviceID,
          'FCMtoken': fcmToken,
        });
      }
    } catch (e) {
      print('Ocurrió un error al obtener el token: $e');

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
        content: Text(
          'Something went wrong',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  //GET USER DEVICE ID
  static Future<String?> _getUserDeviceID() async {
    String? deviceID;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.id;
    }
    return deviceID;
  }

  //GET USER DEVICE NAME
  static Future<String?> _getUserDeviceName() async {
    String? deviceName;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceName = iosDeviceInfo.name;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceName = androidDeviceInfo.model;
    }
    return deviceName;
  }

  //GET USER DEVICE FCM TOKEN
  static Future<String?> _getFCMToken() async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    //GENERATING A TOKEN FROM FIREBASE MESSAGING
    log('fcm ${fcm}');

    final apnsToken = await fcm.getAPNSToken();
    log('apnsToken ${apnsToken}');

    String? token = '';

    token = await fcm.getToken();

    log('token ${token}');

    return token;
  }
}

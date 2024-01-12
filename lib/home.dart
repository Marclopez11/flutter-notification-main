import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'webview_cont.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({
    super.key,
    required this.title,
  });
  final String title;
  final cont = Get.put(WebviewCont());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        /*appBar: AppBar(
          title: Obx(
            () => Text(
              cont.url.isEmpty ? "N/A" : cont.url.value,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          // actions: [IconButton(onPressed: () =>LocalNotificationsService().showNotifyTest(), icon: Icon(Icons.add))],
        ),*/
        body: Obx(() => cont.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : cont.controller.value == null
                ? const SizedBox()
                : WebViewWidget(controller: cont.controller.value!)),
      ),
    );
  }
}

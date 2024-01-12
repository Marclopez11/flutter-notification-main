import 'package:climarec/device_info_service.dart';
import 'package:climarec/notification_service.dart';
import 'package:climarec/url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebviewCont extends GetxController {
  RxBool isLoading = true.obs;
  RxString url = ''.obs;
  Rxn<WebViewController> controller = Rxn<WebViewController>();

  initliazeWebview() async {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController cont =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    cont
      ..setBackgroundColor(Colors.white)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          /*if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }*/

          return NavigationDecision.navigate;
        },
        onUrlChange: (UrlChange change) {},
      ));
    controller.value = cont;

    //INITIALIZE LOCAL NOTIFICATION
    LocalNotificationsService().initializeNotifications();
    //SAVING USER INFORMATION
    await SaveDeviceInfoService.saveDeviceInfo();

    //INITIALIZE
    if (url.value == '') {
      await launchWebView(AppUrls.webviewUrl);
    }
    isLoading.value = false;
  }

  launchWebView(String url) async {
    isLoading.value = true;
    controller.value!.loadRequest(Uri.parse(url));
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    initliazeWebview();
  }
}


//  String body = extractUrl(message.notification!.body!);
//         if (isURL(body)) {
//           log('BODY FORGEGHOUND:$body');
        
//           isLoading = true;
//           setState(() {});
//           await cont.controller.value!.loadRequest(Uri.parse(body));
//           isLoading = false;
//           setState(() {});
//         }
//       }

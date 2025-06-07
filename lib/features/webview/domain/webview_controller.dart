import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class WebViewController {
  late final webview.WebViewController _controller;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  WebViewController() {
    _initController();
  }

  void _initController() {
    _controller = webview.WebViewController()
      ..setJavaScriptMode(webview.JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        webview.NavigationDelegate(
          onPageStarted: (String url) {
            isLoading.value = true;
            errorMessage.value = null;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
          },
          onWebResourceError: (webview.WebResourceError error) {
            errorMessage.value = 'Error: ${error.description}';
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..enableZoom(false)
      ..setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
      ..loadRequest(
        Uri.parse(AppConstants.baseUrl),
        headers: {
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
        },
      );
  }

  void reload() {
    errorMessage.value = null;
    _controller.reload();
  }

  webview.WebViewController get controller => _controller;
} 
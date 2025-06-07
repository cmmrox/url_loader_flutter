import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../domain/webview_controller.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/components/offline_view/offline_view.dart';
import '../../../core/components/loading_indicator/loading_indicator.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _webViewController;
  late final ConnectivityService _connectivityService;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController();
    _connectivityService = ConnectivityService();
    _initConnectivity();
  }

  void _initConnectivity() {
    _connectivityService.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
        if (!_isOffline) {
          _webViewController.reload();
        }
      });
    });
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (!_isOffline) webview.WebViewWidget(controller: _webViewController.controller),
          if (_isOffline)
            OfflineView(
              onRetry: () => _webViewController.reload(),
            ),
          ValueListenableBuilder<bool>(
            valueListenable: _webViewController.isLoading,
            builder: (context, isLoading, child) {
              return isLoading && !_isOffline
                  ? const LoadingIndicator()
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
} 
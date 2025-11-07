import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../domain/webview_controller.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/url_config_service.dart';
import '../../../core/components/offline_view/offline_view.dart';
import '../../../core/components/loading_indicator/loading_indicator.dart';
import '../../admin/presentation/admin_settings_page.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _webViewController;
  late final ConnectivityService _connectivityService;
  late final UrlConfigService _urlConfigService;
  bool _isOffline = false;
  
  // Secret tap gesture tracking
  int _tapCount = 0;
  DateTime? _lastTapTime;
  static const int _requiredTaps = 5;
  static const Duration _tapTimeout = Duration(seconds: 2);
  static const double _cornerSize = 50.0;

  @override
  void initState() {
    super.initState();
    _urlConfigService = UrlConfigService.instance;
    _connectivityService = ConnectivityService();
    _initializeWebView();
    _initConnectivity();
    _initUrlListener();
  }

  Future<void> _initializeWebView() async {
    await _urlConfigService.loadBaseUrl();
    if (mounted) {
      setState(() {
        _webViewController = WebViewController(initialUrl: _urlConfigService.baseUrl);
      });
    }
  }

  void _initConnectivity() {
    _connectivityService.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
        if (!_isOffline && _webViewController != null) {
          _webViewController!.reload();
        }
      });
    });
  }

  void _initUrlListener() {
    _urlConfigService.baseUrlNotifier.addListener(_onUrlChanged);
  }

  void _onUrlChanged() {
    if (mounted && _webViewController != null) {
      final newUrl = _urlConfigService.baseUrl;
      if (_webViewController!.currentUrl != newUrl) {
        _webViewController!.loadUrl(newUrl);
      }
    }
  }

  void _handleTap(Offset position) {
    final now = DateTime.now();
    
    // Check if tap is in top-left corner
    if (position.dx > _cornerSize || position.dy > _cornerSize) {
      _resetTapCount();
      return;
    }

    // Reset if timeout exceeded
    if (_lastTapTime != null && now.difference(_lastTapTime!) > _tapTimeout) {
      _resetTapCount();
    }

    _lastTapTime = now;
    _tapCount++;

    if (_tapCount >= _requiredTaps) {
      _resetTapCount();
      _openAdminSettings();
    }
  }

  void _resetTapCount() {
    _tapCount = 0;
    _lastTapTime = null;
  }

  Future<void> _openAdminSettings() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AdminSettingsPage(),
      ),
    );
    
    // URL change is handled by listener, but we can reload if needed
    if (result == true && mounted && _webViewController != null) {
      _webViewController!.reload();
    }
  }

  @override
  void dispose() {
    _urlConfigService.baseUrlNotifier.removeListener(_onUrlChanged);
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _webViewController == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                if (!_isOffline) webview.WebViewWidget(controller: _webViewController!.controller),
                if (_isOffline)
                  OfflineView(
                    onRetry: () => _webViewController?.reload(),
                  ),
                ValueListenableBuilder<bool>(
                  valueListenable: _webViewController!.isLoading,
                  builder: (context, isLoading, child) {
                    return isLoading && !_isOffline
                        ? const LoadingIndicator()
                        : const SizedBox.shrink();
                  },
                ),
                // Hidden gesture detector in top-left corner
                Positioned(
                  top: 0,
                  left: 0,
                  child: GestureDetector(
                    onTapDown: (details) => _handleTap(details.localPosition),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: _cornerSize,
                      height: _cornerSize,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
} 
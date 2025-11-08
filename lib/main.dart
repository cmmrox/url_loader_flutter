import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'core/theme/app_theme.dart';
import 'features/webview/presentation/webview_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  // Enable wakelock to keep screen on
  await WakelockPlus.enable();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Feedback',
      theme: AppTheme.lightTheme,
      home: const WebViewPage(),
    );
  }
}

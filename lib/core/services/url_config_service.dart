import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class UrlConfigService {
  static const String _keyBaseUrl = 'base_url';
  static const String _defaultUrl = 'http://13.201.51.161:3000';
  
  static UrlConfigService? _instance;
  
  final ValueNotifier<String> _baseUrlNotifier = ValueNotifier<String>(_defaultUrl);
  SharedPreferences? _prefs;
  
  ValueNotifier<String> get baseUrlNotifier => _baseUrlNotifier;
  
  String get baseUrl => _baseUrlNotifier.value;
  
  // Private constructor
  UrlConfigService._internal() {
    _initialize();
  }
  
  // Singleton instance getter
  static UrlConfigService get instance {
    _instance ??= UrlConfigService._internal();
    return _instance!;
  }
  
  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await loadBaseUrl();
  }
  
  Future<void> loadBaseUrl() async {
    if (_prefs == null) {
      await _initialize();
    }
    
    final savedUrl = _prefs!.getString(_keyBaseUrl);
    if (savedUrl != null && savedUrl.isNotEmpty) {
      _baseUrlNotifier.value = savedUrl;
    } else {
      _baseUrlNotifier.value = _defaultUrl;
    }
  }
  
  Future<bool> saveBaseUrl(String url) async {
    if (_prefs == null) {
      await _initialize();
    }
    
    if (!_isValidUrl(url)) {
      return false;
    }
    
    final success = await _prefs!.setString(_keyBaseUrl, url);
    if (success) {
      _baseUrlNotifier.value = url;
    }
    return success;
  }
  
  Future<void> resetToDefault() async {
    await saveBaseUrl(_defaultUrl);
  }
  
  String getDefaultUrl() => _defaultUrl;
  
  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  
  bool _isValidUrl(String url) => isValidUrl(url);
  
  void dispose() {
    _baseUrlNotifier.dispose();
  }
}


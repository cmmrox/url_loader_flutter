import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

/// A service that handles network connectivity monitoring.
/// 
/// This service provides functionality to:
/// - Monitor connectivity changes
/// - Check current connectivity status
/// - Properly dispose of resources
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;
  
  /// Stream of connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged => _connectivity.onConnectivityChanged;
  
  /// Checks if the device is currently connected to a network
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
  
  /// Disposes of the service resources
  void dispose() {
    _subscription?.cancel();
  }
} 
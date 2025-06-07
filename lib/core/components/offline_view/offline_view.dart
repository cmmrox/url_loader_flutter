import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// A reusable widget that displays an offline state with a retry button.
/// This component can be used across different features when network connectivity is lost.
class OfflineView extends StatelessWidget {
  final VoidCallback onRetry;
  final String? customMessage;
  final String? customSubMessage;

  const OfflineView({
    super.key,
    required this.onRetry,
    this.customMessage,
    this.customSubMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: AppConstants.iconSize,
            color: Colors.red,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            customMessage ?? AppConstants.noInternetMessage,
            style: const TextStyle(
              fontSize: AppConstants.titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            customSubMessage ?? AppConstants.checkConnectionMessage,
            style: const TextStyle(
              fontSize: AppConstants.subtitleFontSize,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text(AppConstants.retryButtonText),
          ),
        ],
      ),
    );
  }
} 
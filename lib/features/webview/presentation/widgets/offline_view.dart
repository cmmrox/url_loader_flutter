import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class OfflineView extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineView({
    super.key,
    required this.onRetry,
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
          const Text(
            AppConstants.noInternetMessage,
            style: TextStyle(
              fontSize: AppConstants.titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          const Text(
            AppConstants.checkConnectionMessage,
            style: TextStyle(
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
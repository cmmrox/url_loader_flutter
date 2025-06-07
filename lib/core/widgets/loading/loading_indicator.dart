import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  final double? strokeWidth;

  const LoadingIndicator({
    super.key,
    this.color,
    this.size,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth ?? 4.0,
        valueColor: color != null 
            ? AlwaysStoppedAnimation<Color>(color!) 
            : null,
      ),
    );
  }
} 
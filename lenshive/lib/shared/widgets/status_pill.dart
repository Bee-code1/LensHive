import 'package:flutter/material.dart';
import '../../design/tokens.dart';

/// Status Pill Widget - Colored pill badge for status display
class StatusPill extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const StatusPill({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? DesignTokens.primary.withOpacity(0.1);
    final txtColor = textColor ?? DesignTokens.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(DesignTokens.radiusChip),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: txtColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}


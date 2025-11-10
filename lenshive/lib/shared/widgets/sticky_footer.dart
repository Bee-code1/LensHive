import 'package:flutter/material.dart';
import '../../design/tokens.dart';

/// Sticky footer that pins above bottom nav with safe gap
/// Includes subtle elevation matching design tokens
class StickyFooter extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const StickyFooter({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.card,
        boxShadow: DesignTokens.subtleShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding ??
              EdgeInsets.all(DesignTokens.spaceLg).copyWith(
                bottom: DesignTokens.spaceMd, // 12px gap above bottom nav
              ),
          child: child,
        ),
      ),
    );
  }
}

/// Extension for easy use in Column/ListView builders
extension StickyFooterExtension on Widget {
  /// Wrap this widget with StickyFooter
  Widget withStickyFooter({EdgeInsetsGeometry? padding}) {
    return StickyFooter(
      padding: padding,
      child: this,
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_colors.dart';

/// Reusable section card wrapper for questionnaire sections
/// Provides consistent styling and spacing for question groups
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SectionCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 0.r, vertical: 8.r),
      padding: padding ?? EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(brightness),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowColor(brightness),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.getBorderColor(brightness),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

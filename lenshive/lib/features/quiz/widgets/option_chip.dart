import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_colors.dart';

/// Reusable option chip widget for questionnaire options
/// Supports both single-select (radio) and multi-select (checkbox) modes
class OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isMultiSelect;
  final bool isEnabled;

  const OptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isMultiSelect = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final primaryColor = brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary;
    
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 44.r, // Minimum touch target
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16.r,
          vertical: 12.r,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : AppColors.getCardColor(brightness),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : AppColors.getBorderColor(brightness),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selection indicator
            if (isMultiSelect)
              Container(
                width: 20.r,
                height: 20.r,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.getTextColor(brightness).withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 14.r,
                        color: primaryColor,
                      )
                    : null,
              )
            else
              Container(
                width: 20.r,
                height: 20.r,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.white
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.getTextColor(brightness).withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Container(
                        margin: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            
            SizedBox(width: 12.r),
            
            // Label text
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.r,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.getTextColor(brightness),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final isDark = theme.brightness == Brightness.dark;
    
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
              ? (isDark ? const Color(0xFF1E3A8A) : const Color(0xFF3B82F6))
              : (isDark ? const Color(0xFF374151) : Colors.white),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? (isDark ? const Color(0xFF3B82F6) : const Color(0xFF3B82F6))
                : (isDark ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB)),
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
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 14.r,
                        color: const Color(0xFF3B82F6),
                      )
                    : null,
              )
            else
              Container(
                width: 20.r,
                height: 20.r,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Container(
                        margin: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6),
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
                      ? Colors.white
                      : (isDark ? Colors.white : const Color(0xFF374151)),
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

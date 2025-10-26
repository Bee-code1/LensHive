import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_colors.dart';

/// Progress bar widget showing current step in the questionnaire
/// Displays step indicator (e.g., "1/5") and visual progress bar
class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String? title;

  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final primaryColor = brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary;
    
    final progress = currentStep / totalSteps;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator and title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentStep/$totalSteps',
                style: TextStyle(
                  fontSize: 16.r,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextColor(brightness),
                ),
              ),
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18.r,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextColor(brightness),
                  ),
                ),
            ],
          ),
          
          SizedBox(height: 8.r),
          
          // Progress bar
          Container(
            height: 6.r,
            decoration: BoxDecoration(
              color: AppColors.getBorderColor(brightness),
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

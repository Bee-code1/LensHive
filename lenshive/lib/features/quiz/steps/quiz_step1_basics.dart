import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../models/questionnaire_models.dart';
import '../state/questionnaire_controller.dart';
import '../widgets/option_chip.dart';
import '../widgets/section_card.dart';
import '../widgets/progress_bar.dart';

/// Step 1: Basic Information
class QuizStep1Basics extends ConsumerWidget {
  const QuizStep1Basics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(questionnaireProvider.notifier);
    final answer = ref.watch(questionnaireAnswerProvider);
    final brightness = Theme.of(context).brightness;
    
    // Step is valid if all required fields are filled
    final isValid = answer.whoFor != null && 
                    answer.visionNeed != null && 
                    answer.powerStrength != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.getTextColor(brightness)),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Lens Finder',
          style: TextStyle(
            fontSize: 18.r,
            fontWeight: FontWeight.w600,
            color: AppColors.getTextColor(brightness),
          ),
        ),
      ),
      body: Column(
        children: [
          ProgressBar(currentStep: 1, totalSteps: 3),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Let\'s find your perfect lenses',
                    style: TextStyle(
                      fontSize: 24.r,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextColor(brightness),
                    ),
                  ),
                  SizedBox(height: 8.r),
                  Text(
                    'Answer a few quick questions',
                    style: TextStyle(
                      fontSize: 14.r,
                      color: AppColors.getTextColor(brightness).withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 24.r),

                  // Question 1: Who are these for?
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Who will wear these glasses?',
                          style: TextStyle(
                            fontSize: 16.r,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextColor(brightness),
                          ),
                        ),
                        SizedBox(height: 12.r),
                        Wrap(
                          spacing: 10.r,
                          runSpacing: 10.r,
                          children: [
                            OptionChip(
                              label: '👤 Myself',
                              isSelected: answer.whoFor == WhoFor.myself,
                              onTap: () => controller.updateWhoFor(WhoFor.myself),
                            ),
                            OptionChip(
                              label: '👶 Child/Teen',
                              isSelected: answer.whoFor == WhoFor.childTeen,
                              onTap: () => controller.updateWhoFor(WhoFor.childTeen),
                            ),
                            OptionChip(
                              label: '👴 Senior',
                              isSelected: answer.whoFor == WhoFor.senior60,
                              onTap: () => controller.updateWhoFor(WhoFor.senior60),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.r),

                  // Question 2: Vision needs
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What do you mainly need to see clearly?',
                          style: TextStyle(
                            fontSize: 16.r,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextColor(brightness),
                          ),
                        ),
                        SizedBox(height: 12.r),
                        Wrap(
                          spacing: 10.r,
                          runSpacing: 10.r,
                          children: [
                            OptionChip(
                              label: '🚗 Far away (driving)',
                              isSelected: answer.visionNeed == VisionNeed.farAway,
                              onTap: () => controller.updateVisionNeed(VisionNeed.farAway),
                            ),
                            OptionChip(
                              label: '📱 Up close (reading)',
                              isSelected: answer.visionNeed == VisionNeed.upClose,
                              onTap: () => controller.updateVisionNeed(VisionNeed.upClose),
                            ),
                            OptionChip(
                              label: '👁️ Both equally',
                              isSelected: answer.visionNeed == VisionNeed.bothEqually,
                              onTap: () => controller.updateVisionNeed(VisionNeed.bothEqually),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.r),

                  // Question 3: Power strength
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How strong is your prescription?',
                          style: TextStyle(
                            fontSize: 16.r,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextColor(brightness),
                          ),
                        ),
                        SizedBox(height: 12.r),
                        Wrap(
                          spacing: 10.r,
                          runSpacing: 10.r,
                          children: [
                            OptionChip(
                              label: '❓ Don\'t know',
                              isSelected: answer.powerStrength == PowerStrength.unknown,
                              onTap: () => controller.updatePowerStrength(PowerStrength.unknown),
                            ),
                            OptionChip(
                              label: 'Mild (±0 to ±1.5)',
                              isSelected: answer.powerStrength == PowerStrength.mild,
                              onTap: () => controller.updatePowerStrength(PowerStrength.mild),
                            ),
                            OptionChip(
                              label: 'Moderate (±1.75 to ±3)',
                              isSelected: answer.powerStrength == PowerStrength.moderate,
                              onTap: () => controller.updatePowerStrength(PowerStrength.moderate),
                            ),
                            OptionChip(
                              label: 'Strong (±3.25+)',
                              isSelected: answer.powerStrength == PowerStrength.strong,
                              onTap: () => controller.updatePowerStrength(PowerStrength.strong),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 80.r),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.getCardColor(brightness),
          boxShadow: [
            BoxShadow(
              color: AppColors.getShadowColor(brightness),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: isValid ? () => context.push('/quiz/step2') : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isValid 
                  ? (brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary)
                  : AppColors.getBorderColor(brightness),
              padding: EdgeInsets.symmetric(vertical: 16.r),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Next',
              style: TextStyle(
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


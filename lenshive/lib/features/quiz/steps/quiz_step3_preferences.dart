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

/// Step 3: Preferences & Comfort
class QuizStep3Preferences extends ConsumerWidget {
  const QuizStep3Preferences({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(questionnaireProvider.notifier);
    final answer = ref.watch(questionnaireAnswerProvider);
    final brightness = Theme.of(context).brightness;
    
    // Step is valid if all required fields are filled
    final isValid = answer.lensWeightPref != null &&
                    answer.comforts != null && 
                    answer.comforts!.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.getTextColor(brightness)),
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
          ProgressBar(currentStep: 3, totalSteps: 3),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Almost done!',
                    style: TextStyle(
                      fontSize: 24.r,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextColor(brightness),
                    ),
                  ),
                  SizedBox(height: 8.r),
                  Text(
                    'What matters most to you?',
                    style: TextStyle(
                      fontSize: 14.r,
                      color: AppColors.getTextColor(brightness).withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 24.r),

                  // Question 1: Lens weight preference
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '⚖️ Lens thickness preference',
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
                              label: '✨ Thin & Light',
                              isSelected: answer.lensWeightPref == LensWeightPref.lightThin,
                              onTap: () => controller.updateLensWeightPref(LensWeightPref.lightThin),
                            ),
                            OptionChip(
                              label: '👍 Standard is fine',
                              isSelected: answer.lensWeightPref == LensWeightPref.standardThick,
                              onTap: () => controller.updateLensWeightPref(LensWeightPref.standardThick),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.r),

                  // Question 2: Comfort features (multi-select)
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '✨ What features matter most? (select all)',
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
                              label: '😌 Reduce eye strain',
                              isSelected: answer.comforts?.contains(Comfort.reduceEyeStrain) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.reduceEyeStrain),
                            ),
                            OptionChip(
                              label: '✨ Reduce glare',
                              isSelected: answer.comforts?.contains(Comfort.reduceGlare) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.reduceGlare),
                            ),
                            OptionChip(
                              label: '☀️ Clear in sunlight',
                              isSelected: answer.comforts?.contains(Comfort.stayClearOutdoors) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.stayClearOutdoors),
                            ),
                            OptionChip(
                              label: '🛡️ Scratch resistant',
                              isSelected: answer.comforts?.contains(Comfort.resistScratches) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.resistScratches),
                            ),
                            OptionChip(
                              label: '🪶 Very lightweight',
                              isSelected: answer.comforts?.contains(Comfort.veryLightweight) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.veryLightweight),
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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.r),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    side: BorderSide(color: AppColors.getBorderColor(brightness)),
                  ),
                  child: Text('Back', style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(width: 12.r),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: isValid ? () => _generateRecommendation(context, controller) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid 
                        ? (brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary)
                        : AppColors.getBorderColor(brightness),
                    padding: EdgeInsets.symmetric(vertical: 16.r),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Results',
                        style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.w600, color: AppColors.white),
                      ),
                      SizedBox(width: 8.r),
                      Icon(Icons.check_circle, color: AppColors.white, size: 20.r),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleComfort(QuestionnaireController controller, QuestionnaireAnswer answer, Comfort comfort) {
    final currentComforts = Set<Comfort>.from(answer.comforts ?? {});
    if (currentComforts.contains(comfort)) {
      currentComforts.remove(comfort);
    } else {
      currentComforts.add(comfort);
    }
    controller.updateComforts(currentComforts.isEmpty ? null : currentComforts);
  }

  void _generateRecommendation(BuildContext context, QuestionnaireController controller) {
    final recommendation = controller.generateRecommendation();
    context.go('/quiz/result', extra: recommendation);
  }
}


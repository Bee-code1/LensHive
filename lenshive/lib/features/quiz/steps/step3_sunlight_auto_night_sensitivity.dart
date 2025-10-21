import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../models/questionnaire_models.dart';
import '../state/questionnaire_controller.dart';
import '../widgets/option_chip.dart';
import '../widgets/section_card.dart';
import '../widgets/progress_bar.dart';

/// Step 3: Sunlight, auto-adjustment, night driving, and light sensitivity
/// Questions about outdoor time, automatic lens adjustment preferences, night driving, and light sensitivity
class Step3SunlightAutoNightSensitivity extends ConsumerWidget {
  const Step3SunlightAutoNightSensitivity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(questionnaireProvider.notifier);
    final answer = ref.watch(questionnaireAnswerProvider);
    final isStepValid = controller.isStepValid(3);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Save & exit functionality
              context.pop();
            },
            child: Text(
              'Save & exit',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          ProgressBar(
            currentStep: 3,
            totalSteps: 5,
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: Column(
                children: [
                  // Question 1: Time in bright sunlight
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time in bright sunlight most days',
                          style: TextStyle(
                            fontSize: 18.r,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 16.r),
                        Wrap(
                          spacing: 12.r,
                          runSpacing: 12.r,
                          children: [
                            OptionChip(
                              label: '<30 min',
                              isSelected: answer.sunlightTime == SunlightTime.under30min,
                              onTap: () => controller.updateSunlightTime(SunlightTime.under30min),
                            ),
                            OptionChip(
                              label: '30-120 min',
                              isSelected: answer.sunlightTime == SunlightTime.h30to120,
                              onTap: () => controller.updateSunlightTime(SunlightTime.h30to120),
                            ),
                            OptionChip(
                              label: '2-4 hrs',
                              isSelected: answer.sunlightTime == SunlightTime.h2to4,
                              onTap: () => controller.updateSunlightTime(SunlightTime.h2to4),
                            ),
                            OptionChip(
                              label: '4 + hrs',
                              isSelected: answer.sunlightTime == SunlightTime.h4plus,
                              onTap: () => controller.updateSunlightTime(SunlightTime.h4plus),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 2: Prefer auto-adjusting lenses
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Would you prefer one pair that also handles bright outdoor light automatically?',
                          style: TextStyle(
                            fontSize: 18.r,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 16.r),
                        Wrap(
                          spacing: 12.r,
                          runSpacing: 12.r,
                          children: [
                            OptionChip(
                              label: 'Yes',
                              isSelected: answer.preferAutoOutdoor == PreferAutoOutdoor.yes,
                              onTap: () => controller.updatePreferAutoOutdoor(PreferAutoOutdoor.yes),
                            ),
                            OptionChip(
                              label: 'No',
                              isSelected: answer.preferAutoOutdoor == PreferAutoOutdoor.no,
                              onTap: () => controller.updatePreferAutoOutdoor(PreferAutoOutdoor.no),
                            ),
                            OptionChip(
                              label: 'Not sure',
                              isSelected: answer.preferAutoOutdoor == PreferAutoOutdoor.notSure,
                              onTap: () => controller.updatePreferAutoOutdoor(PreferAutoOutdoor.notSure),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 3: Night driving frequency
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Night driving per week',
                          style: TextStyle(
                            fontSize: 18.r,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 16.r),
                        Wrap(
                          spacing: 12.r,
                          runSpacing: 12.r,
                          children: [
                            OptionChip(
                              label: 'Rare',
                              isSelected: answer.nightDriving == NightDriving.rare,
                              onTap: () => controller.updateNightDriving(NightDriving.rare),
                            ),
                            OptionChip(
                              label: '1-3 times',
                              isSelected: answer.nightDriving == NightDriving.h1to3,
                              onTap: () => controller.updateNightDriving(NightDriving.h1to3),
                            ),
                            OptionChip(
                              label: '4 + times',
                              isSelected: answer.nightDriving == NightDriving.h4plus,
                              onTap: () => controller.updateNightDriving(NightDriving.h4plus),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 4: Light sensitivity
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Are your eyes sensitive to light?',
                          style: TextStyle(
                            fontSize: 18.r,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 16.r),
                        Wrap(
                          spacing: 12.r,
                          runSpacing: 12.r,
                          children: [
                            OptionChip(
                              label: 'Low',
                              isSelected: answer.lightSensitivity == LightSensitivity.low,
                              onTap: () => controller.updateLightSensitivity(LightSensitivity.low),
                            ),
                            OptionChip(
                              label: 'Medium',
                              isSelected: answer.lightSensitivity == LightSensitivity.medium,
                              onTap: () => controller.updateLightSensitivity(LightSensitivity.medium),
                            ),
                            OptionChip(
                              label: 'High',
                              isSelected: answer.lightSensitivity == LightSensitivity.high,
                              onTap: () => controller.updateLightSensitivity(LightSensitivity.high),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100.r), // Space for navigation buttons
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Back button
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go('/quiz/step2'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.r),
            // Next button
            Expanded(
              child: ElevatedButton(
                onPressed: isStepValid ? () => context.go('/quiz/step4') : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isStepValid 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).disabledColor,
                  padding: EdgeInsets.symmetric(vertical: 16.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

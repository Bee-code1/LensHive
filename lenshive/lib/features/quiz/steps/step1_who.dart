import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../models/questionnaire_models.dart';
import '../state/questionnaire_controller.dart';
import '../widgets/option_chip.dart';
import '../widgets/section_card.dart';
import '../widgets/progress_bar.dart';

/// Step 1: Who are these glasses for?
/// Questions about who the glasses are for, current glasses usage, vision needs, and power strength
class Step1Who extends ConsumerWidget {
  const Step1Who({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(questionnaireProvider.notifier);
    final answer = ref.watch(questionnaireAnswerProvider);
    final isStepValid = controller.isStepValid(1);

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
            currentStep: 1,
            totalSteps: 5,
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: Column(
                children: [
                  // Question 1: Who are these glasses for?
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Who are these glasses for?',
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
                              label: 'Myself',
                              isSelected: answer.whoFor == WhoFor.myself,
                              onTap: () => controller.updateWhoFor(WhoFor.myself),
                            ),
                            OptionChip(
                              label: 'Child/Teen',
                              isSelected: answer.whoFor == WhoFor.childTeen,
                              onTap: () => controller.updateWhoFor(WhoFor.childTeen),
                            ),
                            OptionChip(
                              label: 'Senior 60+',
                              isSelected: answer.whoFor == WhoFor.senior60,
                              onTap: () => controller.updateWhoFor(WhoFor.senior60),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 2: Do you currently use glasses?
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Do you currently use glasses?',
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
                              isSelected: answer.currentGlasses == CurrentGlasses.yes,
                              onTap: () => controller.updateCurrentGlasses(CurrentGlasses.yes),
                            ),
                            OptionChip(
                              label: 'No',
                              isSelected: answer.currentGlasses == CurrentGlasses.no,
                              onTap: () => controller.updateCurrentGlasses(CurrentGlasses.no),
                            ),
                            OptionChip(
                              label: 'Sometimes',
                              isSelected: answer.currentGlasses == CurrentGlasses.sometimes,
                              onTap: () => controller.updateCurrentGlasses(CurrentGlasses.sometimes),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 3: What do you mainly need to see clearly?
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What do you mainly need to see clearly?',
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
                              label: 'Far away (classroom/driving)',
                              isSelected: answer.visionNeed == VisionNeed.farAway,
                              onTap: () => controller.updateVisionNeed(VisionNeed.farAway),
                            ),
                            OptionChip(
                              label: 'Up close (reading/phone)',
                              isSelected: answer.visionNeed == VisionNeed.upClose,
                              onTap: () => controller.updateVisionNeed(VisionNeed.upClose),
                            ),
                            OptionChip(
                              label: 'Both equally',
                              isSelected: answer.visionNeed == VisionNeed.bothEqually,
                              onTap: () => controller.updateVisionNeed(VisionNeed.bothEqually),
                            ),
                            OptionChip(
                              label: 'Not sure',
                              isSelected: answer.visionNeed == VisionNeed.notSure,
                              onTap: () => controller.updateVisionNeed(VisionNeed.notSure),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 4: If you know your power, how strong is it?
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'If you know your power, how strong is it?',
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
                              label: 'Unknown',
                              isSelected: answer.powerStrength == PowerStrength.unknown,
                              onTap: () => controller.updatePowerStrength(PowerStrength.unknown),
                            ),
                            OptionChip(
                              label: 'Mild (±0 to ±1.50)',
                              isSelected: answer.powerStrength == PowerStrength.mild,
                              onTap: () => controller.updatePowerStrength(PowerStrength.mild),
                            ),
                            OptionChip(
                              label: 'Moderate (±1.75 to ±3.00)',
                              isSelected: answer.powerStrength == PowerStrength.moderate,
                              onTap: () => controller.updatePowerStrength(PowerStrength.moderate),
                            ),
                            OptionChip(
                              label: 'Strong (±3.25 or more)',
                              isSelected: answer.powerStrength == PowerStrength.strong,
                              onTap: () => controller.updatePowerStrength(PowerStrength.strong),
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
            // Back button (disabled on first step)
            Expanded(
              child: OutlinedButton(
                onPressed: null, // Disabled on step 1
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
                onPressed: isStepValid ? () => context.go('/quiz/step2') : null,
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

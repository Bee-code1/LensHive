import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../models/questionnaire_models.dart';
import '../state/questionnaire_controller.dart';
import '../widgets/option_chip.dart';
import '../widgets/section_card.dart';
import '../widgets/progress_bar.dart';

/// Step 4: Lifestyle, thickness preferences, and handling
/// Questions about activities, rough use, lens weight preferences, and handling style
class Step4LifestyleThicknessHandling extends ConsumerWidget {
  const Step4LifestyleThicknessHandling({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(questionnaireProvider.notifier);
    final answer = ref.watch(questionnaireAnswerProvider);
    final isStepValid = controller.isStepValid(4);

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
            currentStep: 4,
            totalSteps: 5,
            title: 'Lifestyle Questions',
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: Column(
                children: [
                  // Question 1: Activities (multi-select)
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What will you be doing with your new glasses?',
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
                              label: 'Office/reading',
                              isSelected: answer.activities?.contains(Activity.office) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.office),
                            ),
                            OptionChip(
                              label: 'Sports/active',
                              isSelected: answer.activities?.contains(Activity.sports) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.sports),
                            ),
                            OptionChip(
                              label: 'Construction/chemicals',
                              isSelected: answer.activities?.contains(Activity.construction) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.construction),
                            ),
                            OptionChip(
                              label: 'Gaming',
                              isSelected: answer.activities?.contains(Activity.gaming) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.gaming),
                            ),
                            OptionChip(
                              label: 'Frequent travel',
                              isSelected: answer.activities?.contains(Activity.travel) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.travel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 2: Rough use frequency
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How often will your glasses face rough use?',
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
                              isSelected: answer.roughUse == RoughUse.low,
                              onTap: () => controller.updateRoughUse(RoughUse.low),
                            ),
                            OptionChip(
                              label: 'Medium',
                              isSelected: answer.roughUse == RoughUse.medium,
                              onTap: () => controller.updateRoughUse(RoughUse.medium),
                            ),
                            OptionChip(
                              label: 'High',
                              isSelected: answer.roughUse == RoughUse.high,
                              onTap: () => controller.updateRoughUse(RoughUse.high),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 3: Lens weight preference
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What matters more to you for the lenses?',
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
                              label: 'As light & thin as possible',
                              isSelected: answer.lensWeightPref == LensWeightPref.lightThin,
                              onTap: () => controller.updateLensWeightPref(LensWeightPref.lightThin),
                            ),
                            OptionChip(
                              label: 'Standard thickness is fine',
                              isSelected: answer.lensWeightPref == LensWeightPref.standardThick,
                              onTap: () => controller.updateLensWeightPref(LensWeightPref.standardThick),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 4: Handling style
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How will you be handling your glasses?',
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
                              label: 'I\'m careful',
                              isSelected: answer.handling == Handling.careful,
                              onTap: () => controller.updateHandling(Handling.careful),
                            ),
                            OptionChip(
                              label: 'I drop/clean roughly',
                              isSelected: answer.handling == Handling.rough,
                              onTap: () => controller.updateHandling(Handling.rough),
                            ),
                            OptionChip(
                              label: 'A child will use them',
                              isSelected: answer.handling == Handling.childUse,
                              onTap: () => controller.updateHandling(Handling.childUse),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Informational text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    child: Text(
                      'This helps us choose the best lens material and toughness for your needs.',
                      style: TextStyle(
                        fontSize: 12.r,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontStyle: FontStyle.italic,
                      ),
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
                onPressed: () => context.go('/quiz/step3'),
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
                onPressed: isStepValid ? () => context.go('/quiz/step5') : null,
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

  void _toggleActivity(QuestionnaireController controller, QuestionnaireAnswer answer, Activity activity) {
    final currentActivities = Set<Activity>.from(answer.activities ?? {});
    if (currentActivities.contains(activity)) {
      currentActivities.remove(activity);
    } else {
      currentActivities.add(activity);
    }
    controller.updateActivities(currentActivities.isEmpty ? null : currentActivities);
  }
}

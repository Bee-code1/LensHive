import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../models/questionnaire_models.dart';
import '../state/questionnaire_controller.dart';
import '../widgets/option_chip.dart';
import '../widgets/section_card.dart';
import '../widgets/progress_bar.dart';

/// Step 2: Screen time, work setting, and reflections
/// Questions about daily screen time, work environment, and reflection sensitivity
class Step2ScreenWorkReflections extends ConsumerStatefulWidget {
  const Step2ScreenWorkReflections({super.key});

  @override
  ConsumerState<Step2ScreenWorkReflections> createState() => _Step2ScreenWorkReflectionsState();
}

class _Step2ScreenWorkReflectionsState extends ConsumerState<Step2ScreenWorkReflections> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(questionnaireProvider.notifier);
    final answer = ref.watch(questionnaireAnswerProvider);
    final isStepValid = controller.isStepValid(2);

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
            currentStep: 2,
            totalSteps: 5,
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: Column(
                children: [
                  // Question 1: Daily screen time
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily screen time',
                          style: TextStyle(
                            fontSize: 18.r,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 16.r),
                        _buildScreenTimeSlider(controller, answer.screenTimeHours ?? 6.0),
                      ],
                    ),
                  ),

                  // Question 2: Work setting
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Work setting (pick one)',
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
                              label: 'Mostly office/indoor',
                              isSelected: answer.workSetting == WorkSetting.mostlyOffice,
                              onTap: () => controller.updateWorkSetting(WorkSetting.mostlyOffice),
                            ),
                            OptionChip(
                              label: 'Mixed indoor & outdoor',
                              isSelected: answer.workSetting == WorkSetting.mixedIndoorOutdoor,
                              onTap: () => controller.updateWorkSetting(WorkSetting.mixedIndoorOutdoor),
                            ),
                            OptionChip(
                              label: 'Mostly outdoor/sun',
                              isSelected: answer.workSetting == WorkSetting.mostlyOutdoor,
                              onTap: () => controller.updateWorkSetting(WorkSetting.mostlyOutdoor),
                            ),
                            OptionChip(
                              label: 'Driving/commuting',
                              isSelected: answer.workSetting == WorkSetting.drivingCommuting,
                              onTap: () => controller.updateWorkSetting(WorkSetting.drivingCommuting),
                            ),
                            OptionChip(
                              label: 'Workshop/Lab',
                              isSelected: answer.workSetting == WorkSetting.workshopLab,
                              onTap: () => controller.updateWorkSetting(WorkSetting.workshopLab),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 3: Reflections bother
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Do reflections or halos bother you when reading or at night?',
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
                              label: 'Never',
                              isSelected: answer.reflectionBother == ReflectionBother.never,
                              onTap: () => controller.updateReflectionBother(ReflectionBother.never),
                            ),
                            OptionChip(
                              label: 'Sometimes',
                              isSelected: answer.reflectionBother == ReflectionBother.sometimes,
                              onTap: () => controller.updateReflectionBother(ReflectionBother.sometimes),
                            ),
                            OptionChip(
                              label: 'Often',
                              isSelected: answer.reflectionBother == ReflectionBother.often,
                              onTap: () => controller.updateReflectionBother(ReflectionBother.often),
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
                onPressed: () => context.go('/quiz/step1'),
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
                onPressed: isStepValid ? () => context.go('/quiz/step3') : null,
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

  Widget _buildScreenTimeSlider(QuestionnaireController controller, double currentValue) {
    return Column(
      children: [
        // Value display
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 6.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            '${currentValue.round()}h',
            style: TextStyle(
              fontSize: 14.r,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: 16.r),
        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            trackHeight: 4.r,
          ),
          child: Slider(
            value: currentValue,
            min: 0,
            max: 12,
            divisions: 24, // 0.5 hour increments
            onChanged: (value) {
              controller.updateScreenTimeHours(value);
            },
          ),
        ),
        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0h',
              style: TextStyle(
                fontSize: 12.r,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            Text(
              '12h',
              style: TextStyle(
                fontSize: 12.r,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

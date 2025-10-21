import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/questionnaire_models.dart';
import '../state/questionnaire_controller.dart';
import '../widgets/option_chip.dart';
import '../widgets/section_card.dart';
import '../widgets/progress_bar.dart';

/// Step 5: Comfort preferences, budget, and additional notes
/// Final step with comfort preferences, budget slider, and optional notes
class Step5ComfortBudgetNotes extends ConsumerStatefulWidget {
  const Step5ComfortBudgetNotes({super.key});

  @override
  ConsumerState<Step5ComfortBudgetNotes> createState() => _Step5ComfortBudgetNotesState();
}

class _Step5ComfortBudgetNotesState extends ConsumerState<Step5ComfortBudgetNotes> {
  final TextEditingController _notesController = TextEditingController();
  bool _isAgreed = false;

  @override
  void initState() {
    super.initState();
    // Load existing notes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final answer = ref.read(questionnaireAnswerProvider);
      if (answer.additionalNotes != null) {
        _notesController.text = answer.additionalNotes!;
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(questionnaireProvider.notifier);
    final answer = ref.watch(questionnaireAnswerProvider);
    final isStepValid = controller.isStepValid(5) && _isAgreed;

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
            currentStep: 5,
            totalSteps: 5,
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: Column(
                children: [
                  // Question 1: Comfort preferences (multi-select)
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comfort preferences',
                          style: TextStyle(
                            fontSize: 18.r,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 4.r),
                        Text(
                          'Your eyes will thank you. Select all that apply.',
                          style: TextStyle(
                            fontSize: 14.r,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        SizedBox(height: 16.r),
                        Wrap(
                          spacing: 12.r,
                          runSpacing: 12.r,
                          children: [
                            OptionChip(
                              label: 'Reduce eye strain',
                              isSelected: answer.comforts?.contains(Comfort.reduceEyeStrain) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.reduceEyeStrain),
                            ),
                            OptionChip(
                              label: 'Reduce glare/halos',
                              isSelected: answer.comforts?.contains(Comfort.reduceGlare) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.reduceGlare),
                            ),
                            OptionChip(
                              label: 'Stay clear outdoors',
                              isSelected: answer.comforts?.contains(Comfort.stayClearOutdoors) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.stayClearOutdoors),
                            ),
                            OptionChip(
                              label: 'Resist scratches/smudges',
                              isSelected: answer.comforts?.contains(Comfort.resistScratches) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.resistScratches),
                            ),
                            OptionChip(
                              label: 'Be very lightweight',
                              isSelected: answer.comforts?.contains(Comfort.veryLightweight) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleComfort(controller, answer, Comfort.veryLightweight),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Question 2: Budget range
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget range (PKR)',
                          style: TextStyle(
                            fontSize: 18.r,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 4.r),
                        Text(
                          'Let\'s find a pair that fits your wallet.',
                          style: TextStyle(
                            fontSize: 14.r,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        SizedBox(height: 16.r),
                        _buildBudgetSlider(controller, answer.budgetPKR ?? 15000),
                      ],
                    ),
                  ),

                  // Question 3: Additional notes
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anything else we should consider?',
                          style: TextStyle(
                            fontSize: 18.r,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 4.r),
                        Text(
                          'Optional, but helpful!',
                          style: TextStyle(
                            fontSize: 14.r,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        SizedBox(height: 16.r),
                        TextField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'e.g., I need them for driving at night...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            contentPadding: EdgeInsets.all(16.r),
                          ),
                          onChanged: (value) {
                            controller.updateAdditionalNotes(value.isEmpty ? null : value);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Agreement checkbox
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isAgreed,
                          onChanged: (value) {
                            setState(() {
                              _isAgreed = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'I\'m okay with these answers',
                            style: TextStyle(
                              fontSize: 14.r,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
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
                onPressed: () => context.go('/quiz/step4'),
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
                onPressed: isStepValid ? () => _generateRecommendation(context, controller) : null,
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
                  'See my recommendation',
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

  Widget _buildBudgetSlider(QuestionnaireController controller, double currentValue) {
    final formatter = NumberFormat('#,##0', 'en_US');
    
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
            'PKR ${formatter.format(currentValue.round())}',
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
            min: 5000,
            max: 40000,
            divisions: 35, // 1000 PKR increments
            onChanged: (value) {
              controller.updateBudgetPKR(value);
            },
          ),
        ),
        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '5,000',
              style: TextStyle(
                fontSize: 12.r,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            Text(
              '40,000',
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

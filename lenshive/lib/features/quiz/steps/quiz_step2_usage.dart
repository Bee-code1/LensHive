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

/// Step 2: Usage & Lifestyle
class QuizStep2Usage extends ConsumerWidget {
  const QuizStep2Usage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(questionnaireProvider.notifier);
    final answer = ref.watch(questionnaireAnswerProvider);
    final brightness = Theme.of(context).brightness;
    
    // Step is valid if all required fields are filled
    final isValid = answer.screenTimeHours != null && 
                    answer.sunlightTime != null &&
                    answer.activities != null && 
                    answer.activities!.isNotEmpty;

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
          ProgressBar(currentStep: 2, totalSteps: 3),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How will you use them?',
                    style: TextStyle(
                      fontSize: 24.r,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextColor(brightness),
                    ),
                  ),
                  SizedBox(height: 8.r),
                  Text(
                    'Tell us about your daily activities',
                    style: TextStyle(
                      fontSize: 14.r,
                      color: AppColors.getTextColor(brightness).withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 24.r),

                  // Question 1: Screen time
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💻 Daily screen time (hours)',
                          style: TextStyle(
                            fontSize: 16.r,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextColor(brightness),
                          ),
                        ),
                        SizedBox(height: 16.r),
                        
                        // Value display
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                            decoration: BoxDecoration(
                              color: (brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '${(answer.screenTimeHours ?? 4).round()}h per day',
                              style: TextStyle(
                                fontSize: 18.r,
                                fontWeight: FontWeight.bold,
                                color: brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.r),
                        
                        // Slider
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
                            inactiveTrackColor: AppColors.getBorderColor(brightness),
                            thumbColor: brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
                            overlayColor: (brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary).withOpacity(0.2),
                            trackHeight: 4.r,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
                          ),
                          child: Slider(
                            value: answer.screenTimeHours ?? 4,
                            min: 0,
                            max: 12,
                            divisions: 12,
                            onChanged: (value) => controller.updateScreenTimeHours(value),
                          ),
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0h', style: TextStyle(fontSize: 12.r, color: AppColors.getTextColor(brightness).withOpacity(0.6))),
                            Text('12h', style: TextStyle(fontSize: 12.r, color: AppColors.getTextColor(brightness).withOpacity(0.6))),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.r),

                  // Question 2: Outdoor time
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '☀️ Time in bright sunlight daily',
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
                              label: '< 30 min',
                              isSelected: answer.sunlightTime == SunlightTime.under30min,
                              onTap: () => controller.updateSunlightTime(SunlightTime.under30min),
                            ),
                            OptionChip(
                              label: '30 min - 2 hrs',
                              isSelected: answer.sunlightTime == SunlightTime.h30to120,
                              onTap: () => controller.updateSunlightTime(SunlightTime.h30to120),
                            ),
                            OptionChip(
                              label: '2-4 hrs',
                              isSelected: answer.sunlightTime == SunlightTime.h2to4,
                              onTap: () => controller.updateSunlightTime(SunlightTime.h2to4),
                            ),
                            OptionChip(
                              label: '4+ hrs',
                              isSelected: answer.sunlightTime == SunlightTime.h4plus,
                              onTap: () => controller.updateSunlightTime(SunlightTime.h4plus),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.r),

                  // Question 3: Activities (multi-select)
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🎯 Main activities (select all that apply)',
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
                              label: '💼 Office work',
                              isSelected: answer.activities?.contains(Activity.office) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.office),
                            ),
                            OptionChip(
                              label: '⚽ Sports',
                              isSelected: answer.activities?.contains(Activity.sports) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.sports),
                            ),
                            OptionChip(
                              label: '🔨 Outdoor work',
                              isSelected: answer.activities?.contains(Activity.construction) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.construction),
                            ),
                            OptionChip(
                              label: '🎮 Gaming',
                              isSelected: answer.activities?.contains(Activity.gaming) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.gaming),
                            ),
                            OptionChip(
                              label: '✈️ Travel',
                              isSelected: answer.activities?.contains(Activity.travel) ?? false,
                              isMultiSelect: true,
                              onTap: () => _toggleActivity(controller, answer, Activity.travel),
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
                  onPressed: isValid ? () => context.push('/quiz/step3') : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid 
                        ? (brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary)
                        : AppColors.getBorderColor(brightness),
                    padding: EdgeInsets.symmetric(vertical: 16.r),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: 0,
                  ),
                  child: Text('Next', style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.w600, color: AppColors.white)),
                ),
              ),
            ],
          ),
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


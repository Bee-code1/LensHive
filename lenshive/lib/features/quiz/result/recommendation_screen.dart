import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../models/questionnaire_models.dart';
import '../widgets/section_card.dart';

/// Recommendation screen displaying the lens recommendation
/// Shows the recommended lens type with benefits and call-to-action buttons
class RecommendationScreen extends ConsumerWidget {
  final RecommendationData? recommendation;
  
  const RecommendationScreen({super.key, this.recommendation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (recommendation == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('No recommendation data found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Your lens recommendation',
          style: TextStyle(
            fontSize: 18.r,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        child: Column(
          children: [
            // Main recommendation card
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recommendation title
                  Text(
                    recommendation!.title,
                    style: TextStyle(
                      fontSize: 24.r,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 12.r),
                  
                  // Recommendation blurb
                  Text(
                    recommendation!.blurb,
                    style: TextStyle(
                      fontSize: 16.r,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20.r),
                  
                  // Key features/bullets
                  ...recommendation!.bullets.map((bullet) => Padding(
                    padding: EdgeInsets.only(bottom: 8.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20.r,
                        ),
                        SizedBox(width: 8.r),
                        Expanded(
                          child: Text(
                            bullet,
                            style: TextStyle(
                              fontSize: 14.r,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  
                  SizedBox(height: 16.r),
                  
                  // Good to know section
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 16.r,
                        ),
                        SizedBox(width: 8.r),
                        Expanded(
                          child: Text(
                            'Good to know: ${recommendation!.goodToKnow}',
                            style: TextStyle(
                              fontSize: 13.r,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16.r),
            
            // What you'll notice section
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What you\'ll notice',
                    style: TextStyle(
                      fontSize: 18.r,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 12.r),
                  
                  // Notice items
                  ...recommendation!.notice.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 6.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          margin: EdgeInsets.only(top: 6.r, right: 12.r),
                          decoration: BoxDecoration(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 14.r,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            SizedBox(height: 100.r), // Space for buttons
          ],
        ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                  // Continue with these lenses - navigate to home or product catalog
                  context.go('/home');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Showing recommended products...'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Continue with these lenses',
                  style: TextStyle(
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 12.r),
            
            // Secondary action button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Compare alternatives
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Comparing alternatives...'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Compare alternatives',
                  style: TextStyle(
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 12.r),
            
            // Tertiary action
            TextButton(
              onPressed: () {
                // Save & revisit later
                context.go('/home');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Recommendation saved for later'),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
              child: Text(
                'Save & revisit later',
                style: TextStyle(
                  fontSize: 14.r,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../models/questionnaire_models.dart';

/// Improved Recommendation Screen
class NewRecommendationScreen extends ConsumerWidget {
  final RecommendationData? recommendation;
  
  const NewRecommendationScreen({super.key, this.recommendation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    
    if (recommendation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No recommendation found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(brightness),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120.r,
            pinned: true,
            backgroundColor: brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
            leading: IconButton(
              icon: Icon(Icons.close, color: AppColors.white),
              onPressed: () => context.go('/home'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Your Perfect Match',
                style: TextStyle(
                  fontSize: 18.r,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
                      brightness == Brightness.dark 
                          ? AppColors.primaryDarkMode.withOpacity(0.8) 
                          : AppColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success Icon
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 60.r,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.r),
                  
                  // Recommendation Title
                  Center(
                    child: Text(
                      recommendation!.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26.r,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(brightness),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 12.r),
                  
                  // Recommendation Description
                  Text(
                    recommendation!.blurb,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.r,
                      color: AppColors.getTextColor(brightness).withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: 32.r),
                  
                  // Key Benefits
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.getCardColor(brightness),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.getBorderColor(brightness),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
                              size: 24.r,
                            ),
                            SizedBox(width: 8.r),
                            Text(
                              'Key Benefits',
                              style: TextStyle(
                                fontSize: 18.r,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextColor(brightness),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.r),
                        ...recommendation!.bullets.map((bullet) => Padding(
                          padding: EdgeInsets.only(bottom: 12.r),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 4.r),
                                padding: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  color: (brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 14.r,
                                  color: brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 12.r),
                              Expanded(
                                child: Text(
                                  bullet,
                                  style: TextStyle(
                                    fontSize: 15.r,
                                    color: AppColors.getTextColor(brightness),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.r),
                  
                  // What You'll Notice
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.getCardColor(brightness),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.getBorderColor(brightness),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.visibility_rounded,
                              color: brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
                              size: 24.r,
                            ),
                            SizedBox(width: 8.r),
                            Text(
                              'What You\'ll Notice',
                              style: TextStyle(
                                fontSize: 18.r,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextColor(brightness),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.r),
                        ...recommendation!.notice.map((item) => Padding(
                          padding: EdgeInsets.only(bottom: 10.r),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 6.r,
                                height: 6.r,
                                margin: EdgeInsets.only(top: 6.r, right: 12.r),
                                decoration: BoxDecoration(
                                  color: brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14.r,
                                    color: AppColors.getTextColor(brightness).withOpacity(0.9),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.r),
                  
                  // Good to Know
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_rounded,
                          color: AppColors.info,
                          size: 20.r,
                        ),
                        SizedBox(width: 12.r),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good to Know',
                                style: TextStyle(
                                  fontSize: 14.r,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.info,
                                ),
                              ),
                              SizedBox(height: 4.r),
                              Text(
                                recommendation!.goodToKnow,
                                style: TextStyle(
                                  fontSize: 13.r,
                                  color: AppColors.getTextColor(brightness).withOpacity(0.8),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 100.r),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Button
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
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: brightness == Brightness.dark ? AppColors.primaryDarkMode : AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 16.r),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Browse Recommended Products',
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


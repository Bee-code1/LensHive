import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Category Tabs Widget
/// Reusable category selection tabs (Men, Women, Kids)
class CategoryTabs extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final List<String> categories;

  const CategoryTabs({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.categories = const ['Men', 'Women', 'Kids'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Row(
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: EdgeInsets.only(right: 12.r),
            child: GestureDetector(
              onTap: () => onCategoryChanged(category),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.r,
                  vertical: 10.r,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected 
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 14.r,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


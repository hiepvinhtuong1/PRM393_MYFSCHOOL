import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../mock/notification_mock_data.dart';

class NotificationFilterChips extends StatelessWidget {
  const NotificationFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.unreadCountFor,
    required this.onSelected,
  });

  final List<NotificationCategory> categories;
  final NotificationCategory selectedCategory;
  final int Function(NotificationCategory category) unreadCountFor;
  final ValueChanged<NotificationCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final unreadCount = unreadCountFor(category);

          return ChoiceChip(
            selected: isSelected,
            showCheckmark: false,
            avatar: Icon(
              category.icon,
              size: 18,
              color: isSelected ? Colors.white : category.color,
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(category.label),
                if (unreadCount > 0) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _UnreadCountBadge(count: unreadCount, isSelected: isSelected),
                ],
              ],
            ),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            selectedColor: AppColors.fptOrange,
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? AppColors.fptOrange : AppColors.borderLight,
            ),
            onSelected: (_) => onSelected(category),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemCount: categories.length,
      ),
    );
  }
}

class _UnreadCountBadge extends StatelessWidget {
  const _UnreadCountBadge({required this.count, required this.isSelected});

  final int count;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : AppColors.fptOrange,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: isSelected ? AppColors.fptOrange : Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

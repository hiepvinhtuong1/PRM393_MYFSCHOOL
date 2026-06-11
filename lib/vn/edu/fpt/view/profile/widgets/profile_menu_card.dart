import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  final List<ProfileMenuItem> items;
  final ValueChanged<ProfileMenuItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _ProfileMenuTile(
              item: items[index],
              onTap: () => onItemTap(items[index]),
            ),
            if (index != items.length - 1)
              const Divider(height: 1, color: AppColors.borderLight),
          ],
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({required this.item, required this.onTap});

  final ProfileMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: item.color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(item.icon, color: item.color, size: 22),
      ),
      title: Text(
        item.title,
        style: textTheme.titleSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}

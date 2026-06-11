import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/app_mock_data.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});

  final HomeEvent event;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: event.color,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    event.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: event.color.withValues(alpha: 0.2),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white54,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, _, _) => Container(
                      color: event.color.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: event.color.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  // Gradient overlay so back button stays visible
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + date row
                  Row(
                    children: [
                      _CategoryChip(
                        label: event.category,
                        color: event.color,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: event.color,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            event.date,
                            style: TextStyle(
                              color: event.color,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Title
                  Text(
                    event.title,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        event.location,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  const Divider(color: AppColors.borderLight),
                  const SizedBox(height: AppSpacing.lg),

                  // Description
                  Text(
                    'Thông tin sự kiện',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    event.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

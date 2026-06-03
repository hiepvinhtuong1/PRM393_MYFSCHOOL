import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import 'mock/grades_mock_data.dart';

class GradeDetailScreen extends StatelessWidget {
  const GradeDetailScreen({super.key, required this.subject});

  final GradeSubject subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _GradeDetailTopBar(onBack: () => Navigator.of(context).pop()),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _GradeDetailHeader(subject: subject),
                  const SizedBox(height: AppSpacing.lg),
                  _FinalScoreCard(subject: subject),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Bảng điểm thành phần',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final component in subject.components) ...[
                    _GradeComponentCard(component: component),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  _GradeNoteCard(subject: subject),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeDetailTopBar extends StatelessWidget {
  const _GradeDetailTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.fptBlue,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.md),
        ),
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left, color: AppColors.surface),
            label: const Text('Điểm số'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.surface,
              padding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            child: Text(
              'Chi tiết điểm',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 84),
        ],
      ),
    );
  }
}

class _GradeDetailHeader extends StatelessWidget {
  const _GradeDetailHeader({required this.subject});

  final GradeSubject subject;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subject.subject, style: textTheme.displaySmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${subject.teacher} • Lớp ${subject.className} • Hệ số ${subject.coefficient}',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _FinalScoreCard extends StatelessWidget {
  const _FinalScoreCard({required this.subject});

  final GradeSubject subject;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: subject.status.backgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              subject.finalScore?.toStringAsFixed(1) ?? '--',
              style: textTheme.displaySmall?.copyWith(
                color: subject.status.color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusBadge(status: subject.status),
                const SizedBox(height: AppSpacing.sm),
                Text('Điểm tổng kết', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Cập nhật: ${subject.updatedAt}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeComponentCard extends StatelessWidget {
  const _GradeComponentCard({required this.component});

  final GradeComponent component;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasScore = component.score != null;
    final scoreColor = hasScore ? AppColors.textPrimary : AppColors.warning;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: hasScore
                  ? AppColors.surfaceElevated
                  : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              hasScore ? component.score!.toStringAsFixed(1) : '--',
              style: textTheme.titleMedium?.copyWith(
                color: scoreColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(component.name, style: textTheme.titleMedium),
                    ),
                    Text(
                      '${component.weight}%',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.fptBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Cập nhật: ${component.updatedAt}',
                  style: textTheme.bodySmall,
                ),
                if (component.note != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    component.note!,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeNoteCard extends StatelessWidget {
  const _GradeNoteCard({required this.subject});

  final GradeSubject subject;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.fptBlue),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              subject.status == GradeStatus.inProgress
                  ? 'Điểm tổng kết sẽ được cập nhật sau khi có đủ các đầu điểm.'
                  : 'Điểm tổng kết được tính theo trọng số các đầu điểm trong môn học.',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final GradeStatus status;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: status.backgroundColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          status.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: status.color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({required this.eventId, super.key});
  final String eventId;

  @override
  Widget build(BuildContext context) {
    final event = MockEvents.all.cast<EventItem?>().firstWhere(
          (e) => e?.id == eventId,
          orElse: () => null,
        );

    if (event == null) {
      return Scaffold(
        appBar: AppScreenHeader(title: 'Sự kiện'),
        body: const AppEmptyState(
          icon: Icons.event_busy_rounded,
          title: 'Không tìm thấy sự kiện',
        ),
      );
    }

    final color = Color(event.categoryColorHex);
    final pct = event.maxParticipants == null
        ? null
        : event.currentParticipants / event.maxParticipants!;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(title: event.title),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Banner
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.borderMd,
            ),
            child: Center(
              child: Icon(Icons.event_rounded, color: Colors.white, size: 72),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title + category
          Row(
            children: [
              Expanded(
                child: Text(event.title, style: AppTextStyles.h2),
              ),
              AppBadge(label: event.category, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Details
          AppCard(
            child: Column(
              children: [
                _DetailRow(Icons.calendar_today_rounded,
                    '${event.date}  –  ${event.time}'),
                const Divider(height: AppSpacing.md, color: AppColors.line2),
                _DetailRow(Icons.location_on_outlined, event.location),
                if (event.maxParticipants != null) ...[
                  const Divider(height: AppSpacing.md, color: AppColors.line2),
                  _DetailRow(
                    Icons.people_outline_rounded,
                    '${event.currentParticipants} / ${event.maxParticipants} người đăng ký',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppProgressBar(value: pct!, color: color, height: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Description
          SectionHeader(title: 'Mô tả'),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Text(event.description,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.ink700)),
          ),
          const SizedBox(height: AppSpacing.xl),

          // CTA
          AppButton(
            label: event.isRegistered ? 'Đã đăng ký tham gia' : 'Đăng ký tham gia',
            variant: event.isRegistered
                ? AppButtonVariant.secondary
                : AppButtonVariant.primary,
            fullWidth: true,
            icon: event.isRegistered
                ? const Icon(Icons.check_rounded, size: 18, color: AppColors.blue600)
                : null,
            onPressed: event.isRegistered ? null : () {},
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.blue500),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(text,
              style: AppTextStyles.body.copyWith(color: AppColors.ink700)),
        ),
      ],
    );
  }
}

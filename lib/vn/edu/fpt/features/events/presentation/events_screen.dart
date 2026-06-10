import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _selected = 'Tất cả';

  List<EventItem> get _filtered => _selected == 'Tất cả'
      ? MockEvents.all
      : MockEvents.all.where((e) => e.category == _selected).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(
        title: 'Sự kiện',
        subtitle: '${MockEvents.all.length} sự kiện sắp tới',
        showBack: false,
      ),
      body: Column(
        children: [
          // Category filter
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: MockEvents.categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) {
                final cat = MockEvents.categories[i];
                final active = cat == _selected;
                return FilterChip(
                  label: Text(cat),
                  selected: active,
                  onSelected: (_) => setState(() => _selected = cat),
                  selectedColor: AppColors.blue500,
                  backgroundColor: AppColors.surface,
                  labelStyle: AppTextStyles.caption.copyWith(
                    color: active ? Colors.white : AppColors.ink600,
                    fontWeight: FontWeight.w600,
                  ),
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: active ? AppColors.blue500 : AppColors.line,
                  ),
                );
              },
            ),
          ),

          // Event list
          Expanded(
            child: _filtered.isEmpty
                ? AppEmptyState(
                    icon: Icons.event_busy_rounded,
                    title: 'Không có sự kiện',
                    subtitle: 'Không có sự kiện nào trong danh mục "$_selected".',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (_, i) => _EventCard(event: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final color = Color(event.categoryColorHex);
    final pct = event.maxParticipants == null
        ? null
        : event.currentParticipants / event.maxParticipants!;

    return AppCard(
      onTap: () => context.push('/events/${event.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: AppRadius.borderMd,
                ),
                child: Icon(Icons.event_rounded, color: color, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(event.title,
                              style: AppTextStyles.bodyBold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        if (event.isRegistered)
                          AppBadge(label: 'Đã đăng ký', color: AppColors.success),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${event.date}  •  ${event.time}',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      event.location,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.ink500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (pct != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: AppProgressBar(value: pct, color: color, height: 6)),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${event.currentParticipants}/${event.maxParticipants}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          AppBadge(label: event.category, color: color),
        ],
      ),
    );
  }
}

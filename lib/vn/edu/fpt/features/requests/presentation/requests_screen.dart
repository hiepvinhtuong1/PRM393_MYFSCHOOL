import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(
        title: 'Đơn từ',
        subtitle: 'Quản lý yêu cầu của bạn',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded,
                color: AppColors.blue500, size: 28),
            onPressed: () => context.push(AppRoutes.createRequest),
            tooltip: 'Tạo đơn mới',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Quick create buttons
          SectionHeader(title: 'Tạo đơn nhanh'),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockRequests.types.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) {
                final t = MockRequests.types[i];
                return _QuickRequestChip(
                  label: t.label,
                  onTap: () => context.push(AppRoutes.createRequest),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          SectionHeader(title: 'Lịch sử đơn từ'),
          const SizedBox(height: AppSpacing.sm),

          if (MockRequests.history.isEmpty)
            const AppEmptyState(
              icon: Icons.description_outlined,
              title: 'Chưa có đơn nào',
              subtitle: 'Nhấn + để tạo đơn mới.',
            )
          else
            ...MockRequests.history.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _RequestCard(item: r),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createRequest),
        backgroundColor: AppColors.orange500,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Tạo đơn',
            style: AppTextStyles.btnText.copyWith(color: Colors.white)),
      ),
    );
  }
}

class _QuickRequestChip extends StatelessWidget {
  const _QuickRequestChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.borderMd,
      child: InkWell(
        borderRadius: AppRadius.borderMd,
        onTap: onTap,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.bgBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_rounded,
                    color: AppColors.blue500, size: 22),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.item});
  final RequestItem item;

  (Color, IconData, String) get _statusInfo => switch (item.status) {
        RequestStatus.pending  => (AppColors.warning,  Icons.hourglass_top_rounded,  'Đang xử lý'),
        RequestStatus.approved => (AppColors.success,  Icons.check_circle_rounded,   'Đã duyệt'),
        RequestStatus.rejected => (AppColors.danger,   Icons.cancel_rounded,         'Từ chối'),
      };

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = _statusInfo;
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: AppRadius.borderSm,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.type, style: AppTextStyles.bodyBold),
                Text('Nộp ngày ${item.submittedAt}',
                    style: AppTextStyles.caption),
                if (item.note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(item.note,
                      style: AppTextStyles.small
                          .copyWith(color: AppColors.ink500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          AppBadge(label: label, color: color),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(
        title: 'Câu lạc bộ',
        subtitle: '${MockClubs.all.length} CLB hoạt động',
        showBack: false,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tab,
              labelColor: AppColors.blue500,
              unselectedLabelColor: AppColors.ink500,
              labelStyle: AppTextStyles.label
                  .copyWith(fontWeight: FontWeight.w700),
              indicatorColor: AppColors.blue500,
              indicatorWeight: 3,
              tabs: const [Tab(text: 'CLB của tôi'), Tab(text: 'Khám phá')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _ClubList(clubs: MockClubs.joined, emptyTitle: 'Bạn chưa tham gia CLB nào'),
                _ClubList(clubs: MockClubs.all),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubList extends StatelessWidget {
  const _ClubList({required this.clubs, this.emptyTitle});
  final List<ClubItem> clubs;
  final String? emptyTitle;

  @override
  Widget build(BuildContext context) {
    if (clubs.isEmpty) {
      return AppEmptyState(
        icon: Icons.groups_rounded,
        title: emptyTitle ?? 'Không có CLB',
        subtitle: 'Khám phá và tham gia câu lạc bộ phù hợp.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: clubs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) => _ClubCard(club: clubs[i]),
    );
  }
}

class _ClubCard extends StatefulWidget {
  const _ClubCard({required this.club});
  final ClubItem club;

  @override
  State<_ClubCard> createState() => _ClubCardState();
}

class _ClubCardState extends State<_ClubCard> {
  late bool _joined;

  @override
  void initState() {
    super.initState();
    _joined = widget.club.isJoined;
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.club.colorHex);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: AppRadius.borderMd,
                ),
                child: Icon(Icons.groups_rounded, color: color, size: 26),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.club.name, style: AppTextStyles.bodyBold),
                    Text(widget.club.category, style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppBadge(
                label: '${widget.club.memberCount} thành viên',
                color: color,
              ),
            ],
          ),
          if (widget.club.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.club.description,
              style: AppTextStyles.small.copyWith(color: AppColors.ink600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() => _joined = !_joined),
              style: OutlinedButton.styleFrom(
                foregroundColor: _joined ? AppColors.ink500 : color,
                side: BorderSide(color: _joined ? AppColors.line : color),
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.borderSm),
                minimumSize: const Size.fromHeight(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _joined ? Icons.check_rounded : Icons.add_rounded,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _joined ? 'Đã tham gia' : 'Tham gia',
                    style: AppTextStyles.label.copyWith(
                      color: _joined ? AppColors.ink500 : color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

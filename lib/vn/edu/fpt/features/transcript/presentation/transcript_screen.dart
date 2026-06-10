import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class TranscriptScreen extends StatefulWidget {
  const TranscriptScreen({super.key});

  @override
  State<TranscriptScreen> createState() => _TranscriptScreenState();
}

class _TranscriptScreenState extends State<TranscriptScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(
        length: MockTranscript.semesters.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final semesters = MockTranscript.semesters;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(
        title: 'Bảng điểm',
        subtitle: MockUser.fullName,
        showBack: false,
      ),
      body: Column(
        children: [
          // Semester tabs
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tab,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.blue500,
              unselectedLabelColor: AppColors.ink500,
              labelStyle: AppTextStyles.label
                  .copyWith(fontWeight: FontWeight.w700),
              indicatorColor: AppColors.blue500,
              indicatorWeight: 3,
              tabs: semesters
                  .map((s) => Tab(text: s.semester.split('—').first.trim()))
                  .toList(),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tab,
              children: semesters
                  .map((s) => _SemesterView(transcript: s))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SemesterView extends StatelessWidget {
  const _SemesterView({required this.transcript});
  final SemesterTranscript transcript;

  Color _gradeColor(double avg) {
    if (avg >= 8.5) return AppColors.success;
    if (avg >= 7.0) return AppColors.warning;
    if (avg >= 5.0) return AppColors.blue500;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // GPA card
        AppCard(
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.bgBlue,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      transcript.gpa.toStringAsFixed(1),
                      style: AppTextStyles.h2
                          .copyWith(color: AppColors.blue500),
                    ),
                    Text('GPA', style: AppTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transcript.semester,
                        style: AppTextStyles.bodyBold),
                    const SizedBox(height: 4),
                    Text(
                      '${transcript.subjects.length} môn học',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 8),
                    AppProgressBar(
                      value: transcript.gpa / 10,
                      color: _gradeColor(transcript.gpa),
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        SectionHeader(title: 'Chi tiết điểm số'),
        const SizedBox(height: AppSpacing.sm),

        // Table header
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Text('Môn học', style: AppTextStyles.caption)),
              _HeaderCell('GK'),
              _HeaderCell('CK'),
              _HeaderCell('TB'),
              _HeaderCell('XL'),
            ],
          ),
        ),

        // Subject rows
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ...transcript.subjects.asMap().entries.map((entry) {
                final i = entry.key;
                final g = entry.value;
                return Column(
                  children: [
                    if (i > 0)
                      const Divider(
                          height: 1, thickness: 1, color: AppColors.line2),
                    _SubjectRow(grade: g),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Text(text,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.grade});
  final SubjectGrade grade;

  Color _letterColor(String l) {
    if (l.startsWith('A')) return AppColors.success;
    if (l.startsWith('B')) return AppColors.blue500;
    if (l.startsWith('C')) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final letterColor = _letterColor(grade.letterGrade);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(grade.subject, style: AppTextStyles.bodyBold),
                Text('${grade.credits} tín chỉ',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          _ScoreCell(grade.midterm),
          _ScoreCell(grade.finalExam),
          _ScoreCell(grade.average, bold: true),
          SizedBox(
            width: 40,
            child: Center(
              child: AppBadge(
                label: grade.letterGrade,
                color: letterColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCell extends StatelessWidget {
  const _ScoreCell(this.value, {this.bold = false});
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Text(
        value.toStringAsFixed(1),
        textAlign: TextAlign.center,
        style: bold
            ? AppTextStyles.bodyBold
            : AppTextStyles.body,
      ),
    );
  }
}

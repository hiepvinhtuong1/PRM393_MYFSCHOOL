import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../core/mock/app_mock_data.dart';
import '../core/services/grade_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/semester_service.dart';
import '../core/services/timetable_service.dart';

class HomeController extends GetxController {
  final _timetableService = TimetableService();
  final _notificationService = NotificationService();
  final _semesterService = SemesterService();
  final _gradeService = GradeService();

  final todaySchedule = <HomeScheduleItem>[].obs;
  final recentNotices = <HomeNotice>[].obs;
  final events = <HomeEvent>[].obs;
  final currentGpa = 0.0.obs;
  final gpaHistory = <SemesterGpa>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final auth = Get.find<AuthController>();
    loadData(studentId: auth.selectedStudentId.value);
    ever(auth.selectedStudentId, (id) => loadData(studentId: id));
  }

  Future<void> loadData({int? studentId}) async {
    isLoading.value = true;
    try {
      final today = _dateKey(DateTime.now());

      final lessons = await _timetableService.getLessons(today, studentId: studentId);
      todaySchedule.assignAll(lessons.map(_toScheduleItem));

      final notifResult = await _notificationService.getNotifications(page: 0, size: 5);
      recentNotices.assignAll(notifResult.items.take(3).map(_toNotice));

      final eventsResult = await _notificationService.getNotifications(page: 0, size: 5, category: 'event');
      events.assignAll(eventsResult.items.map(HomeEvent.fromNotification));

      final semesters = await _semesterService.getSemesters();
      for (final semester in semesters) {
        final grades = await _gradeService.getGrades(semester.id, studentId: studentId);
        if (grades.isNotEmpty) {
          currentGpa.value = _calcGpa(grades);
          gpaHistory.assignAll([SemesterGpa(label: semester.name, gpa: currentGpa.value)]);
          break;
        }
      }
    } catch (_) {
      // silent fail — keep whatever was loaded before
    } finally {
      isLoading.value = false;
    }
  }

  static String _dateKey(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static HomeScheduleItem _toScheduleItem(LessonItem l) => HomeScheduleItem(
        subjectName: l.subjectName,
        startTime: l.startTime,
        slotLabel: l.slotLabel,
        roomCode: l.roomCode,
        color: l.color,
      );

  static HomeNotice _toNotice(SchoolNotification n) => HomeNotice(
        title: n.title,
        time: n.time,
        badge: n.category.label,
        color: n.category.color,
        content: [TextBlock(n.description)],
      );

  static double _calcGpa(List<GradeItem> items) {
    final completed = items.where((i) => i.subjectAverage != null).toList();
    if (completed.isEmpty) return 0;
    final totalCoef = completed.fold<double>(0, (s, i) => s + i.subjectCoefficient);
    final totalScore = completed.fold<double>(0, (s, i) => s + i.subjectAverage! * i.subjectCoefficient);
    if (totalCoef == 0) return 0;
    return double.parse((totalScore / totalCoef).toStringAsFixed(1));
  }
}

import 'package:get/get.dart';

import '../core/mock/timetable_mock_data.dart';
import '../core/services/timetable_service.dart';
import 'auth_controller.dart';

class TimetableController extends GetxController {
  final _service = TimetableService();

  final selectedDate = TimetableMockData.dateKey(DateTime.now()).obs;
  final selectedSemester = TimetableMockData.semesters.first.id.obs;
  late final weekStart = Rx<DateTime>(
    TimetableMockData.weekStartFor(DateTime.now()),
  );

  final lessons = <LessonItem>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLessons();
    // Reload when parent switches child
    ever(
      Get.find<AuthController>().selectedStudentId,
      (_) => loadLessons(),
    );
  }

  Future<void> loadLessons() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final auth = Get.find<AuthController>();
      final result = await _service.getLessons(
        selectedDate.value,
        studentId: auth.isParent ? auth.selectedStudentId.value : null,
      );
      lessons.assignAll(result);
    } catch (_) {
      lessons.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void changeWeek(int direction) {
    final nextDate = DateTime.parse(selectedDate.value).add(
      Duration(days: direction * 7),
    );
    selectedDate.value = TimetableMockData.dateKey(nextDate);
    weekStart.value = TimetableMockData.weekStartFor(nextDate);
    loadLessons();
  }

  void selectDate(String date) {
    selectedDate.value = date;
    loadLessons();
  }

  void selectSemester(String semester) => selectedSemester.value = semester;
}

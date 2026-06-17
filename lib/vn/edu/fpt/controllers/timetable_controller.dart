import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/mock/timetable_mock_data.dart';
import '../core/services/semester_service.dart';
import '../core/services/timetable_service.dart';
import 'auth_controller.dart';

class TimetableController extends GetxController {
  final _service = TimetableService();
  final _semesterService = SemesterService();

  final selectedDate = _todayKey().obs;
  final selectedSemester = ''.obs;
  late final weekStart = Rx<DateTime>(_weekStartFor(DateTime.now()));

  final lessons = <LessonItem>[].obs;
  final semesterItems = <SemesterItem>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSemesters();
    loadLessons();
    ever(Get.find<AuthController>().selectedStudentId, (_) => loadLessons());
  }

  Future<void> _loadSemesters() async {
    try {
      final dtos = await _semesterService.getSemesters();
      final items = dtos.map((s) => SemesterItem(
            id: s.id.toString(),
            label: s.combinedLabel,
            icon: s.name.contains('II')
                ? Icons.wb_sunny_outlined
                : Icons.spa_outlined,
          )).toList();
      semesterItems.assignAll(items);
      if (selectedSemester.value.isEmpty && dtos.isNotEmpty) {
        selectedSemester.value = pickDefaultSemester(dtos).id.toString();
      }
    } catch (_) {}
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
    final next = DateTime.parse(selectedDate.value)
        .add(Duration(days: direction * 7));
    selectedDate.value = _todayKey(next);
    weekStart.value = _weekStartFor(next);
    loadLessons();
  }

  void selectDate(String date) {
    selectedDate.value = date;
    loadLessons();
  }

  void selectSemester(String id) => selectedSemester.value = id;

  static String _todayKey([DateTime? date]) {
    final d = date ?? DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static DateTime _weekStartFor(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }
}

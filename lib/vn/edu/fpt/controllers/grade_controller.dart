import 'package:get/get.dart';

import '../core/mock/grade_mock_data.dart';
import '../core/services/grade_service.dart';
import '../core/services/semester_service.dart';
import 'auth_controller.dart';

class GradeController extends GetxController {
  final _gradeService = GradeService();
  final _semesterService = SemesterService();

  final semesterList = <SemesterDto>[].obs;
  final grades = <GradeItem>[].obs;
  final isLoading = false.obs;

  // UI filter strings (compatible with GradeFilterRow)
  final selectedSemester = ''.obs;
  final selectedYear = ''.obs;

  List<String> get semesters =>
      semesterList.map((s) => s.name).toSet().toList();

  List<String> get years =>
      semesterList.map((s) => s.academicYear).toSet().toList();

  int? get _selectedSemesterId {
    return semesterList
        .where(
          (s) =>
              s.name == selectedSemester.value &&
              s.academicYear == selectedYear.value,
        )
        .map((s) => s.id)
        .firstOrNull;
  }

  @override
  void onInit() {
    super.onInit();
    _loadSemesters();
    ever(Get.find<AuthController>().selectedStudentId, (_) => loadGrades());
  }

  Future<void> _loadSemesters() async {
    try {
      final list = await _semesterService.getSemesters();
      semesterList.assignAll(list);
      if (list.isNotEmpty) {
        final def = pickDefaultSemester(list);
        selectedSemester.value = def.name;
        selectedYear.value = def.academicYear;
        await loadGrades();
      }
    } catch (_) {}
  }

  Future<void> loadGrades() async {
    final semId = _selectedSemesterId;
    if (semId == null || isLoading.value) return;
    isLoading.value = true;
    try {
      final auth = Get.find<AuthController>();
      final result = await _gradeService.getGrades(
        semId,
        studentId: auth.isParent ? auth.selectedStudentId.value : null,
      );
      grades.assignAll(result);
    } catch (_) {
      grades.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void onSemesterChanged(String value) {
    selectedSemester.value = value;
    loadGrades();
  }

  void onYearChanged(String value) {
    selectedYear.value = value;
    loadGrades();
  }
}

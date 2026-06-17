import 'package:get/get.dart';

import '../core/mock/attendance_mock_data.dart';
import '../core/services/attendance_service.dart';
import '../core/services/semester_service.dart';
import 'auth_controller.dart';

class AttendanceController extends GetxController {
  final _attendanceService = AttendanceService();
  final _semesterService = SemesterService();

  final semesterList = <SemesterDto>[].obs;
  final subjects = <AttendanceSubject>[].obs;
  final selectedSemester = ''.obs;
  final selectedSubjectId = 'all'.obs;
  final isLoading = false.obs;

  List<String> get semesterLabels => semesterList.map((s) => s.combinedLabel).toList();

  int? get _selectedSemesterId {
    return semesterList
        .where((s) => s.combinedLabel == selectedSemester.value)
        .map((s) => s.id)
        .firstOrNull;
  }

  List<AttendanceSubject> get filteredSubjects {
    if (selectedSubjectId.value == 'all') return subjects;
    return subjects.where((s) => s.id == selectedSubjectId.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadSemesters();
    ever(Get.find<AuthController>().selectedStudentId, (_) => loadAttendance());
  }

  Future<void> _loadSemesters() async {
    try {
      final list = await _semesterService.getSemesters();
      semesterList.assignAll(list);
      if (list.isNotEmpty) {
        selectedSemester.value = pickDefaultSemester(list).combinedLabel;
        await loadAttendance();
      }
    } catch (_) {}
  }

  Future<void> loadAttendance() async {
    final semId = _selectedSemesterId;
    if (semId == null || isLoading.value) return;
    isLoading.value = true;
    try {
      final auth = Get.find<AuthController>();
      final result = await _attendanceService.getAttendance(
        semId,
        studentId: auth.isParent ? auth.selectedStudentId.value : null,
      );
      subjects.assignAll(result);
      selectedSubjectId.value = 'all';
    } catch (_) {
      subjects.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void onSemesterChanged(String value) {
    selectedSemester.value = value;
    loadAttendance();
  }
}

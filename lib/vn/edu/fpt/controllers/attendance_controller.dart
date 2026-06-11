import 'package:get/get.dart';

import '../core/mock/app_mock_data.dart';

class AttendanceController extends GetxController {
  final selectedSemester = AttendanceMockData.semesters.first.obs;
  final selectedSubjectId = 'all'.obs;

  List<AttendanceSubject> get filteredSubjects {
    if (selectedSubjectId.value == 'all') return AttendanceMockData.subjects;
    return AttendanceMockData.subjects
        .where((s) => s.id == selectedSubjectId.value)
        .toList();
  }
}

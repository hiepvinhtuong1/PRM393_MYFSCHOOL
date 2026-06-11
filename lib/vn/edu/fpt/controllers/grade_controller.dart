import 'package:get/get.dart';

import '../core/mock/app_mock_data.dart';

class GradeController extends GetxController {
  final selectedSemester = GradeMockData.semesters.first.obs;
  final selectedYear = GradeMockData.years.first.obs;
}

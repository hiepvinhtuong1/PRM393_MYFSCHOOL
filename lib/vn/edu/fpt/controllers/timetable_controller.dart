import 'package:get/get.dart';

import '../core/mock/app_mock_data.dart';

class TimetableController extends GetxController {
  final selectedDate = TimetableMockData.selectedDate.obs;
  final selectedSemester = TimetableMockData.selectedSemester.obs;
  late final weekStart = Rx<DateTime>(
    TimetableMockData.weekStartFor(
      DateTime.parse(TimetableMockData.selectedDate),
    ),
  );

  void changeWeek(int direction) {
    final nextDate = DateTime.parse(selectedDate.value).add(
      Duration(days: direction * 7),
    );
    selectedDate.value = TimetableMockData.dateKey(nextDate);
    weekStart.value = TimetableMockData.weekStartFor(nextDate);
  }

  void selectDate(String date) => selectedDate.value = date;

  void selectSemester(String semester) => selectedSemester.value = semester;
}

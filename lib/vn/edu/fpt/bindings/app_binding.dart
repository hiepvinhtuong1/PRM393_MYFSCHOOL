import 'package:get/get.dart';

import '../controllers/attendance_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/grade_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/timetable_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(NotificationController());
    Get.put(AttendanceController());
    Get.put(TimetableController());
    Get.put(GradeController());
  }
}

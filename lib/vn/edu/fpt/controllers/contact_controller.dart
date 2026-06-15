import 'package:get/get.dart';

import '../core/mock/contact_mock_data.dart';
import '../core/services/contact_service.dart';
import 'auth_controller.dart';

class ContactController extends GetxController {
  final _service = ContactService();

  final teachers = <TeacherContact>[].obs;
  final isLoading = false.obs;

  TeacherContact? get homeroom =>
      teachers.where((t) => t.isHomeroom).firstOrNull;

  List<TeacherContact> get subjectTeachers =>
      teachers.where((t) => !t.isHomeroom).toList();

  @override
  void onInit() {
    super.onInit();
    loadTeachers();
    ever(Get.find<AuthController>().selectedStudentId, (_) => loadTeachers());
  }

  Future<void> loadTeachers() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final auth = Get.find<AuthController>();
      final result = await _service.getTeachers(
        studentId: auth.isParent ? auth.selectedStudentId.value : null,
      );
      teachers.assignAll(result);
    } catch (_) {
      teachers.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

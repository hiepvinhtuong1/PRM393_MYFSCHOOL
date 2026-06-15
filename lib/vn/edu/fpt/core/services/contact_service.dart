import '../mock/contact_mock_data.dart';
import '../network/api_client.dart';

class ContactService {
  final _dio = ApiClient.instance.dio;

  Future<List<TeacherContact>> getTeachers({int? studentId}) async {
    final params = <String, dynamic>{};
    if (studentId != null) params['studentId'] = studentId;

    final response = await _dio.get('/me/teachers', queryParameters: params);
    final list = response.data['data'] as List;
    return list.map((j) {
      final m = j as Map<String, dynamic>;
      return TeacherContact(
        name: m['name'] as String? ?? '',
        subject: m['subject'] as String? ?? '',
        phone: m['phone'] as String? ?? '',
        email: m['email'] as String? ?? '',
        isHomeroom: m['isHomeroom'] as bool? ?? false,
      );
    }).toList();
  }
}

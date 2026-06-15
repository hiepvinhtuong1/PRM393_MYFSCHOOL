import '../mock/grade_mock_data.dart';
import '../network/api_client.dart';

class GradeService {
  final _dio = ApiClient.instance.dio;

  Future<List<GradeItem>> getGrades(int semesterId, {int? studentId}) async {
    final params = <String, dynamic>{'semesterId': semesterId};
    if (studentId != null) params['studentId'] = studentId;

    final response = await _dio.get('/me/grades', queryParameters: params);
    final list = response.data['data'] as List;
    return list.map(_mapGrade).toList();
  }

  static GradeItem _mapGrade(dynamic json) {
    final j = json as Map<String, dynamic>;
    final regularScores = (j['regularScores'] as List?)
            ?.whereType<num>()
            .map((v) => v.toDouble())
            .toList() ??
        [];
    return GradeItem(
      id: j['classroomSubjectId'].toString(),
      subjectName: j['subjectName'] as String? ?? '',
      subjectCoefficient: (j['subjectCoefficient'] as num?)?.toDouble() ?? 1.0,
      regularScores: regularScores,
      midtermScore: (j['midtermScore'] as num?)?.toDouble(),
      finalScore: (j['finalScore'] as num?)?.toDouble(),
      status: _parseStatus(j['status'] as String?),
    );
  }

  static GradeStatus _parseStatus(String? status) {
    return switch (status) {
      'passed' => GradeStatus.passed,
      'warning' => GradeStatus.warning,
      _ => GradeStatus.inProgress,
    };
  }
}

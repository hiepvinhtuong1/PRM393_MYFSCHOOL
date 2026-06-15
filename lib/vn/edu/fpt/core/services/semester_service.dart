import '../network/api_client.dart';

class SemesterDto {
  final int id;
  final String name;
  final String academicYear;

  const SemesterDto({
    required this.id,
    required this.name,
    required this.academicYear,
  });

  factory SemesterDto.fromJson(Map<String, dynamic> json) => SemesterDto(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        academicYear: json['academicYear'] as String,
      );

  String get combinedLabel => '$name - $academicYear';
}

class SemesterService {
  final _dio = ApiClient.instance.dio;

  Future<List<SemesterDto>> getSemesters() async {
    final response = await _dio.get('/me/semesters');
    final list = response.data['data'] as List;
    return list
        .map((j) => SemesterDto.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}

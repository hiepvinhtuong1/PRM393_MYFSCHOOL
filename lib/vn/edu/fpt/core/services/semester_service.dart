import '../network/api_client.dart';

class SemesterDto {
  final int id;
  final String name;
  final String academicYear;
  final DateTime startDate;
  final DateTime endDate;

  const SemesterDto({
    required this.id,
    required this.name,
    required this.academicYear,
    required this.startDate,
    required this.endDate,
  });

  factory SemesterDto.fromJson(Map<String, dynamic> json) => SemesterDto(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        academicYear: json['academicYear'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
      );

  String get combinedLabel => '$name - $academicYear';

  bool get isCurrent {
    final today = DateTime.now();
    final d = DateTime(today.year, today.month, today.day);
    return !startDate.isAfter(d) && !endDate.isBefore(d);
  }

  bool get isPast {
    final today = DateTime.now();
    final d = DateTime(today.year, today.month, today.day);
    return endDate.isBefore(d);
  }
}

/// Returns the best default semester: current > most-recent-past > oldest.
/// List must be sorted newest-first (as the API returns it).
SemesterDto pickDefaultSemester(List<SemesterDto> list) {
  for (final s in list) {
    if (s.isCurrent) return s;
  }
  for (final s in list) {
    if (s.isPast) return s;
  }
  return list.last;
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

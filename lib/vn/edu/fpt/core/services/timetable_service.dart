import 'package:flutter/material.dart';

import '../mock/timetable_mock_data.dart';
import '../network/api_client.dart';
import '../theme/app_colors.dart';

class TimetableService {
  final _dio = ApiClient.instance.dio;

  Future<List<LessonItem>> getLessons(String date, {int? studentId}) async {
    final params = <String, dynamic>{'date': date};
    if (studentId != null) params['studentId'] = studentId;

    final response = await _dio.get('/me/timetable', queryParameters: params);
    final list = response.data['data'] as List;
    return list.map(_mapLesson).toList();
  }

  static LessonItem _mapLesson(dynamic json) {
    final j = json as Map<String, dynamic>;
    return LessonItem(
      id: j['id'].toString(),
      date: j['date'] as String,
      subjectName: j['subjectName'] as String? ?? '',
      teacherName: j['teacherName'] as String? ?? '',
      startTime: j['startTime'] as String? ?? '',
      endTime: j['endTime'] as String? ?? '',
      slotLabel: j['slotLabel'] as String? ?? '',
      roomCode: j['roomCode'] as String? ?? '',
      color: _parseColor(j['colorHex'] as String?),
      status: _parseStatus(j['status'] as String?),
      hasMaterials: j['hasMaterials'] as bool? ?? false,
    );
  }

  static Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.fptBlue;
    final clean = hex.replaceFirst('#', '');
    final value = int.tryParse(clean, radix: 16);
    if (value == null) return AppColors.fptBlue;
    return Color(0xFF000000 | value);
  }

  static LessonStatus _parseStatus(String? status) {
    return switch (status) {
      'completed' => LessonStatus.present,
      'cancelled' => LessonStatus.absent,
      _ => LessonStatus.notYet,
    };
  }
}

import 'package:flutter/material.dart';

import '../mock/attendance_mock_data.dart';
import '../network/api_client.dart';
import '../theme/app_colors.dart';

class AttendanceService {
  final _dio = ApiClient.instance.dio;

  Future<List<AttendanceSubject>> getAttendance(
    int semesterId, {
    int? studentId,
  }) async {
    final params = <String, dynamic>{'semesterId': semesterId};
    if (studentId != null) params['studentId'] = studentId;

    final response = await _dio.get('/me/attendance', queryParameters: params);
    final list = response.data as List;
    return list.map(_mapSubject).toList();
  }

  static AttendanceSubject _mapSubject(dynamic json) {
    final j = json as Map<String, dynamic>;
    final sessions = (j['sessions'] as List?)?.map(_mapSession).toList() ?? [];
    return AttendanceSubject(
      id: j['classroomSubjectId'].toString(),
      name: j['subjectName'] as String? ?? '',
      teacher: j['teacherName'] as String? ?? '',
      totalSessions: (j['totalSessions'] as num?)?.toInt() ?? 0,
      presentSessions: (j['presentSessions'] as num?)?.toInt() ?? 0,
      lateSessions: (j['lateSessions'] as num?)?.toInt() ?? 0,
      excusedAbsent: (j['excusedAbsent'] as num?)?.toInt() ?? 0,
      unexcusedAbsent: (j['unexcusedAbsent'] as num?)?.toInt() ?? 0,
      warningThreshold: (j['warningThreshold'] as num?)?.toInt() ?? 0,
      status: _parseStatus(j['status'] as String?),
      sessions: sessions,
    );
  }

  static AttendanceSession _mapSession(dynamic json) {
    final j = json as Map<String, dynamic>;
    final statusRaw = j['status'] as String? ?? '';
    final (label, color) = _sessionLabel(statusRaw);
    return AttendanceSession(
      date: _formatDate(j['date'] as String? ?? ''),
      slotLabel: j['slotLabel'] as String? ?? '',
      subjectName: j['subjectName'] as String? ?? '',
      statusLabel: label,
      color: color,
    );
  }

  static (String, Color) _sessionLabel(String status) {
    return switch (status) {
      'present' => ('Có mặt', AppColors.fptGreen),
      'late' => ('Đi muộn', AppColors.info),
      'excused_absent' => ('Vắng có phép', AppColors.warning),
      'unexcused_absent' => ('Vắng không phép', AppColors.danger),
      _ => ('Không xác định', AppColors.textSecondary),
    };
  }

  static AttendanceStatus _parseStatus(String? status) {
    return switch (status) {
      'safe' => AttendanceStatus.safe,
      'attention' => AttendanceStatus.attention,
      'danger' => AttendanceStatus.danger,
      'exceeded' => AttendanceStatus.exceeded,
      _ => AttendanceStatus.safe,
    };
  }

  static String _formatDate(String isoDate) {
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return isoDate;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
  }
}

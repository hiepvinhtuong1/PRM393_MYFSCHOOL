import '../network/api_client.dart';

class ChildInfo {
  final int id;
  final String studentCode;
  final String fullName;
  final String? classroomName;

  const ChildInfo({
    required this.id,
    required this.studentCode,
    required this.fullName,
    this.classroomName,
  });

  factory ChildInfo.fromJson(Map<String, dynamic> json) => ChildInfo(
        id: (json['id'] as num).toInt(),
        studentCode: json['studentCode'] as String? ?? '',
        fullName: json['fullName'] as String? ?? '',
        classroomName: json['classroomName'] as String?,
      );
}

class ProfileData {
  final String fullName;
  final String role; // 'STUDENT' | 'PARENT'
  final String? studentCode;
  final String? parentCode;
  final String? classroomName;
  final String? campusName;
  final String? dateOfBirth;
  final String? gender;
  final String? phone;
  final String? email;
  final String? photoUrl;
  final List<ChildInfo> children;

  const ProfileData({
    required this.fullName,
    required this.role,
    this.studentCode,
    this.parentCode,
    this.classroomName,
    this.campusName,
    this.dateOfBirth,
    this.gender,
    this.phone,
    this.email,
    this.photoUrl,
    this.children = const [],
  });

  bool get isParent => role == 'PARENT';
  bool get isStudent => role == 'STUDENT';

  factory ProfileData.fromJson(Map<String, dynamic> json, String role) {
    if (role == 'PARENT') {
      final childrenJson = json['children'] as List? ?? [];
      return ProfileData(
        fullName: json['fullName'] as String? ?? '',
        role: 'PARENT',
        parentCode: json['parentCode'] as String?,
        dateOfBirth: json['dateOfBirth'] as String?,
        gender: json['gender'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        children: childrenJson
            .map((c) => ChildInfo.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
    } else {
      return ProfileData(
        fullName: json['fullName'] as String? ?? '',
        role: 'STUDENT',
        studentCode: json['studentCode'] as String?,
        classroomName: json['classroomName'] as String?,
        campusName: json['campusName'] as String?,
        dateOfBirth: json['dateOfBirth'] as String?,
        gender: json['gender'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );
    }
  }
}

class ProfileService {
  final _dio = ApiClient.instance.dio;

  Future<ProfileData> getProfile(String role) async {
    final response = await _dio.get('/me/profile');
    return ProfileData.fromJson(
      response.data['data'] as Map<String, dynamic>,
      role,
    );
  }
}

import 'package:dio/dio.dart';
import '../network/api_client.dart';

class UploadService {
  final _dio = ApiClient.instance.dio;

  Future<String> uploadImage(String filePath, {String folder = 'myfptschool'}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
      'folder': folder,
    });
    final response = await _dio.post<Map<String, dynamic>>('/upload', data: formData);
    final data = response.data?['data'] as Map<String, dynamic>?;
    return data?['url'] as String? ?? '';
  }
}

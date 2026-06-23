import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/mock/profile_mock_data.dart';
import '../../../core/services/upload_service.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

class ProfileHeaderCard extends StatefulWidget {
  const ProfileHeaderCard({super.key, required this.profile});

  final ProfileInfo profile;

  @override
  State<ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends State<ProfileHeaderCard> {
  bool _uploading = false;
  final _uploadService = UploadService();
  final _picker = ImagePicker();

  Future<void> _pickAndUpload() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return;

    setState(() => _uploading = true);
    try {
      final url = await _uploadService.uploadImage(file.path, folder: 'students/avatars');
      // Save to backend
      await ApiClient.instance.dio.patch('/me/photo', data: {'photoUrl': url});
      // Reload profile
      await Get.find<AuthController>().refreshProfile();
      if (mounted) {
        Get.snackbar('Thành công', 'Đã cập nhật ảnh đại diện',
            backgroundColor: AppColors.fptGreen, colorText: Colors.white);
      }
    } catch (_) {
      if (mounted) {
        Get.snackbar('Lỗi', 'Không thể tải ảnh, thử lại sau');
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final photoUrl = widget.profile.photoUrl;

    return AppCard(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickAndUpload,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.fptOrange,
                    shape: BoxShape.circle,
                    image: photoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(photoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: photoUrl == null
                      ? Text(
                          widget.profile.initials,
                          style: textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      : null,
                ),
                if (_uploading)
                  const SizedBox(
                    width: 88,
                    height: 88,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ),
                  )
                else
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.fptOrange,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.profile.fullName,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${widget.profile.role} • ${widget.profile.className}',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.successBackground,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                'Trực tuyến',
                style: TextStyle(
                  color: AppColors.fptGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Điều khoản & Chính sách'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PolicySection(
              title: '1. Điều khoản sử dụng',
              body:
                  'Ứng dụng MyFPTSchool được phát triển và vận hành bởi FPT School nhằm hỗ trợ học sinh THPT theo dõi kết quả học tập, điểm danh, lịch học và thông báo từ nhà trường.\n\n'
                  'Bằng việc sử dụng ứng dụng, bạn đồng ý tuân thủ các điều khoản và điều kiện được quy định trong tài liệu này. Nhà trường có quyền cập nhật điều khoản bất kỳ lúc nào và sẽ thông báo đến người dùng qua kênh chính thức.',
            ),
            _PolicySection(
              title: '2. Quyền riêng tư và bảo mật dữ liệu',
              body:
                  'FPT School cam kết bảo vệ thông tin cá nhân của học sinh và phụ huynh. Dữ liệu thu thập bao gồm: thông tin hồ sơ học sinh, kết quả học tập, lịch sử điểm danh và thông tin liên lạc.\n\n'
                  'Dữ liệu này chỉ được sử dụng cho mục đích quản lý giáo dục và không được chia sẻ với bên thứ ba khi chưa có sự đồng ý của người dùng, trừ trường hợp pháp luật yêu cầu.',
            ),
            _PolicySection(
              title: '3. Tài khoản người dùng',
              body:
                  'Mỗi học sinh được cấp một tài khoản duy nhất để truy cập ứng dụng. Người dùng có trách nhiệm bảo mật thông tin đăng nhập và không chia sẻ tài khoản cho người khác.\n\n'
                  'Mọi hoạt động thực hiện qua tài khoản của bạn đều được xem là do bạn thực hiện. Nếu phát hiện tài khoản bị xâm phạm, vui lòng liên hệ ngay bộ phận hỗ trợ nhà trường.',
            ),
            _PolicySection(
              title: '4. Sử dụng hợp lệ',
              body:
                  'Người dùng không được phép sử dụng ứng dụng cho các mục đích vi phạm pháp luật, gây hại đến hệ thống, hoặc ảnh hưởng đến quyền lợi của người dùng khác.\n\n'
                  'Cấm các hành vi: cố ý truy cập trái phép vào dữ liệu của người khác, phát tán thông tin sai lệch, hoặc khai thác lỗ hổng của ứng dụng.',
            ),
            _PolicySection(
              title: '5. Giới hạn trách nhiệm',
              body:
                  'FPT School không chịu trách nhiệm về các thiệt hại phát sinh do sự cố kỹ thuật ngoài tầm kiểm soát, bao gồm mất điện, sự cố mạng hoặc tấn công mạng từ bên ngoài.\n\n'
                  'Chúng tôi nỗ lực duy trì dịch vụ ổn định 24/7 nhưng không đảm bảo ứng dụng hoàn toàn không có gián đoạn.',
            ),
            _PolicySection(
              title: '6. Liên hệ hỗ trợ',
              body:
                  'Nếu bạn có câu hỏi hoặc thắc mắc về điều khoản và chính sách, vui lòng liên hệ:\n\n'
                  '• Email: support@fptschool.edu.vn\n'
                  '• Hotline: 1800 6000 (Miễn phí, thứ Hai – Thứ Sáu, 07:30 – 17:00)\n'
                  '• Phòng Công nghệ thông tin, Tầng 2, Khu B',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Cập nhật lần cuối: 01/01/2026',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

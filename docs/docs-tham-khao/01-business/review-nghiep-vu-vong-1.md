# Review nghiệp vụ vòng 1

**Trạng thái:** Superseded bởi yêu cầu ba portal và câu trả lời ngày 2026-06-15  
**Ngày review:** 2026-06-15  
**Đầu vào:** prompt UI 8 màn hình và scaffold Flutter/Spring Boot hiện tại.

## Kết luận lịch sử

Đầu vào tại thời điểm review là mô tả giao diện, chưa phải đặc tả nghiệp vụ có thể triển khai production.
Nó cho biết “màn hình trông như thế nào” nhưng thiếu actor, quyền, quy tắc dữ liệu, luồng lỗi,
trạng thái và tiêu chí chấp nhận. Cần sửa theo module, không nên dùng nguyên prompt cũ để sinh
toàn bộ ứng dụng.

## Phát hiện ưu tiên cao

1. **Mâu thuẫn stack:** yêu cầu ghi React Native/Expo/NativeWind nhưng repo là Flutter.
   Baseline đã chuyển sang Flutter, chờ xác nhận tại `Q-01/T-01`.
2. **Actor không nhất quán:** model nói Student/Parent, Trang chủ chào phụ huynh, nhưng không
   có quy tắc đăng nhập, chọn con hoặc phân quyền.
3. **Điểm số chưa có công thức:** “hệ số”, “TB môn”, “thi”, “TB HK”, “xếp loại” chưa mô tả
   quan hệ và cách làm tròn. Đây là dữ liệu nhạy cảm, không được tự suy diễn.
4. **Reset password thiếu luồng:** chỉ có nhập email, chưa có OTP/link, hết hạn, retry,
   rate limit, đổi mật khẩu mới và trạng thái thành công.
5. **Đơn từ mới là catalog UI:** chưa có schema theo loại đơn, attachment, validation,
   người duyệt, chuyển trạng thái, hủy/rút đơn và lịch sử.
6. **CLB thiếu transaction:** “Đăng ký tham gia” chưa có quota, deadline, eligibility,
   trạng thái chờ duyệt hoặc chống đăng ký trùng.
7. **Navigation thiếu:** Forms và Clubs có màn hình nhưng không nằm trong 5 tab; tab Cá nhân
   lại chưa có màn hình đặc tả.
8. **Thông báo chưa thành module:** có widget Trang chủ nhưng thiếu danh sách, chi tiết,
   đã đọc/chưa đọc và deep link.

## Điều chỉnh đề xuất cho 8 màn hình

| Màn hình cũ | Điều chỉnh nghiệp vụ bắt buộc |
|---|---|
| Đăng nhập | Xác định định danh, SSO hay mật khẩu, lỗi khóa tài khoản, lưu phiên, logout |
| Reset mật khẩu | Đặc tả đầy đủ request, verify, đặt mật khẩu mới, hết hạn và rate limit |
| Trang chủ | Dữ liệu theo actor/học sinh đang chọn; mỗi card có empty/error và điều hướng |
| Bảng điểm | Backend trả dữ liệu đã công bố; xác định công thức, quyền, trạng thái chưa có điểm |
| Lịch học | Hỗ trợ ngày không học, đổi lịch, lịch bù/thi và timezone |
| Sự kiện | Chuẩn hóa trạng thái theo thời gian; thêm chi tiết và trường hợp ảnh lỗi |
| Đơn từ | Tách catalog loại đơn, form động/tĩnh, submission và timeline trạng thái |
| Câu lạc bộ | Tách catalog, chi tiết, membership và registration |

## Đề xuất phạm vi tại thời điểm review

Phân kỳ mobile-only trước đây đã bị thay thế. Baseline mới yêu cầu đủ ba portal trong phiên
bản production đầu tiên.

## Rủi ro kiến trúc

- Thiết kế API theo màn hình thay vì domain sẽ tạo endpoint khó tái sử dụng.
- Trả JPA entity trực tiếp dễ rò dữ liệu và khóa chặt database schema vào mobile.
- Tính điểm ở mobile tạo kết quả không nhất quán.
- Không mô hình hóa quan hệ phụ huynh-học sinh sẽ dẫn tới lỗi phân quyền nghiêm trọng.
- Làm cả 8 màn hình “pixel-perfect” trước khi chốt luồng sẽ tạo UI đẹp nhưng không hoàn chỉnh.

## Các câu hỏi lịch sử đã được trả lời

Baseline mới nằm trong `docs/00-project`, `docs/01-business` và `docs/03-architecture`.

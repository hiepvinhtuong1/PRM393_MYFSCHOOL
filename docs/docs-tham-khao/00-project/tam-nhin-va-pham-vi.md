# Tầm nhìn và phạm vi

**Trạng thái:** Accepted  
**Cập nhật:** 2026-06-15

## Tầm nhìn

MyFPTSchool là hệ thống quản lý trường học khép kín cho một trường, kết nối nhà trường,
giáo viên và phụ huynh trên cùng một nền tảng dữ liệu.

## Ba cổng giao tiếp

| Portal | Nền tảng | Người dùng |
|---|---|---|
| School Admin Portal | React web app | Super Admin, School Admin, Ban Giám Hiệu |
| Teacher Workspace | Cùng React web app, UI theo role | Giáo viên Chủ nhiệm, Giáo viên Bộ môn |
| Parent App | Flutter iOS/Android | Phụ huynh |

School Admin Portal và Teacher Workspace là hai không gian chức năng trong cùng web app
`mysfchoolse1911webapp`, không phải hai ứng dụng triển khai độc lập.

## Mục tiêu

- Quản lý tập trung tài khoản, quyền, năm học, lớp, môn, thời khóa biểu và bảng điểm.
- Hỗ trợ giáo viên điểm danh, nhập điểm và xử lý đơn nghỉ học.
- Giúp phụ huynh theo dõi nhiều con, nhận thông báo thời gian thực và thực hiện nghiệp vụ
  hành chính/ngoại khóa.
- Bảo đảm dữ liệu chỉ được công bố sau đúng quy trình và đúng phạm vi người nhận.

## Phạm vi phiên bản production đầu tiên

Phiên bản đầu tiên phải có đủ cả ba portal và các module:

1. Xác thực bằng số điện thoại, quản lý tài khoản và phân quyền chi tiết.
2. Năm học, hai học kỳ, tổng kết cả năm, cấp/khối/lớp/môn/phân công giáo viên.
3. Import, kiểm tra và công bố thời khóa biểu.
4. Điểm danh theo tiết và lịch sử điểm danh.
5. Sổ điểm, khóa/nộp, duyệt, công bố; hạnh kiểm và học lực.
6. Tin tức, thông báo, sự kiện và push notification.
7. Đơn xin nghỉ học ngắn ngày/dài ngày và luồng duyệt.
8. Quản lý, đăng ký và hủy đăng ký câu lạc bộ.
9. Chuyển đổi hồ sơ khi phụ huynh có nhiều con.

## Ngoài phạm vi đã xác nhận

- Học sinh đăng nhập trực tiếp.
- Nhiều trường/multi-tenant.
- Chuyển lớp giữa năm.
- Thanh toán CLB.
- Danh sách chờ CLB.
- File đính kèm trong đơn nghỉ học.
- Lập lịch xuất bản CMS.
- Xác nhận phụ huynh đã đọc thông báo.
- Xuất Excel/PDF, yêu cầu backup nghiệp vụ và chính sách lưu trữ tùy chỉnh.
- OTP quên mật khẩu trong phiên bản hiện tại; để dành giai đoạn sau.

## Quy mô và tải mục tiêu

- 1.500-2.000 học sinh.
- 100-150 giáo viên/nhân viên.
- Peak dự kiến 100-200 request/giây vào đầu giờ sáng.
- Hệ thống được định hướng production, không phải chỉ là bản demo dữ liệu giả.


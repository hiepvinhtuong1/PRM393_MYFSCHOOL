# Yêu cầu phi chức năng

**Trạng thái:** Draft cần benchmark

## Hiệu năng

- Quy mô: 2.000 học sinh, 150 nhân sự.
- Mục tiêu thiết kế ban đầu: chịu burst 200 request/giây ở luồng điểm danh.
- API đọc thông thường: đề xuất p95 dưới 500 ms trong điều kiện tải mục tiêu.
- API ghi thông thường: đề xuất p95 dưới 1 giây, không tính upload/import file.
- Import TKB phải trả danh sách lỗi hữu ích; giới hạn dung lượng/số dòng cần chốt.

Các con số latency là đề xuất kỹ thuật, chưa phải SLA đã ký.

## Độ tin cậy

- Không mất hoặc nhân đôi đăng ký CLB khi request đồng thời.
- Không publish dữ liệu một phần khi import TKB lỗi.
- Push thất bại không rollback nghiệp vụ đã commit; phải retry và quan sát được.
- Backup/restore hạ tầng vẫn cần cho production dù không có chức năng backup trong UI.

## Bảo mật

- TLS cho mọi môi trường có dữ liệu thật.
- Rate limit đăng nhập; chống credential stuffing.
- Password không lưu plaintext; secret nằm ngoài repository.
- RBAC và data scope được test ở API.
- Dữ liệu cá nhân tối thiểu hóa trong log và thông báo push.

## Audit tối thiểu

Dù người dùng không yêu cầu module audit, production phải lưu lịch sử cho:

- Sửa điểm sau công bố.
- Sửa điểm danh sau khóa.
- Thay đổi role/permission.
- Khóa/reset tài khoản.
- Duyệt/từ chối/công bố bảng điểm và hạnh kiểm.

## Khả dụng và quan sát

- Health/readiness check, structured log, trace/request ID.
- Metrics latency, error rate, auth failure, push failure và queue/retry.
- Có staging gần production và load test riêng cho đầu giờ sáng.
- Mobile hiển thị dữ liệu cũ hợp lý khi mất mạng nhưng không cho mutation giả thành công.

## Tương thích

- Parent App: iOS/Android; phiên bản OS tối thiểu cần chốt.
- Teacher Workspace responsive cho desktop và tablet.
- Browser support matrix cần chốt trước release.


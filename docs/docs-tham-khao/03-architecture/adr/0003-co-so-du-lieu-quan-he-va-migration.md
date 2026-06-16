# ADR-0003: SQL Server relational schema và versioned migration

**Trạng thái:** Proposed  
**Ngày:** 2026-06-15

## Bối cảnh

MyFPTSchool có quan hệ chặt giữa tài khoản, role, phụ huynh-học sinh, lớp, phân công, điểm,
điểm danh và quy trình publish. Các nghiệp vụ TKB atomic, quota CLB và audit sau công bố cần
transaction và constraint rõ.

## Quyết định đề xuất

- Dùng SQL Server theo relational schema trong `docs/03-architecture/database/`.
- Dùng `bigint identity`, FK, unique/check constraint và `rowversion`.
- Dùng migration có version; baseline đề xuất Flyway.
- Dùng snapshot table cho kết quả đã công bố.
- Dùng transactional outbox cho push notification.
- Dùng Testcontainers SQL Server cho integration test.

## Hệ quả tích cực

- Authorization scope và dữ liệu học vụ có quan hệ truy vấn rõ.
- Giữ được tính nhất quán khi concurrent registration/import/publish.
- Schema thay đổi có thể review và triển khai lặp lại.
- Dữ liệu đã công bố không bị đổi ngầm khi policy tính điểm thay đổi.

## Đánh đổi

- Số bảng lớn hơn mô hình CRUD đơn giản.
- Cần mapping DTO/entity và migration discipline.
- Outbox, workflow log và snapshot tăng khối lượng code nhưng giảm rủi ro production.

## Điều kiện chấp nhận

Chốt permission matrix, grading policy và timetable import template trước migration nghiệp vụ
đầu tiên.


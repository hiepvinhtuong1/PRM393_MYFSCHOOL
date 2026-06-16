# Thiết kế cơ sở dữ liệu

**Trạng thái:** Baseline đang triển khai  
**Database:** Microsoft SQL Server  
**Cập nhật:** 2026-06-16

## Tài liệu

- [ERD theo bounded context](erd.md)
- [Data dictionary và constraint](data-dictionary.md)

Logical schema tiếp tục được triển khai theo từng vertical slice:

- `V001`: nền tảng `system_settings`, `audit_events`.
- `V002`: identity, tài khoản, refresh token và RBAC.
- `V003`: people, academic structure, timetable, teaching session, attendance và notification nền.
- `V004`: grading policy, gradebook, score, workflow, published result, conduct và term summary.
- `V005`: leave request, content CMS, content target, notification inbox và club registration.
- `V006`: bổ sung `image_url` cho content CMS và CLB.

## Nguyên tắc

- Dùng relational model và FK cho dữ liệu nghiệp vụ cốt lõi.
- PK dùng `bigint identity`; API không để client suy ra quyền từ ID.
- Thời điểm dùng `datetimeoffset(0)` và lưu UTC; ngày học dùng `date`; giờ tiết dùng `time(0)`.
- Dữ liệu cạnh tranh có cột `row_version rowversion`.
- Không dùng cascade delete cho điểm, điểm danh, đơn, publish và audit.
- Không soft-delete toàn hệ thống. Master data dùng `status`/`is_active`; dữ liệu nghiệp vụ
  quan trọng được giữ lịch sử.
- Trường text tiếng Việt dùng `nvarchar`.
- Tiền tố bảng không được dùng; tên bảng/cột dùng `snake_case`, số nhiều.
- Enum nghiệp vụ lưu `varchar` và được validate ở application; thêm `CHECK` cho tập ổn định.
- JSON chỉ dùng cho payload outbox/audit hoặc cấu hình công thức chưa ổn định, không thay thế
  quan hệ và constraint chính.

## Cột chuẩn

Các aggregate/master table nên có:

```text
id bigint identity primary key
created_at datetimeoffset(0) not null
created_by_account_id bigint null
updated_at datetimeoffset(0) not null
updated_by_account_id bigint null
row_version rowversion
```

Không bắt buộc lặp toàn bộ cột audit trên bảng nối bất biến nhỏ. FK `created_by`/`updated_by`
có thể không khai báo cascade.

## Chiến lược migration

- Dùng Flyway hoặc Liquibase; baseline đề xuất là Flyway.
- Mỗi thay đổi schema có migration tiến, không sửa migration đã chạy ở môi trường dùng chung.
- Production đặt `spring.jpa.hibernate.ddl-auto=validate`.
- Test integration ưu tiên Testcontainers SQL Server để bắt khác biệt dialect/constraint.
- Seed role/permission và master data bằng migration riêng, không seed dữ liệu cá nhân thật.

## Nhóm bảng

| Nhóm | Số bảng baseline | Mục đích |
|---|---:|---|
| Identity & RBAC | 8 | Tài khoản, phiên, role, permission, thiết bị |
| People & Academic | 14 | Người dùng nghiệp vụ, lớp, môn, phân công |
| Timetable & Attendance | 8 | TKB, tiết học thực tế, điểm danh, lịch sử |
| Assessment & Conduct | 13 | Chính sách điểm, sổ điểm, publish, hạnh kiểm |
| Leave Requests | 3 | Đơn nghỉ, tiết nghỉ và lịch sử trạng thái |
| Content & Notification | 6 | CMS, target, media, inbox và outbox |
| Clubs | 2 | CLB và đăng ký |
| Cross-cutting | 1 | Audit event |

Tổng baseline: **55 bảng**. Một số bảng có thể được gộp sau review, nhưng không nên gộp chỉ để
giảm số lượng nếu làm mất constraint hoặc lịch sử nghiệp vụ.

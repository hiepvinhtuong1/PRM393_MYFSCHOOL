# Quy ước REST API

**Trạng thái:** Baseline

## Quy ước

- Base path `/api/v1`, JSON `camelCase`, ISO 8601, timezone nghiệp vụ `Asia/Ho_Chi_Minh`.
- `401` chưa xác thực; `403` thiếu permission/scope; `409` xung đột state/quota.
- DTO tách khỏi JPA entity.
- Mutation quan trọng trả state mới và hỗ trợ idempotency khi có nguy cơ gửi lặp.
- Danh sách dùng `page`, `size`, `sort`, filter rõ ràng.

## Error contract

```json
{
  "timestamp": "2026-06-15T10:30:00+07:00",
  "status": 409,
  "code": "CLUB_CAPACITY_REACHED",
  "message": "Câu lạc bộ đã đủ số lượng.",
  "fieldErrors": {},
  "traceId": "01J..."
}
```

Import file có thêm:

```json
{
  "code": "TIMETABLE_IMPORT_INVALID",
  "errors": [
    { "row": 12, "column": "subjectCode", "message": "Mã môn không tồn tại." }
  ]
}
```

## Endpoint inventory

### Identity và RBAC

| Method/path | Mục đích |
|---|---|
| `POST /auth/login` | Đăng nhập số điện thoại/mật khẩu |
| `POST /auth/refresh` | Làm mới phiên |
| `POST /auth/logout` | Thu hồi phiên |
| `GET /me` | Profile, roles, permissions, student links |
| `/accounts` | CRUD/lock/reset tài khoản theo permission |
| `/roles`, `/permissions` | Quản lý RBAC |

#### Contract xác thực F01

`POST /auth/login` nhận:

```json
{
  "phoneNumber": "0900000001",
  "password": "MyFPT@123"
}
```

Login và refresh trả `accessToken`, `refreshToken`, `tokenType`, `expiresAt` và `account`.
`account` chứa `id`, `phoneNumber`, `displayName`, `roles`, `permissions`.

- Access token mặc định có hiệu lực 15 phút.
- Refresh token mặc định có hiệu lực 30 ngày và được xoay vòng sau mỗi lần refresh.
- `POST /auth/logout` và `POST /auth/refresh` nhận `{ "refreshToken": "..." }`.
- Client gửi access token bằng header `Authorization: Bearer <token>`.

#### Endpoint quản trị tài khoản và RBAC F01

| Method/path | Permission | Mục đích |
|---|---|---|
| `GET /accounts?query=&page=&size=` | `account.read` | Tìm kiếm, phân trang tài khoản |
| `POST /accounts` | `account.create` | Tạo tài khoản với một hoặc nhiều role |
| `PATCH /accounts/{id}/lock` | `account.lock` | Khóa hoặc mở khóa |
| `POST /accounts/{id}/reset-password` | `account.reset_password` | Sinh mật khẩu tạm thời |
| `PATCH /accounts/{id}/roles` | `account.create` | Thay tập role của tài khoản |
| `GET /roles` | `rbac.read` | Xem role và permission đang gán |
| `GET /permissions` | `rbac.read` | Xem permission catalog |
| `PUT /roles/{roleCode}/permissions` | `rbac.manage` | Thay tập permission của role |

Payload cập nhật permission:

```json
{
  "permissions": ["account.read", "account.create"]
}
```

### Học vụ và giáo viên

| Method/path | Mục đích |
|---|---|
| `/school-years`, `/terms`, `/grades`, `/classes`, `/subjects` | Cấu trúc học vụ |
| `/teaching-assignments` | Phân công lớp + môn + học kỳ |
| `POST /timetables/imports` | Validate/import atomic |
| `POST /timetables/{id}/publish` | Công bố/ghi đè TKB |
| `GET /teaching-sessions/mine` | Tiết dạy của giáo viên |
| `PUT /teaching-sessions/{id}/attendance` | Lưu điểm danh |
| `/gradebooks` | Xem/nhập sổ điểm theo scope |
| `POST /gradebooks/{id}/submit` | Khóa và nộp |
| `POST /gradebooks/{id}/approve` | Duyệt |
| `POST /gradebooks/{id}/reject` | Trả về Draft |
| `POST /gradebooks/{id}/publish` | Công bố |
| `/conduct-records` | Nhập/duyệt hạnh kiểm |

#### Endpoint đã triển khai trong F02-F04

| Method/path | Permission | Mục đích |
|---|---|---|
| `GET /academic/overview` | `academic_structure.read` | Dữ liệu tổng hợp cấu trúc học vụ |
| `POST /academic/school-years` | `academic_structure.manage` | Tạo năm học và ba reporting period |
| `POST /academic/classes` | `academic_structure.manage` | Tạo lớp |
| `POST /academic/subjects` | `academic_structure.manage` | Tạo môn numeric hoặc pass/fail |
| `POST /academic/teachers` | `academic_structure.manage` | Tạo hồ sơ giáo viên từ account |
| `POST /academic/students` | `academic_structure.manage` | Tạo học sinh và enrollment tùy chọn |
| `POST /academic/parent-links` | `academic_structure.manage` | Liên kết phụ huynh-học sinh |
| `POST /academic/teaching-assignments` | `academic_structure.manage` | Phân công GVBM |
| `POST /academic/homeroom-assignments` | `academic_structure.manage` | Phân công GVCN |
| `GET /academic/students/mine` | `student_profile.read` | Hồ sơ học sinh theo data scope |
| `POST /timetables/imports` | `timetable.import` | Import Excel multipart atomic |
| `GET /timetables` | `timetable.read` | Danh sách TKB |
| `POST /timetables/{id}/publish` | `timetable.publish` | Publish và sinh teaching session |
| `GET /timetables/mine` | `timetable.read` | Lịch dạy của giáo viên |
| `GET /timetables/students/{studentId}` | `timetable.read` | Lịch học đã publish của con |
| `GET /attendance/sessions?from=&to=` | `attendance.take` hoặc correction | Tiết theo giáo viên; Admin correction xem toàn trường |
| `GET /attendance/sessions/{sessionId}` | `attendance.read` | Roster và dữ liệu điểm danh |
| `PUT /attendance/sessions/{sessionId}` | `attendance.take` hoặc correction | Lưu hàng loạt |
| `GET /attendance/students/{studentId}` | `attendance.read` | Lịch sử điểm danh của con |
| `GET /gradebooks` | `gradebook.read` | Danh sách sổ theo data scope |
| `GET /gradebooks/{id}` | `gradebook.read` | Ma trận học sinh, cột điểm và điểm hiện tại |
| `PUT /gradebooks/{id}/scores` | `gradebook.edit` | Lưu điểm nháp hàng loạt |
| `POST /gradebooks/{id}/submit` | `gradebook.submit` | Khóa và nộp sổ |
| `POST /gradebooks/{id}/approve` | `gradebook.review` | Duyệt sổ |
| `POST /gradebooks/{id}/reject` | `gradebook.review` | Trả sổ về Draft kèm lý do |
| `POST /gradebooks/class-terms/{termId}/{classId}/publish` | `gradebook.publish` | Công bố đồng bộ lớp/học kỳ |
| `GET /gradebooks/students/{studentId}` | `gradebook.read` | Snapshot kết quả đã công bố của con |
| `GET /grading-policies`, `PUT /grading-policies/{id}` | `gradebook.read` / `grading_policy.manage` | Xem/cập nhật hệ số, làm tròn, xếp loại |
| `/conduct/class-terms` | `conduct.edit` hoặc `conduct.review` | Nhập, nộp, duyệt, từ chối hạnh kiểm |

File Excel TKB dùng đúng thứ tự cột:

```text
classCode, termCode, dayOfWeek, periodNumber, subjectCode, teacherCode, room
```

`dayOfWeek` dùng ISO: Thứ Hai là `1`, Chủ Nhật là `7`.

Khi `PUT /attendance/sessions/{sessionId}` cho ngày đã qua, caller phải có
`attendance.correct_after_lock` và gửi `correctionReason`. Giáo viên không được phân công nhận
`403`; giáo viên sửa sau ngày nhận `409`.

F05 không có endpoint publish từng sổ. Publish theo lớp/học kỳ chỉ thành công khi tất cả
gradebook và conduct record đều `APPROVED`.

### Parent App

| Method/path | Mục đích |
|---|---|
| `GET /students/{studentId}/dashboard` | Dashboard |
| `GET /students/{studentId}/timetable` | Lịch đã publish |
| `GET /students/{studentId}/attendance` | Lịch sử điểm danh |
| `GET /students/{studentId}/grades` | Điểm/hạnh kiểm đã publish |
| `/students/{studentId}/leave-requests` | Tạo, xem, sửa, hủy đơn |
| `GET /notifications` | Trung tâm thông báo cá nhân |
| `PATCH /notifications/{id}/read` | Đánh dấu đã đọc |
| `GET /contents` | News/Announcement/Event published |
| `GET /clubs` | Danh sách CLB, gồm ảnh đại diện và trạng thái đăng ký của học sinh |
| `POST /students/{studentId}/club-registrations` | Đăng ký atomic |
| `DELETE /students/{studentId}/club-registrations/{id}` | Hủy đăng ký |

`/students/{studentId}/leave-requests` đã triển khai các method `GET`, `POST`, `PUT`,
`DELETE`. `POST`/`PUT` nhận `startDate`, `endDate`, `lessonPeriodIds`, `reason`.
Đơn một ngày bắt buộc có `lessonPeriodIds`; đơn dài ngày bỏ qua danh sách tiết.

### Quản trị nội dung

| Method/path | Mục đích |
|---|---|
| `/contents` | CRUD CMS content |
| `GET /contents/manage` | Danh sách nội dung nháp/đã xuất bản cho Admin |
| `POST /contents/{id}/publish` | Publish và target trường/khối/lớp |
| `/clubs` | CRUD CLB, ảnh đại diện, duyệt mở đăng ký và quota |
| `GET /clubs/{id}/registrations` | Admin xem danh sách học sinh đăng ký CLB |
| `GET /leave-requests/pending` | GVCN xem đơn chờ duyệt theo lớp chủ nhiệm |
| `POST /leave-requests/{id}/approve` | GVCN duyệt đơn |
| `POST /leave-requests/{id}/reject` | GVCN từ chối đơn kèm lý do |

Inventory chưa thay thế OpenAPI contract chi tiết.

API DTO không được ánh xạ một-một tùy tiện với table. Logical schema và data dictionary xem
[Thiết kế cơ sở dữ liệu](database/README.md).

## Concurrency

- Đăng ký CLB phải chống overbooking bằng constraint/locking phù hợp.
- State transition dùng optimistic locking hoặc điều kiện state ở câu lệnh update.
- Import TKB có transaction boundary toàn file.
- Client nhận `409` khi dữ liệu đã đổi hoặc thao tác không còn hợp lệ.

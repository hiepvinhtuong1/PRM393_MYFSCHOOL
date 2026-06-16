# Phân quyền RBAC

**Trạng thái:** Baseline đã triển khai cho F01-F05 ngày 2026-06-15
**Nguyên tắc:** Tài khoản có thể mang nhiều role; quyền thực tế là hợp của các permission
được gán, sau đó bị giới hạn bởi phạm vi dữ liệu.

## Role đã xác nhận

| Role | Phạm vi chính |
|---|---|
| `SUPER_ADMIN` | Cấu hình hệ thống, role/permission, toàn bộ tài khoản |
| `SCHOOL_ADMIN` | Vận hành tài khoản, học vụ, TKB, CMS, CLB |
| `BAN_GIAM_HIEU` | Xem tổng quan, duyệt/công bố điểm và hạnh kiểm |
| `GVCN` | Hồ sơ lớp chủ nhiệm, duyệt đơn, nhập hạnh kiểm |
| `GVBM` | Điểm danh và sổ điểm trong phân công giảng dạy |
| `PHU_HUYNH` | Chỉ dữ liệu các học sinh đã liên kết |

Không có role `GIAO_VU` trong baseline.

## Permission catalog đề xuất

```text
account.read, account.create, account.lock, account.reset_password
rbac.read, rbac.manage
academic_structure.read, academic_structure.manage
timetable.read, timetable.import, timetable.publish
student_profile.read
attendance.read, attendance.take, attendance.correct_after_lock
gradebook.read, gradebook.edit, gradebook.submit, gradebook.review
gradebook.publish, gradebook.correct_published
grading_policy.manage
conduct.edit, conduct.review, conduct.publish
leave_request.create, leave_request.edit_own, leave_request.review
content.read, content.create, content.publish
club.read, club.manage, club.register, club.cancel_registration
notification.read
```

## Ma trận baseline

| Năng lực | Super Admin | School Admin | BGH | GVCN | GVBM | Phụ huynh |
|---|---:|---:|---:|---:|---:|---:|
| Quản lý tài khoản | Có | Có | Xem | Không | Không | Hồ sơ mình |
| Quản lý role/permission | Có | Chỉ xem | Không | Không | Không | Không |
| Cấu trúc năm/khối/lớp/môn | Có | Có | Xem | Xem lớp mình | Xem phân công | Xem của con |
| Import/publish TKB | Có | Có | Xem | Xem | Xem | Xem đã publish |
| Điểm danh | Xem | Xem/sửa sau khóa | Xem | Theo phân công nếu có GVBM | Nhập/sửa trong ngày | Xem của con |
| Sổ điểm | Xem/sửa đặc quyền | Cấu hình/xem | Duyệt/công bố | Theo role GVBM | Nhập/khóa/nộp | Xem đã công bố |
| Hạnh kiểm | Xem | Xem | Duyệt/công bố | Nhập | Không | Xem đã công bố |
| Đơn nghỉ | Xem | Xem | Xem | Duyệt lớp mình | Xem liên quan | Tạo/sửa/hủy khi chờ |
| CMS/Sự kiện | Có | Có | Chờ chốt | Xem | Xem | Xem published |
| CLB | Có | Có | Xem | Xem | GV phụ trách | Đăng ký/hủy cho con |

## Phạm vi dữ liệu bắt buộc

- `GVCN`: chỉ lớp chủ nhiệm trong đúng năm học/phân công.
- `GVBM`: chỉ lớp + môn + học kỳ được phân công.
- `PHU_HUYNH`: chỉ học sinh có quan hệ phụ huynh-học sinh đang hiệu lực.
- Permission ở frontend chỉ điều khiển UX; backend luôn kiểm tra lại permission và scope.

## Quy tắc quản trị đã triển khai trong F01

- `SUPER_ADMIN` có `rbac.read` và `rbac.manage`.
- `SCHOOL_ADMIN` có `rbac.read`, không được sửa ma trận permission.
- Chỉ tài khoản có `account.create` mới được tạo tài khoản và thay đổi role.
- Khóa/mở khóa và reset mật khẩu là các permission độc lập.
- Mọi cập nhật role/permission và thao tác quản trị tài khoản phải ghi audit.
- Data scope theo lớp, môn và quan hệ phụ huynh-học sinh sẽ được ràng buộc khi triển khai F02 trở đi.

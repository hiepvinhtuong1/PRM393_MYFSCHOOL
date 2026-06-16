# Tổng quan nghiệp vụ

**Trạng thái:** Accepted baseline

## Actor

| Actor | Portal | Mục tiêu |
|---|---|---|
| Super Admin | Web | Quản trị hệ thống, tài khoản, role và permission |
| School Admin | Web | Vận hành học vụ, TKB, nội dung, sự kiện và CLB |
| Ban Giám Hiệu | Web | Theo dõi, duyệt và công bố kết quả học tập/hạnh kiểm |
| GVCN | Web/Tablet | Quản lý lớp, duyệt đơn nghỉ, nhập hạnh kiểm |
| GVBM | Web/Tablet | Điểm danh và nhập điểm theo phân công |
| Phụ huynh | Mobile | Theo dõi và thao tác cho các học sinh đã liên kết |

Một giáo viên có thể đồng thời là GVCN và GVBM. Hệ thống không có tài khoản học sinh.

## Bounded context

| Module | Trách nhiệm |
|---|---|
| Identity & Access | Số điện thoại, mật khẩu, phiên, tài khoản, RBAC |
| People & Enrollment | Học sinh, phụ huynh, giáo viên, quan hệ, lớp |
| Academic Structure | Cấp, khối, năm học, học kỳ, môn, phân công |
| Timetable | Import, validate, publish, lịch theo lớp/giáo viên |
| Attendance | Điểm danh theo tiết, khóa ngày, lịch sử |
| Assessment | Khung điểm, sổ điểm, duyệt, công bố, học lực |
| Conduct | Hạnh kiểm cuối kỳ |
| Leave Requests | Đơn ngắn/dài ngày và phê duyệt |
| Content & Communication | News/Announcement/Event, targeting, notification |
| Clubs | Danh mục, slot, giáo viên phụ trách, registration |

## Rule xuyên suốt

- Backend là nơi quyết định authorization và data scope.
- Dữ liệu phụ huynh luôn gắn với học sinh đang chọn.
- Chỉ dữ liệu published mới hiển thị trên Parent App.
- Nghiệp vụ cạnh tranh như slot CLB và import TKB phải dùng transaction.
- Mọi chỉnh sửa dữ liệu học vụ sau khóa/công bố phải truy vết được.
- Không dùng dữ liệu học sinh thật trong fixture, screenshot hoặc log.

Chi tiết permission xem [Phân quyền RBAC](phan-quyen-rbac.md); state machine xem
[Quy trình nghiệp vụ](quy-trinh-nghiep-vu.md).


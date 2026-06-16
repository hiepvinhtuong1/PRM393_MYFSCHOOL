# Danh mục màn hình

**Trạng thái:** Baseline  
Danh mục xác định phạm vi; mỗi màn hình vẫn cần đặc tả acceptance criteria trước khi code.

## Web app dùng chung

Web app đổi menu, route và thao tác theo permission. Việc ẩn nút không thay thế kiểm tra quyền
ở backend.

### Admin Portal

| ID | Màn hình | Role chính |
|---|---|---|
| WEB-A01 | Đăng nhập bằng số điện thoại | Tất cả web roles |
| WEB-A02 | Dashboard quản trị | Super Admin, School Admin, BGH |
| WEB-A03 | Danh sách/tạo/khóa/reset tài khoản | Super Admin, School Admin |
| WEB-A04 | Role và permission matrix | Super Admin |
| WEB-A05 | Năm học, học kỳ, cấp, khối, lớp | School Admin |
| WEB-A06 | Môn học và phân công giáo viên | School Admin |
| WEB-A07 | Import/kiểm tra/publish TKB | School Admin |
| WEB-A08 | Cấu hình khung điểm/xếp loại | School Admin |
| WEB-A09 | Hàng chờ duyệt bảng điểm/hạnh kiểm | BGH |
| WEB-A10 | Chi tiết review, reject, approve, publish | BGH |
| WEB-A11 | Tra cứu điểm danh và sửa sau khóa | Theo permission |
| WEB-A12 | Quản lý CMS News/Announcement/Event | School Admin |
| WEB-A13 | Target nội dung theo trường/khối/lớp | School Admin |
| WEB-A14 | Quản lý CLB, slot, giáo viên phụ trách | School Admin |
| WEB-A15 | Danh sách học sinh đăng ký CLB | School Admin |

### Teacher Workspace

| ID | Màn hình | Role chính |
|---|---|---|
| WEB-T01 | Dashboard lịch dạy/lớp chủ nhiệm | GVCN, GVBM |
| WEB-T02 | Danh sách/hồ sơ lớp chủ nhiệm | GVCN |
| WEB-T03 | Danh sách đơn nghỉ cần xử lý | GVCN |
| WEB-T04 | Chi tiết duyệt/từ chối đơn | GVCN |
| WEB-T05 | Điểm danh theo tiết dạy | GVBM |
| WEB-T06 | Lịch sử điểm danh trong ngày | GVBM |
| WEB-T07 | Sổ điểm theo lớp/môn/học kỳ | GVBM |
| WEB-T08 | Khóa và nộp sổ điểm | GVBM |
| WEB-T09 | Nhập hạnh kiểm cuối kỳ | GVCN |

## Parent App

| ID | Màn hình | Dữ liệu/trạng thái chính |
|---|---|---|
| MOB-01 | Đăng nhập số điện thoại/mật khẩu | invalid, locked, loading, offline |
| MOB-02 | Chọn/chuyển hồ sơ học sinh | một hoặc nhiều học sinh |
| MOB-03 | Dashboard | shortcut, lịch hôm nay, thông báo mới |
| MOB-04 | Trung tâm thông báo | read/unread, deep link |
| MOB-05 | News feed | News/Announcement/Event published |
| MOB-06 | Chi tiết nội dung/sự kiện | ảnh, nội dung, thời gian/địa điểm |
| MOB-07 | Lịch học ngày/tuần | môn, giáo viên, phòng, giờ |
| MOB-08 | Lịch sử điểm danh | theo ngày/tiết/trạng thái/ghi chú |
| MOB-09 | Bảng điểm học kỳ | numeric hoặc Pass/Fail, chỉ published |
| MOB-10 | Tổng kết học lực/hạnh kiểm | học kỳ và cả năm |
| MOB-11 | Danh sách đơn nghỉ | pending/approved/rejected/cancelled |
| MOB-12 | Tạo đơn nghỉ một ngày | ngày, chọn tiết, lý do |
| MOB-13 | Tạo đơn nghỉ dài ngày | từ ngày, đến ngày, lý do |
| MOB-14 | Chi tiết/sửa/hủy đơn | chỉ sửa/hủy khi pending |
| MOB-15 | Danh sách/chi tiết CLB | slot, khai giảng, mô tả |
| MOB-16 | Đăng ký/hủy CLB | giới hạn ba, full, registered |
| MOB-17 | Hồ sơ và đăng xuất | phụ huynh/học sinh đang chọn |

OTP/quên mật khẩu chưa thuộc phiên bản hiện tại.

## Trạng thái triển khai

- Đã triển khai: `WEB-A01`, `WEB-A03`, `WEB-A04`, `WEB-A05`, `WEB-A06`, `WEB-A07`, `WEB-A11`,
  `WEB-A08`, `WEB-A09`, `WEB-A10`, `WEB-T02` ở mức danh sách theo scope, `WEB-T05`,
  `WEB-T06`, `WEB-T07`, `WEB-T08`, `WEB-T09`, `WEB-T03`, `WEB-T04`, `WEB-A02`,
  `WEB-A12`, `WEB-A13`, `WEB-A14`, `WEB-A15`.
- Đã triển khai: `MOB-01`, `MOB-02`, `MOB-03` phần lịch hôm nay, `MOB-07`, `MOB-08`,
  `MOB-09`, `MOB-10`, `MOB-11`, `MOB-12`, `MOB-13`, `MOB-14`, `MOB-15`, `MOB-16`,
  `MOB-17` phần hồ sơ và đăng xuất.
- Chưa hoàn thiện production: `MOB-06` chi tiết nội dung/sự kiện dạng màn riêng; hiện nội dung
  hiển thị trong tab Tin trường. Các kiểm thử tải, runbook triển khai và hardening release thuộc F09.

## Tiêu chí chung

- Có loading, empty, error, success và forbidden.
- Mọi danh sách lớn có filter, pagination hoặc virtualized list phù hợp.
- Web hoạt động trên desktop và tablet cho Teacher Workspace.
- Mobile hỗ trợ safe area, text scale, bàn phím và trạng thái mất mạng.
- Tác vụ nguy hiểm có confirm và hiển thị hậu quả.
- Màn hình học vụ thể hiện năm học/học kỳ/lớp/môn đang thao tác.
- Màn hình phụ huynh luôn thể hiện học sinh đang được chọn.
- Nội dung tiếng Việt thống nhất glossary; không hiển thị stack trace.

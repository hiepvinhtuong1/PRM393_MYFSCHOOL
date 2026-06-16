# Design system MyFPTSchool

**Trạng thái:** Draft  
**Định hướng:** Modern, clean, responsive, tiếng Việt.

> Token, typography, spacing, elevation và component visual chính thức được định nghĩa tại
> [FPT Education Digital Experience](design.md). File này mô tả cách áp dụng theo portal.

## Tài sản thương hiệu

- Logo chính thức trong Mobile: `myfschoolse1911/assets/images/logo_fpt.png`.
- Dùng `BoxFit.contain`, không bóp méo tỷ lệ và luôn có semantic label.
- Màn đăng nhập dùng kích thước lớn; app bar dùng biến thể compact.
- Không tự vẽ lại logo khi asset chính thức đã tồn tại.

## Nguồn token

- Orange: `#F37021`.
- Green: `#00A859`.
- Deep Blue: `#1A2B56`.
- Font: Inter.
- Base spacing: `8px`.

Không tạo thêm giá trị màu/radius/spacing cục bộ nếu semantic token hiện có đáp ứng được.

## Nguyên tắc chung

- Một màn hình có một primary action rõ.
- Có loading, empty, error, success, disabled và forbidden.
- Trạng thái không chỉ biểu đạt bằng màu; luôn có text/icon hỗ trợ.
- Nội dung tiếng Việt dùng sentence case và thống nhất glossary.
- Ngày giờ theo locale Việt Nam, timezone `Asia/Ho_Chi_Minh`.
- Tác vụ duyệt, publish, khóa, reset và hủy cần confirm phù hợp.

## Web Admin và Teacher

- Desktop-first cho Admin Portal; responsive tablet cho Teacher Workspace.
- Sidebar/menu được dựng từ permission, không hard-code theo một role duy nhất.
- Bảng dữ liệu có search/filter/pagination, sticky header khi phù hợp.
- Form nhập điểm và điểm danh tối ưu thao tác bàn phím, lưu rõ trạng thái.
- Import TKB có bước chọn file, validate, bảng lỗi dòng/cột và xác nhận publish.
- Badge workflow thống nhất: Draft, Submitted, Approved, Published, Rejected.

Component gợi ý:

- `AppShell`, `PermissionGate`, `DataTable`, `FilterBar`
- `FormField`, `ConfirmDialog`, `StatusBadge`, `ErrorState`
- `AcademicContextSelector`, `StudentTable`, `GradeEntryGrid`
- `AttendanceSheet`, `ImportResult`, `ApprovalPanel`

## Parent App

- Material 3, bottom navigation tối đa năm destination cấp cao.
- Dashboard ưu tiên lịch hôm nay và thông báo mới.
- `StudentSwitcher` luôn dễ thấy khi phụ huynh có nhiều con.
- Bảng điểm mobile dùng row/card mở rộng, không ép bảng desktop nhiều cột.
- Touch target tối thiểu `48x48`, hỗ trợ text scale và safe area.
- Push/deep link mở đúng học sinh và đúng nội dung sau khi kiểm tra quyền.

Component gợi ý:

- `AppScaffold`, `AppTopBar`, `StudentSwitcher`
- `PrimaryButton`, `AppTextField`, `StatusBadge`
- `LoadingSkeleton`, `EmptyState`, `ErrorState`
- `ScheduleCard`, `AttendanceTile`, `GradeRow`, `NotificationTile`

## Scale đề xuất

- Spacing: `4, 8, 12, 16, 24, 32`.
- Radius: `8, 12, 16`.
- Body text mobile thông thường không nhỏ hơn `14sp`.
- Không khóa chiều cao text nếu nội dung có thể dài hoặc scale.

Chỉ trích xuất component dùng chung khi có use case thực sự tương đồng; web và mobile không
cần ép dùng chung implementation, chỉ cần thống nhất token và ngôn ngữ trạng thái.

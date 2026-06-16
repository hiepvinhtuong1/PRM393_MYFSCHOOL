# F02-F04 - Học vụ, thời khóa biểu và điểm danh

**Trạng thái:** Đã xác nhận để triển khai MVP  
**Cập nhật:** 2026-06-15

## F02 - Cấu trúc học vụ và hồ sơ

- Admin quản lý cấp, khối, năm học, học kỳ, lớp, môn học, giáo viên, học sinh và phụ huynh.
- Một học sinh có thể liên kết nhiều phụ huynh; một tài khoản phụ huynh có thể liên kết nhiều học sinh.
- Mỗi học sinh chỉ có một enrollment `ACTIVE` trong một năm học.
- Một giáo viên có thể đồng thời là GVCN và GVBM.
- `FULL_YEAR` chỉ dùng tổng kết, không được dùng để tạo phân công giảng dạy.
- GVCN chỉ xem học sinh lớp chủ nhiệm; GVBM chỉ xem lớp/môn được phân công.

## F03 - Thời khóa biểu

- File Excel có các cột: `classCode`, `termCode`, `dayOfWeek`, `periodNumber`,
  `subjectCode`, `teacherCode`, `room`.
- Import theo nguyên tắc all-or-nothing. Một dòng lỗi làm toàn bộ file bị từ chối.
- Kiểm tra mã tham chiếu, tiết học, phân công, trùng lịch lớp và trùng lịch giáo viên.
- Import hợp lệ tạo/cập nhật TKB ở trạng thái `DRAFT`.
- Publish ghi đè lịch hiện hành của lớp/học kỳ, tạo teaching session và lưu người/thời gian publish.
- Khi publish lại, tạo thông báo “Thời khóa biểu lớp [X] đã được cập nhật”.
- Teacher chỉ xem lịch dạy của mình; Parent chỉ xem TKB đã publish của học sinh liên kết.

## F04 - Điểm danh

- GVBM chỉ được điểm danh teaching session thuộc phân công của mình.
- Trạng thái: `PRESENT`, `EXCUSED_ABSENCE`, `UNEXCUSED_ABSENCE`, `LATE`.
- Giáo viên được tạo/sửa điểm danh trong đúng ngày của tiết học.
- Sang ngày sau chỉ người có `attendance.correct_after_lock` được sửa và phải nhập lý do.
- Mỗi lần sửa lưu `attendance_change_logs`.
- Khi giáo viên lưu, phụ huynh liên kết nhận notification có ngày, giờ, tiết và trạng thái.
- Parent chỉ xem lịch sử điểm danh của học sinh được liên kết.

## Tiêu chí chấp nhận

1. Tài khoản không có permission nhận `403`.
2. Data scope sai lớp, sai giáo viên hoặc sai quan hệ phụ huynh-học sinh nhận `403`.
3. Import Excel sai không tạo/cập nhật bất kỳ timetable entry nào.
4. Không thể xếp trùng lớp hoặc trùng giáo viên trong cùng thứ/tiết.
5. Parent App chuyển được giữa hai hồ sơ học sinh demo.
6. Web Teacher hiển thị được lịch dạy, roster và lưu điểm danh hàng loạt.
7. Web/Mobile có loading, empty, error và success.
8. Admin tra cứu được tiết toàn trường, sửa dữ liệu sau khóa khi có permission và bắt buộc
   nhập lý do; thao tác được ghi log.

## Kết quả kiểm chứng ngày 2026-06-15

- Import Excel sai trả `REJECTED`, một lỗi theo dòng; `timetable_entries` giữ nguyên `10 -> 10`.
- Giáo viên sửa tiết ngày trước nhận `409`.
- Giáo viên khác sửa tiết không thuộc phân công nhận `403`.
- Admin sửa sau khóa thiếu lý do nhận `400`; có lý do nhận `200`.
- Parent demo có hai hồ sơ và đọc được lịch học, lịch sử điểm danh theo hồ sơ đang chọn.

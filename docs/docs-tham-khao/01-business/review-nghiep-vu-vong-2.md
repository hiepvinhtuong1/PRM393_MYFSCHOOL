# Review nghiệp vụ vòng 2

**Trạng thái:** Baseline sau phỏng vấn  
**Ngày:** 2026-06-15

## Kết quả

Phạm vi đã chuyển từ Parent App đơn lẻ thành hệ thống production cho một trường với ba portal:
Admin, Teacher và Parent. Các quy trình chính đã đủ rõ để phân rã thành epic/use case.

## Điểm đã làm rõ

- Web Admin và Teacher dùng chung React app, phân quyền bằng RBAC chi tiết.
- Chỉ phụ huynh dùng mobile; không có actor học sinh.
- Tài khoản dùng số điện thoại unique; phụ huynh-học sinh là quan hệ nhiều-nhiều.
- TKB import atomic và được publish xuống Teacher/Parent.
- Điểm danh theo tiết, khóa qua ngày, push ngay khi lưu.
- Sổ điểm có quy trình Draft -> Submitted -> Approved -> Published.
- Đơn nghỉ do GVCN duyệt; CLB đăng ký tức thời theo quota.
- CMS dùng chung model và target toàn trường/khối/lớp.

## Rủi ro còn lại

1. Ma trận permission giữa Super Admin, School Admin và BGH chưa chốt tới từng thao tác.
2. Công thức điểm/học lực/hạnh kiểm chưa đủ chi tiết để code.
3. Sửa điểm published không có audit mâu thuẫn với yêu cầu production và đã bị bác bỏ về
   mặt kiến trúc.
4. Peak `100-200 request/giây` cần xác minh bằng workload cụ thể và load test.
5. OTP bị hoãn cần luồng hỗ trợ reset mật khẩu thay thế.
6. Không yêu cầu chức năng backup không có nghĩa production được phép không backup dữ liệu.

## Bước phân tích kế tiếp

Chốt permission matrix và Gradebook trước, vì hai phần này ảnh hưởng schema, API, UI và bảo mật
lớn nhất.


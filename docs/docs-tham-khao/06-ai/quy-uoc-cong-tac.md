# Quy ước cộng tác BA, SA, Developer và AI

## Cách giao một nhiệm vụ tốt

Mỗi yêu cầu nên có:

1. **Mục tiêu:** cần đạt kết quả gì.
2. **Bối cảnh:** actor, module, file/tài liệu liên quan.
3. **Ràng buộc:** business rule, kiến trúc, deadline, phần không được đổi.
4. **Hoàn tất khi:** tiêu chí kiểm thử hoặc nghiệm thu cụ thể.

Ví dụ:

```text
Mục tiêu: Đặc tả luồng phụ huynh xem điểm của một học sinh.
Bối cảnh: docs/01-business, SCR-06, phụ huynh có thể có nhiều con.
Ràng buộc: Không tự đặt công thức điểm; backend kiểm tra quyền studentId.
Hoàn tất khi: Có use case, ngoại lệ, API draft, Given/When/Then và câu hỏi mở.
```

## Nhãn độ tin cậy

- `Đã xác nhận`: có quyết định stakeholder, source hoặc test đáng tin cậy.
- `Giả định`: tạm dùng để tiếp tục phân tích, cần xác nhận.
- `Đề xuất`: phương án của BA/SA/AI và lý do.
- `Câu hỏi mở`: thiếu thông tin có thể làm thay đổi thiết kế.

## Quy trình review nghiệp vụ

1. Chọn một module, không review toàn hệ thống cùng lúc.
2. Chốt actor và mục tiêu.
3. Viết happy path và các ngoại lệ.
4. Chốt dữ liệu, quyền, trạng thái và audit.
5. Viết tiêu chí chấp nhận.
6. SA đối chiếu API/data/security.
7. Chủ dự án xác nhận; sau đó mới chuyển trạng thái tài liệu thành `Accepted`.

## Quy tắc cho AI

- Đọc tài liệu theo chỉ mục, không nạp toàn bộ repo thiếu mục tiêu.
- Dẫn chiếu file sở hữu rule thay vì sao chép.
- Không bịa dependency, endpoint, role, schema hoặc công thức.
- Khi code và tài liệu lệch nhau, báo rõ và đề xuất nguồn cần sửa.
- Sau triển khai phải chạy kiểm tra, review diff và cập nhật tài liệu.

## Chọn project skill

- Dùng `$analyze-myfptschool-requirement` khi đầu vào còn là ý tưởng, câu trả lời phỏng vấn
  hoặc thay đổi business rule.
- Dùng `$implement-myfptschool-feature` khi acceptance criteria đủ rõ và người dùng mong đợi
  code hoàn chỉnh.
- Dùng `$review-myfptschool-change` khi nhiệm vụ chính là tìm lỗi/rủi ro trong thay đổi đã có.
- Với nhiệm vụ vừa mơ hồ vừa yêu cầu code, phân tích trước rồi mới triển khai.
- Không gọi cả ba skill theo thói quen; chọn workflow nhỏ nhất bao phủ mục tiêu.

## Nhịp làm việc đề xuất tiếp theo

Review chi tiết lần lượt:

1. Ma trận permission của Super Admin, School Admin và Ban Giám Hiệu.
2. Cấu hình công thức điểm, học lực, hạnh kiểm và làm tròn.
3. Template Excel và quy trình publish thời khóa biểu.
4. Điểm danh, sửa sau khóa và push notification.
5. Đơn nghỉ học và đồng bộ Vắng phép.
6. CMS target theo trường/khối/lớp.
7. Điều kiện hủy đăng ký câu lạc bộ.

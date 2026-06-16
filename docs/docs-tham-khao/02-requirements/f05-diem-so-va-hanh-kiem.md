# F05 - Điểm số và hạnh kiểm

**Trạng thái:** Đã triển khai baseline MVP  
**Cập nhật:** 2026-06-15

## Phạm vi

- School Admin cấu hình hệ số, số chữ số làm tròn và các khoảng xếp loại theo năm học/khối.
- GVBM nhập điểm cho đúng lớp, môn và học kỳ được phân công.
- GVCN nhập hạnh kiểm cho học sinh lớp chủ nhiệm.
- Ban Giám Hiệu duyệt, từ chối và công bố đồng bộ theo lớp/học kỳ.
- Parent App chỉ đọc snapshot đã công bố.

## Quy tắc điểm

- `REGULAR` hệ số 1, `MIDTERM` hệ số 2, `FINAL` hệ số 3 theo cấu hình mặc định.
- Điểm môn số nằm trong `[0, 10]`; trung bình môn là trung bình có trọng số.
- Mức làm tròn mặc định là một chữ số thập phân và có thể cấu hình từ 0 đến 2.
- Môn `PASS_FAIL` chỉ nhận `PASS` hoặc `FAIL`, không nhận điểm số.
- Kết quả môn định tính là `PASS` khi tất cả cột đánh giá đều `PASS`.
- Trung bình học kỳ là trung bình cộng các môn số đã công bố; môn định tính không tham gia.
- Các khoảng xếp loại không được chồng lấn.

## Workflow

```text
DRAFT -> SUBMITTED -> APPROVED -> PUBLISHED
                   \-> DRAFT khi bị từ chối
```

- Chỉ sổ `DRAFT` được sửa.
- Giáo viên phải nhập đủ mọi học sinh và cột đánh giá trước khi nộp.
- BGH từ chối phải nhập lý do; sổ trở về `DRAFT`.
- Công bố được thực hiện theo `classId + termId`.
- Chỉ công bố khi tất cả sổ điểm và toàn bộ hạnh kiểm của lớp đều `APPROVED`.
- Publish tạo `published_subject_results`, `student_term_summaries` và notification.

## Data scope

- GVBM: chỉ teaching assignment gắn với tài khoản giáo viên.
- GVCN: chỉ homeroom assignment đúng năm học và lớp.
- BGH: review toàn trường khi có permission.
- Phụ huynh: chỉ học sinh có liên kết active.

## Tiêu chí chấp nhận

1. Giáo viên không được phân công nhận `403`.
2. Sổ thiếu điểm không chuyển được sang `SUBMITTED`.
3. Môn số và môn Đạt/Không đạt không thể trộn kiểu dữ liệu.
4. Từ chối đưa sổ/hạnh kiểm về `DRAFT` và lưu lý do workflow.
5. Không công bố nếu còn ít nhất một sổ hoặc hạnh kiểm chưa duyệt.
6. Parent không đọc được dữ liệu trước publish.
7. Parent App hiển thị trung bình môn, trung bình học kỳ, học lực và hạnh kiểm.

## Kết quả kiểm chứng local

- Migration `V004` chạy thành công trên SQL Server.
- Bốn sổ điểm demo đã đi qua `DRAFT -> SUBMITTED -> APPROVED -> PUBLISHED`.
- Hạnh kiểm lớp `7A1` đã đi qua cùng workflow.
- Snapshot Parent gồm bốn môn; trung bình học kỳ `8.5`, học lực `EXCELLENT`, hạnh kiểm `GOOD`.
- Publish lặp khi không có sổ mới được duyệt nhận `409`.
- Phụ huynh truy cập học sinh ngoài liên kết nhận `403`.

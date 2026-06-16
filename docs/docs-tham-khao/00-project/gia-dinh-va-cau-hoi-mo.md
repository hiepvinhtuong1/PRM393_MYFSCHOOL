# Giả định, quyết định và câu hỏi mở

**Trạng thái:** Baseline  
**Cập nhật:** 2026-06-15

## Đã xác nhận

| ID | Quyết định |
|---|---|
| D-01 | Hệ thống phục vụ một trường và có đủ ba portal trong bản production đầu tiên |
| D-02 | Admin và Teacher dùng chung một React web app, giao diện/quyền theo role |
| D-03 | Parent App dùng Flutter; backend dùng Spring Boot |
| D-04 | Mọi người dùng đăng nhập bằng số điện thoại; một số điện thoại thuộc tối đa một tài khoản |
| D-05 | Một học sinh có thể liên kết nhiều phụ huynh; một phụ huynh có thể liên kết nhiều học sinh |
| D-06 | Một giáo viên có thể đồng thời có role GVCN và GVBM |
| D-07 | Không có role Giáo vụ riêng; Ban Giám Hiệu đảm nhận phê duyệt học vụ |
| D-08 | Một năm học có Học kỳ 1, Học kỳ 2 và tổng kết Cả năm |
| D-09 | Không hỗ trợ chuyển lớp giữa năm |
| D-10 | Import thời khóa biểu là atomic: một dòng lỗi thì rollback toàn bộ file |
| D-11 | Ghi đè thời khóa biểu không lưu version ở MVP và phải gửi push cho lớp bị ảnh hưởng |
| D-12 | Điểm danh được push ngay khi GVBM lưu; ghi chú hiển thị cho phụ huynh |
| D-13 | Đơn nghỉ đã duyệt làm căn cứ tự động xác định Vắng phép |
| D-14 | Điểm số có hệ số 1/2/3; một số môn đánh giá Đạt/Không đạt |
| D-15 | Công thức điểm, học lực và xếp loại do Admin cấu hình |
| D-16 | Đơn nghỉ do GVCN lớp duyệt; từ chối bắt buộc có lý do |
| D-17 | Mỗi học sinh được đăng ký tối đa ba CLB; đủ slot thì xác nhận ngay |
| D-18 | CMS dùng chung model nội dung và phân biệt bằng type |

## Giả định kỹ thuật còn dùng

| ID | Giả định | Mức ảnh hưởng |
|---|---|---|
| A-01 | Xác thực dùng access token ngắn hạn và refresh token có thu hồi | Cao |
| A-02 | SQL Server là database production chính thức | Cao |
| A-03 | Push notification dùng một provider hỗ trợ iOS/Android | Trung bình |
| A-04 | Web app sẽ được chuyển sang TypeScript trước khi phát triển nghiệp vụ lớn | Trung bình |

## Câu hỏi mở cần chốt

| ID | Câu hỏi | Đề xuất hiện tại |
|---|---|---|
| Q-01 | `SUPER_ADMIN` khác `SCHOOL_ADMIN` ở quyền nào trong hệ thống một trường? | Super Admin quản lý cấu hình hệ thống và toàn bộ tài khoản; School Admin vận hành hằng ngày |
| Q-02 | Ban Giám Hiệu có được tạo/sửa dữ liệu hay chỉ xem, duyệt, công bố? | Chỉ xem, duyệt, công bố |
| Q-03 | School Admin hay Ban Giám Hiệu duyệt bảng điểm? | Ban Giám Hiệu duyệt; School Admin hỗ trợ cấu hình |
| Q-04 | Admin nào xử lý yêu cầu sửa điểm danh sau ngày khóa? | School Admin hoặc Ban Giám Hiệu theo permission |
| Q-05 | Phụ huynh được hủy đăng ký CLB tới thời điểm nào? | Chỉ trước ngày khai giảng và khi CLB còn mở đăng ký |
| Q-06 | Admin sửa điểm đã công bố theo quy trình nào? | Bắt buộc nhập lý do và lưu lịch sử thay đổi |
| Q-07 | Mật khẩu mặc định được cấp/truyền cho người dùng bằng kênh nào? | Cần quy trình an toàn, không gửi plaintext qua kênh công khai |
| Q-08 | OTP bị hoãn thì người dùng quên mật khẩu được hỗ trợ thế nào? | School Admin reset và cấp mật khẩu tạm |
| Q-09 | Mẫu Excel TKB chính thức gồm những cột và mã tham chiếu nào? | Chốt template trước khi thiết kế importer |
| Q-10 | Chi tiết công thức tính điểm, làm tròn, học lực và hạnh kiểm? | Đã chốt baseline trong `f05-diem-so-va-hanh-kiem.md`; trường có thể đổi hệ số/làm tròn/khoảng xếp loại |
| Q-11 | Mốc đo 100-200 là request/giây hay số người dùng đồng thời? | Cần load profile chính xác để đặt SLO |
| Q-12 | Môi trường dev/test/staging/prod, CI/CD và database test? | Testcontainers SQL Server là baseline đề xuất |
| Q-13 | SQL Server có được xác nhận là database production cuối cùng không? | Hiện mới suy ra từ dependency; xác nhận trước migration đầu tiên |
| Q-14 | Có cần workflow riêng cho yêu cầu sửa điểm danh sau khóa? | Baseline có bảng `attendance_correction_requests` |
| Q-15 | `gender` và quan hệ phụ huynh-học sinh dùng danh mục nào? | Chốt code list trước migration people |

## Quyết định an toàn bắt buộc

Yêu cầu “Admin sửa điểm đã công bố mà bỏ qua log” không được chấp nhận cho production.
Điểm, điểm danh, phân quyền và trạng thái đơn là dữ liệu nhạy cảm; mọi chỉnh sửa sau công bố
phải lưu người sửa, thời gian, giá trị trước/sau và lý do. Audit này không nhất thiết phải có
màn hình quản trị phức tạp trong MVP nhưng dữ liệu phải được ghi nhận.

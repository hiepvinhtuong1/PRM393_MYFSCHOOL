# MyFPTSchools Clone - Screen Map & Feature Specification

Ngày nghiên cứu: 03/06/2026

**Stitch Project ID:** `1252816810292818941` (Chứa 12 màn hình MVP Phase 1)

## 1. Nguồn tham khảo và phạm vi

### Nguồn đã kiểm tra

- Google Play: `https://play.google.com/store/apps/details?id=com.myfptschool&hl=vi`
- AppBrain: `https://www.appbrain.com/app/myfptschools/com.myfptschool`
- APKPure: `https://apkpure.com/myfptschools/com.myfptschool`
- Uptodown: `https://myfptschools.en.uptodown.com/android`

### Thông tin xác minh được từ store

Theo Google Play, MyFPTSchools là ứng dụng của FPT Education, nhóm Giáo dục, có hơn 10.000 lượt tải xuống và cập nhật gần nhất ngày 13/04/2026. Mô tả chính thức liệt kê các nhóm tính năng:

- Thông tin chi tiết về lịch sử điểm danh của học sinh.
- Thời khóa biểu hằng ngày.
- Điểm số học sinh có được trên lớp.
- Tin tức các hoạt động tại trường.
- Thông tin hoạt động ngoại khóa.
- Thông tin khen thưởng, kỷ luật.
- Thông tin câu lạc bộ.
- Thông tin ký túc xá.

### Phạm vi clone đề xuất

Tài liệu này không chỉ chép lại danh sách tính năng từ store, mà mở rộng thành một bản đặc tả màn hình để có thể dùng cho Figma, backlog Trello/Jira và triển khai Flutter. Các màn hình phụ như chi tiết điểm, chi tiết buổi học, bộ lọc học kỳ, empty/loading/error state là phần đề xuất để bản clone vận hành hoàn chỉnh.

## 2. Vai trò người dùng

### Học sinh

- Xem lịch học, điểm danh, điểm số, tin tức, câu lạc bộ, ngoại khóa, ký túc xá.
- Đăng ký hoạt động ngoại khóa hoặc câu lạc bộ nếu hệ thống cho phép.
- Xem lịch sử khen thưởng/kỷ luật của chính mình.
- Quản lý thông tin cá nhân, ngôn ngữ, thông báo và đăng xuất.

### Phụ huynh

- Xem thông tin học tập, sinh hoạt và cảnh báo của con.
- Chuyển giữa nhiều học sinh nếu phụ huynh có nhiều con trong hệ thống.
- Nhận thông báo liên quan tới điểm danh, điểm số, kỷ luật, sự kiện và ký túc xá.
- Không nên có quyền sửa dữ liệu học thuật, chỉ xem và xác nhận/thao tác ở một số luồng nếu backend hỗ trợ.

## 3. Kiến trúc điều hướng tổng thể

### Luồng khởi động

```text
Splash
  -> Kiểm tra phiên đăng nhập
    -> Chưa đăng nhập: Login
    -> Đã đăng nhập: Main Shell
```

### Main Shell

Đề xuất dùng bottom navigation với 4 tab chính:

```text
Home | Timetable | Notifications | Profile
```

Mỗi tab giữ stack riêng để khi người dùng quay lại tab cũ vẫn giữ ngữ cảnh đang xem.

### Điều hướng dạng stack từ Home

```text
Home
  -> Attendance
  -> Grades
      -> Grade Detail
  -> News
      -> News Detail
  -> Extracurricular
      -> Activity Detail
      -> Registration Result
  -> Clubs
      -> Club Detail
      -> Club Registration Result
  -> Discipline & Rewards
      -> Decision Detail
  -> Dormitory
      -> Room Detail
      -> Utility Bill Detail
```

### Điều hướng từ Timetable

```text
Timetable
  -> Class Session Detail
      -> Learning Materials
      -> Attendance Status
```

### Điều hướng từ Notifications

```text
Notifications
  -> Notification Detail
      -> Related Screen
```

Ví dụ: thông báo điểm mới mở `Grade Detail`, thông báo vắng học mở `Attendance`, thông báo sự kiện mở `News Detail` hoặc `Activity Detail`.

## 4. Danh sách màn hình chi tiết

## 4.1. Splash Screen

### Mục tiêu

Khởi tạo ứng dụng, tải cấu hình ban đầu và quyết định điều hướng vào Login hoặc Main Shell.

### Thành phần UI

- Logo MyFPTSchools hoặc FPT Education.
- Nền nhận diện thương hiệu.
- Loading indicator nhỏ.
- Text phiên bản app nếu cần.

### Tính năng

- Kiểm tra access token/refresh token.
- Tải remote config, ngôn ngữ, thông tin phiên bản tối thiểu.
- Kiểm tra kết nối mạng.
- Nếu có session hợp lệ, gọi API lấy profile ngắn gọn.

### Trạng thái cần có

- Loading.
- Mất mạng: hiển thị retry.
- Phiên hết hạn: chuyển Login.
- Cần cập nhật app: hiển thị dialog bắt buộc hoặc khuyến nghị cập nhật.

### Điều hướng

- `Splash -> Login` nếu chưa đăng nhập hoặc token hết hạn.
- `Splash -> Main Shell/Home` nếu đăng nhập hợp lệ.

## 4.2. Login Screen

### Mục tiêu

Cho học sinh/phụ huynh đăng nhập vào cổng thông tin.

### Thành phần UI

- Logo và tên ứng dụng.
- Trường tài khoản/email.
- Trường mật khẩu.
- Nút hiện/ẩn mật khẩu.
- Nút đăng nhập.
- Link quên mật khẩu.
- Chọn ngôn ngữ nếu app hỗ trợ song ngữ.

### Tính năng

- Đăng nhập bằng email nội bộ hoặc tài khoản được cấp.
- Validate rỗng, sai định dạng email, mật khẩu quá ngắn.
- Lưu token an toàn sau khi đăng nhập thành công.
- Hiển thị lỗi sai tài khoản/mật khẩu.
- Chặn spam bằng loading state trong lúc gọi API.

### Trạng thái cần có

- Default.
- Input error.
- Loading.
- Login failed.
- Account locked/inactive.

### Điều hướng

- `Login -> Main Shell/Home` khi đăng nhập thành công.
- `Login -> Forgot Password` khi bấm quên mật khẩu.

## 4.3. Forgot Password Screen

### Mục tiêu

Hỗ trợ khôi phục mật khẩu hoặc gửi hướng dẫn đặt lại mật khẩu.

### Thành phần UI

- Trường email/tài khoản.
- Nút gửi yêu cầu.
- Mô tả ngắn về việc kiểm tra email hoặc liên hệ nhà trường.

### Tính năng

- Validate email/tài khoản.
- Gửi yêu cầu reset password.
- Hiển thị thông báo thành công dù tài khoản có tồn tại hay không để tránh lộ thông tin.

### Điều hướng

- `Forgot Password -> Login` sau khi gửi thành công hoặc bấm quay lại.

## 4.4. Home / Dashboard

### Mục tiêu

Là màn hình tổng quan, gom các thông tin quan trọng nhất trong ngày và lối tắt vào chức năng nghiệp vụ.

### Thành phần UI

- Header có lời chào, avatar, tên học sinh, lớp, mã học sinh.
- Nếu là phụ huynh: dropdown/chip chọn học sinh.
- Card lịch học tiếp theo.
- Card cảnh báo nhanh: vắng học, điểm mới, thông báo chưa đọc.
- Banner hoặc carousel tin nổi bật.
- Grid menu chức năng.

### Grid menu đề xuất

- Điểm danh.
- Thời khóa biểu.
- Điểm số.
- Tin tức.
- Ngoại khóa.
- Câu lạc bộ.
- Khen thưởng/kỷ luật.
- Ký túc xá.

### Tính năng

- Tải dashboard summary theo học kỳ hiện tại.
- Hiển thị buổi học tiếp theo trong ngày.
- Hiển thị số thông báo chưa đọc.
- Hiển thị cảnh báo học tập/sinh hoạt ưu tiên cao.
- Cho phép pull-to-refresh.
- Với phụ huynh, đổi học sinh sẽ reload toàn bộ dữ liệu dashboard.

### Trạng thái cần có

- Loading skeleton.
- Empty state khi chưa có lịch/tin/cảnh báo.
- Error state có nút thử lại.
- Offline state dùng cache gần nhất nếu có.

### Điều hướng

- Card lịch học -> `Class Session Detail`.
- Card điểm mới -> `Grade Detail` hoặc `Grades`.
- Card vắng học -> `Attendance`.
- Banner tin tức -> `News Detail`.
- Icon menu -> màn hình tương ứng.

## 4.5. Timetable

### Mục tiêu

Hiển thị thời khóa biểu hằng ngày và hỗ trợ xem theo tuần.

### Thành phần UI

- App bar: tiêu đề "Thời khóa biểu".
- Bộ chọn ngày/tuần.
- Toggle Ngày/Tuần.
- Danh sách slot học trong ngày.
- Với view tuần: cột theo ngày, hàng theo slot hoặc danh sách nhóm theo ngày.

### Dữ liệu mỗi slot

- Môn học.
- Mã môn/lớp học phần nếu có.
- Giáo viên.
- Phòng học.
- Slot/tiết học.
- Thời gian bắt đầu/kết thúc.
- Trạng thái: sắp học, đang học, đã học, nghỉ, đổi phòng, học online.
- Tình trạng điểm danh của học sinh: có mặt, vắng, muộn, chưa ghi nhận.

### Tính năng

- Chọn ngày bất kỳ.
- Chuyển tuần trước/sau.
- Lọc theo buổi sáng/chiều/tối nếu trường có nhiều ca.
- Làm nổi bật slot hiện tại.
- Pull-to-refresh.
- Cache lịch gần nhất.

### Trạng thái cần có

- Không có lịch ngày đó.
- Lỗi tải dữ liệu.
- Lịch bị thay đổi: hiển thị nhãn "Đã cập nhật".

### Điều hướng

- Tap slot học -> `Class Session Detail`.
- Tap thông báo thay đổi lịch -> `Notification Detail` nếu có.

## 4.6. Class Session Detail

### Mục tiêu

Cho người dùng xem chi tiết một buổi học cụ thể.

### Thành phần UI

- Thông tin môn học, giáo viên, phòng, thời gian.
- Trạng thái điểm danh.
- Ghi chú buổi học.
- Danh sách tài liệu/bài giảng nếu có.
- Link học online nếu có.

### Tính năng

- Xem tài liệu đính kèm.
- Mở link học online.
- Xem trạng thái điểm danh của slot.
- Xem thay đổi phòng/giáo viên nếu có.

### Điều hướng

- Back -> `Timetable`.
- Tài liệu -> mở viewer hoặc trình duyệt ngoài tùy loại file.

## 4.7. Attendance

### Mục tiêu

Theo dõi lịch sử điểm danh và cảnh báo nguy cơ vắng vượt ngưỡng.

### Thành phần UI

- Bộ lọc học kỳ.
- Summary card: tổng buổi, có mặt, vắng, muộn.
- Biểu đồ tiến độ hoặc thanh phần trăm vắng.
- Danh sách môn học.
- Mỗi môn hiển thị số buổi vắng/tổng buổi và trạng thái cảnh báo.

### Tính năng

- Lọc theo học kỳ.
- Lọc theo môn.
- Xem chi tiết từng lần điểm danh.
- Tính phần trăm vắng theo môn.
- Cảnh báo khi tỷ lệ vắng tiệm cận ngưỡng quy định.

### Trạng thái cảnh báo đề xuất

- An toàn: dưới 50% ngưỡng.
- Cần chú ý: từ 50% đến dưới 80% ngưỡng.
- Nguy hiểm: từ 80% ngưỡng trở lên.
- Vượt ngưỡng: đủ điều kiện cảnh báo cấm thi nếu quy chế áp dụng.

### Điều hướng

- Tap môn học -> `Attendance Subject Detail`.
- Back -> màn hình trước đó, thường là `Home`.

## 4.8. Attendance Subject Detail

### Mục tiêu

Xem từng buổi điểm danh của một môn.

### Thành phần UI

- Header môn học.
- Tổng quan số buổi.
- Danh sách buổi học theo ngày.
- Badge trạng thái: có mặt, vắng, muộn, có phép, chưa ghi nhận.

### Tính năng

- Sắp xếp mới nhất/cũ nhất.
- Lọc theo trạng thái.
- Xem lý do vắng hoặc ghi chú nếu hệ thống có dữ liệu.

### Điều hướng

- Tap buổi học -> `Class Session Detail`.

## 4.9. Grades

### Mục tiêu

Hiển thị kết quả học tập theo học kỳ.

### Thành phần UI

- Bộ lọc học kỳ/năm học.
- Summary card: GPA/điểm trung bình, số môn pass/fail nếu có.
- Danh sách môn học.
- Mỗi môn có điểm tổng kết, trạng thái, số tín chỉ hoặc hệ số nếu có.

### Tính năng

- Chọn học kỳ.
- Tìm kiếm môn học.
- Lọc trạng thái Pass/Fail/In Progress.
- Hiển thị điểm mới cập nhật.
- Pull-to-refresh.

### Trạng thái cần có

- Chưa có điểm.
- Đang cập nhật điểm.
- Có điểm nhưng chưa tổng kết.
- Fail hoặc cần cải thiện được highlight rõ.

### Điều hướng

- Tap môn học -> `Grade Detail`.

## 4.10. Grade Detail

### Mục tiêu

Bóc tách các đầu điểm của một môn.

### Thành phần UI

- Header môn học, giáo viên, lớp.
- Điểm tổng kết và trạng thái.
- Bảng breakdown các cột điểm.
- Ghi chú quy đổi điểm nếu có.

### Dữ liệu từng cột điểm

- Tên đầu điểm: quiz, assignment, lab, giữa kỳ, cuối kỳ, participation.
- Trọng số.
- Điểm đạt được.
- Ngày cập nhật.
- Ghi chú hoặc trạng thái vắng thi/chưa chấm nếu có.

### Tính năng

- Tính điểm dự kiến nếu điểm chưa chốt.
- Hiển thị cột chưa có điểm.
- Mở thông báo liên quan tới điểm nếu đi từ Notification.

### Điều hướng

- Back -> `Grades`.

## 4.11. News

### Mục tiêu

Hiển thị tin tức, thông báo chung và hoạt động tại trường.

### Thành phần UI

- Danh sách hoặc feed tin.
- Search bar.
- Bộ lọc danh mục.
- Card tin gồm ảnh, tiêu đề, mô tả ngắn, ngày đăng, danh mục.

### Danh mục đề xuất

- Thông báo chung.
- Hoạt động trường.
- Học thuật.
- Sự kiện.
- Tuyển sinh/nội bộ.

### Tính năng

- Xem danh sách tin mới nhất.
- Tìm kiếm.
- Lọc theo danh mục.
- Đánh dấu đã đọc.
- Lưu tin nếu cần.

### Điều hướng

- Tap tin -> `News Detail`.

## 4.12. News Detail

### Mục tiêu

Cho người dùng đọc nội dung tin đầy đủ.

### Thành phần UI

- Tiêu đề.
- Ảnh cover.
- Ngày đăng, tác giả/phòng ban.
- Nội dung HTML/Markdown.
- File đính kèm nếu có.

### Tính năng

- Render nội dung rich text.
- Mở file đính kèm.
- Chia sẻ link nếu backend hỗ trợ.
- Đánh dấu đã đọc tự động.

### Điều hướng

- Back -> `News` hoặc nguồn trước đó.
- Link trong bài -> webview/trình duyệt.

## 4.13. Extracurricular Activities

### Mục tiêu

Quản lý thông tin hoạt động ngoại khóa và đăng ký tham gia.

### Thành phần UI

- Danh sách hoạt động.
- Bộ lọc trạng thái: đang mở đăng ký, đã đăng ký, đã kết thúc.
- Card hoạt động: ảnh, tên, thời gian, địa điểm, hạn đăng ký, điểm rèn luyện dự kiến.

### Tính năng

- Xem hoạt động đang mở.
- Đăng ký/hủy đăng ký nếu còn hạn.
- Xem lịch sử tham gia.
- Hiển thị trạng thái duyệt: chờ duyệt, đã duyệt, bị từ chối.

### Điều hướng

- Tap hoạt động -> `Activity Detail`.
- Đăng ký thành công -> `Registration Result` hoặc snackbar xác nhận.

## 4.14. Activity Detail

### Mục tiêu

Xem chi tiết một hoạt động ngoại khóa.

### Thành phần UI

- Ảnh cover.
- Tên hoạt động.
- Thời gian, địa điểm.
- Đơn vị tổ chức.
- Số lượng còn lại.
- Điểm rèn luyện.
- Mô tả.
- Nút đăng ký/hủy đăng ký.

### Tính năng

- Kiểm tra điều kiện đăng ký.
- Xác nhận trước khi đăng ký/hủy.
- Hiển thị trạng thái đăng ký hiện tại.

### Điều hướng

- Back -> `Extracurricular Activities`.
- Đăng ký -> dialog xác nhận -> kết quả.

## 4.15. Clubs

### Mục tiêu

Hiển thị danh sách câu lạc bộ và hoạt động liên quan.

### Thành phần UI

- Danh sách câu lạc bộ.
- Search/filter theo lĩnh vực.
- Card câu lạc bộ: logo, tên, mô tả ngắn, số thành viên, trạng thái tuyển thành viên.

### Tính năng

- Xem câu lạc bộ.
- Đăng ký tham gia nếu đang tuyển.
- Xem sự kiện do câu lạc bộ tổ chức.
- Xem trạng thái thành viên nếu đã tham gia.

### Điều hướng

- Tap câu lạc bộ -> `Club Detail`.

## 4.16. Club Detail

### Mục tiêu

Xem thông tin chi tiết câu lạc bộ.

### Thành phần UI

- Logo/cover.
- Tên, mô tả, lĩnh vực.
- Ban chủ nhiệm/liên hệ.
- Lịch sinh hoạt.
- Sự kiện gần đây.
- Nút đăng ký tham gia.

### Tính năng

- Đăng ký tham gia.
- Xem điều kiện tham gia.
- Xem danh sách sự kiện liên quan.

### Điều hướng

- Đăng ký -> `Club Registration Result`.
- Tap sự kiện -> `Activity Detail`.

## 4.17. Discipline & Rewards

### Mục tiêu

Hiển thị lịch sử khen thưởng và kỷ luật.

### Thành phần UI

- Bộ lọc học kỳ/năm học.
- Tab: Khen thưởng | Kỷ luật | Tất cả.
- Danh sách quyết định.
- Badge mức độ hoặc loại quyết định.

### Tính năng

- Xem danh sách quyết định.
- Lọc theo loại.
- Lọc theo thời gian.
- Xem file quyết định hoặc ghi chú nếu có.

### Điều hướng

- Tap quyết định -> `Decision Detail`.

## 4.18. Decision Detail

### Mục tiêu

Xem chi tiết một quyết định khen thưởng/kỷ luật.

### Thành phần UI

- Loại quyết định.
- Ngày ban hành.
- Đơn vị ban hành.
- Nội dung.
- Mức khen thưởng/kỷ luật.
- File đính kèm nếu có.

### Tính năng

- Mở file quyết định.
- Hiển thị liên hệ/phòng ban xử lý nếu cần.

### Điều hướng

- Back -> `Discipline & Rewards`.

## 4.19. Dormitory

### Mục tiêu

Quản lý thông tin ký túc xá của học sinh.

### Thành phần UI

- Thông tin tòa nhà, phòng, giường.
- Danh sách bạn cùng phòng.
- Trạng thái hợp đồng/lưu trú nếu có.
- Danh sách hóa đơn điện nước/dịch vụ.
- Thông báo nội trú.

### Tính năng

- Xem thông tin phòng.
- Xem bạn cùng phòng.
- Xem hóa đơn và trạng thái thanh toán.
- Xem nội quy hoặc thông báo ký túc xá.
- Báo sự cố nếu backend hỗ trợ.

### Trạng thái cần có

- Học sinh không ở ký túc xá.
- Chưa có hóa đơn.
- Hóa đơn quá hạn.

### Điều hướng

- Tap phòng -> `Room Detail`.
- Tap hóa đơn -> `Utility Bill Detail`.
- Tap thông báo -> `News Detail` hoặc `Notification Detail`.

## 4.20. Room Detail

### Mục tiêu

Xem chi tiết phòng ký túc xá.

### Thành phần UI

- Tòa nhà, tầng, phòng.
- Số giường, giường của học sinh.
- Danh sách bạn cùng phòng.
- Người quản lý/phụ trách.
- Nội quy phòng.

### Tính năng

- Gọi/email người phụ trách nếu có thông tin.
- Xem lịch sử đổi phòng nếu backend có dữ liệu.

## 4.21. Utility Bill Detail

### Mục tiêu

Xem chi tiết hóa đơn ký túc xá.

### Thành phần UI

- Kỳ hóa đơn.
- Các khoản phí.
- Tổng tiền.
- Hạn thanh toán.
- Trạng thái thanh toán.
- Mã tham chiếu nếu có.

### Tính năng

- Xem breakdown điện/nước/dịch vụ.
- Tải biên lai nếu đã thanh toán.
- Điều hướng thanh toán nếu tích hợp payment.

## 4.22. Notifications

### Mục tiêu

Tập trung tất cả thông báo từ trường và hệ thống.

### Thành phần UI

- Tab hoặc filter: Tất cả, Học tập, Điểm danh, Điểm số, Hoạt động, KTX.
- Danh sách thông báo.
- Badge chưa đọc.
- Nút đánh dấu tất cả đã đọc.

### Tính năng

- Nhận push notification.
- Đồng bộ trạng thái đọc/chưa đọc.
- Lọc theo loại.
- Pull-to-refresh.
- Deep link tới màn hình liên quan.

### Điều hướng

- Tap notification -> `Notification Detail` hoặc mở trực tiếp màn hình liên quan nếu thông báo đơn giản.

## 4.23. Notification Detail

### Mục tiêu

Xem nội dung đầy đủ của một thông báo.

### Thành phần UI

- Tiêu đề.
- Loại thông báo.
- Ngày giờ.
- Nội dung.
- CTA mở màn hình liên quan.

### Tính năng

- Đánh dấu đã đọc.
- Mở màn hình liên quan.
- Xóa thông báo nếu backend hỗ trợ.

### Điều hướng

- CTA -> màn hình nghiệp vụ tương ứng.
- Back -> `Notifications`.

## 4.24. Profile

### Mục tiêu

Hiển thị hồ sơ người dùng và các thiết lập cá nhân.

### Thành phần UI

- Avatar.
- Họ tên.
- Vai trò: học sinh/phụ huynh.
- Mã học sinh hoặc mã phụ huynh.
- Lớp, khối, cơ sở.
- Danh sách mục cài đặt.

### Tính năng

- Xem thông tin hồ sơ.
- Chuyển học sinh nếu là phụ huynh.
- Cấu hình thông báo.
- Đổi ngôn ngữ.
- Đổi mật khẩu.
- Xem điều khoản/chính sách.
- Đăng xuất.

### Điều hướng

- Tap thông tin cá nhân -> `Profile Detail`.
- Tap thông báo -> `Notification Settings`.
- Tap ngôn ngữ -> `Language Settings`.
- Tap đổi mật khẩu -> `Change Password`.
- Đăng xuất -> `Login`.

## 4.25. Profile Detail

### Mục tiêu

Xem chi tiết thông tin học sinh/người dùng.

### Thành phần UI

- Thông tin định danh.
- Thông tin học tập: lớp, khối, chương trình, cơ sở.
- Thông tin liên hệ nếu có.
- Thông tin phụ huynh/người giám hộ nếu tài khoản học sinh được phép xem.

### Tính năng

- Chỉ đọc ở giai đoạn clone cơ bản.
- Hiển thị trạng thái dữ liệu thiếu.

## 4.26. Notification Settings

### Mục tiêu

Cho phép người dùng kiểm soát loại thông báo muốn nhận.

### Thành phần UI

- Toggle push notification tổng.
- Toggle theo nhóm: điểm danh, điểm số, lịch học, hoạt động, KTX, tin tức.
- Trạng thái quyền notification của hệ điều hành.

### Tính năng

- Xin quyền push notification.
- Bật/tắt từng nhóm thông báo.
- Đồng bộ setting lên backend.

## 4.27. Language Settings

### Mục tiêu

Đổi ngôn ngữ hiển thị.

### Thành phần UI

- Danh sách ngôn ngữ: Tiếng Việt, English.
- Radio/check cho ngôn ngữ hiện tại.

### Tính năng

- Đổi ngôn ngữ ngay trong app.
- Lưu lựa chọn local và backend nếu có.

## 4.28. Change Password

### Mục tiêu

Cho phép người dùng đổi mật khẩu.

### Thành phần UI

- Mật khẩu hiện tại.
- Mật khẩu mới.
- Xác nhận mật khẩu mới.
- Nút lưu.

### Tính năng

- Validate mật khẩu.
- Hiện/ẩn mật khẩu.
- Gọi API đổi mật khẩu.
- Đăng xuất khỏi các phiên khác nếu backend hỗ trợ.

### Điều hướng

- Thành công -> dialog xác nhận -> `Profile` hoặc `Login` tùy chính sách.

## 5. Màn hình hệ thống dùng chung

## 5.1. Empty State

Dùng khi chưa có dữ liệu cho điểm, lịch, thông báo, hoạt động, KTX. Nội dung nên ngắn, đúng ngữ cảnh, không đổ lỗi cho người dùng.

## 5.2. Error State

Dùng khi API lỗi, timeout hoặc dữ liệu không hợp lệ. Cần có nút thử lại và ghi log kỹ thuật.

## 5.3. Offline State

Nếu có cache, hiển thị dữ liệu gần nhất kèm nhãn "Dữ liệu có thể chưa mới nhất". Nếu không có cache, hiển thị hướng dẫn kiểm tra kết nối.

## 5.4. Permission State

Dùng cho quyền thông báo, mở file, truy cập bộ nhớ hoặc deep link thanh toán nếu cần.

## 6. Deep link và push notification

### Loại deep link đề xuất

```text
myfptschools://home
myfptschools://timetable?date=YYYY-MM-DD
myfptschools://attendance?semesterId=...
myfptschools://grades?semesterId=...
myfptschools://grades/{subjectId}
myfptschools://news/{newsId}
myfptschools://activities/{activityId}
myfptschools://clubs/{clubId}
myfptschools://dormitory
myfptschools://notifications/{notificationId}
```

### Mapping notification -> màn hình

| Loại thông báo | Màn hình đích |
| --- | --- |
| Lịch học thay đổi | Timetable hoặc Class Session Detail |
| Điểm danh vắng/muộn | Attendance hoặc Attendance Subject Detail |
| Có điểm mới | Grade Detail |
| Tin trường mới | News Detail |
| Hoạt động mở đăng ký | Activity Detail |
| CLB tuyển thành viên | Club Detail |
| Kỷ luật/khen thưởng | Decision Detail |
| Hóa đơn KTX | Utility Bill Detail |

## 7. Gợi ý backlog phát triển theo giai đoạn

### Phase 1 - MVP học tập

- Splash, Login, Forgot Password.
- Main Shell với Home, Timetable, Notifications, Profile.
- Attendance.
- Grades và Grade Detail.
- Basic Profile và Logout.
- Loading/error/empty states.

### Phase 2 - Nội dung và hoạt động

- News và News Detail.
- Extracurricular Activities và Activity Detail.
- Clubs và Club Detail.
- Push notification/deep link cơ bản.

### Phase 3 - Sinh hoạt và quản trị cá nhân

- Discipline & Rewards và Decision Detail.
- Dormitory, Room Detail, Utility Bill Detail.
- Notification Settings, Language Settings, Change Password.
- Phụ huynh chọn nhiều học sinh.

### Phase 4 - Hoàn thiện sản phẩm

- Offline cache.
- Analytics sự kiện.
- File viewer.
- Tìm kiếm/lọc nâng cao.
- Phân quyền chi tiết theo vai trò.
- Kiểm thử accessibility và responsive.

## 8. Sơ đồ module đề xuất cho Flutter

```text
lib/
  vn/edu/fpt/
    view/
      auth/
        splash/
        login/
        forgot_password/
      main/
        main_shell/
        home/
        timetable/
        notifications/
        profile/
      attendance/
      grades/
      news/
      activities/
      clubs/
      discipline/
      dormitory/
      settings/
    data/
      models/
      repositories/
      services/
    routing/
      app_router.dart
```

## 9. Checklist cho Figma

- Thiết kế đủ 4 tab chính: Home, Timetable, Notifications, Profile.
- Thiết kế các màn hình stack quan trọng: Attendance, Grades, Grade Detail, News Detail, Activity Detail, Dormitory.
- Có state loading, empty, error cho ít nhất 3 màn hình dữ liệu chính.
- Có biến thể học sinh và phụ huynh.
- Có mẫu notification deep link.
- Có design token cơ bản: màu chính FPT, màu cảnh báo, màu thành công, typography, spacing, icon style.

## 10. Rủi ro và câu hỏi cần xác nhận

- App gốc có thể có màn hình nội bộ chỉ hiện sau đăng nhập, không thể xác minh từ store công khai.
- Cần xác nhận backend sẽ hỗ trợ những API nào: đăng ký ngoại khóa/CLB, thanh toán KTX, file viewer, đổi mật khẩu.
- Cần xác nhận quy định điểm danh thực tế của trường, đặc biệt ngưỡng cảnh báo vắng.
- Cần xác nhận tài khoản phụ huynh có được chọn nhiều học sinh hay không.
- Cần xác nhận app clone chỉ phục vụ demo UI hay kết nối hệ thống thật.


# Kế hoạch triển khai MyFPTSchool

**Trạng thái:** Đã xác nhận cách triển khai theo từng tính năng  
**Cập nhật:** 2026-06-16

## 1. Mục tiêu

Hoàn thiện hệ thống MyFPTSchool phục vụ một trường học, gồm:

- School Admin Portal và Teacher Workspace trong cùng một React Web App.
- Parent App bằng Flutter cho iOS/Android.
- Backend REST API bằng Java 21, Spring Boot và SQL Server.
- Phân quyền chi tiết theo permission, không chỉ kiểm tra role.

Không triển khai toàn bộ màn hình trước rồi mới nối API. Mỗi mốc là một vertical slice chạy được
từ database đến giao diện.

## 2. Quy tắc bàn giao từng mốc

Sau mỗi tính năng, AI phải dừng và báo người dùng kiểm tra. Chỉ chuyển sang mốc kế tiếp sau khi
người dùng xác nhận hoặc yêu cầu sửa.

Một tính năng chỉ được báo hoàn thành khi có đủ phần áp dụng:

1. Requirement và acceptance criteria đã rõ.
2. Database migration, constraint và dữ liệu seed cần thiết.
3. Backend domain/application/API và kiểm tra authorization/data scope.
4. Web Admin/Teacher nếu actor của tính năng sử dụng Web.
5. Flutter Parent App nếu phụ huynh sử dụng tính năng.
6. Loading, empty, error, success và forbidden phù hợp.
7. Unit, integration hoặc UI test theo mức rủi ro.
8. Tài liệu API, database và nghiệp vụ bị ảnh hưởng đã cập nhật.
9. Chạy thành công các lệnh kiểm tra trong `AGENTS.md`.

Mỗi lần bàn giao phải ghi rõ:

- Tính năng đã làm.
- Tài khoản/role và dữ liệu mẫu để kiểm tra.
- Luồng kiểm tra đề xuất.
- Lệnh test đã chạy và kết quả.
- Giới hạn hoặc câu hỏi còn mở.

## 3. Thứ tự triển khai

### F00 - Nền tảng kỹ thuật

**Mục tiêu:** Ba ứng dụng có cấu trúc production baseline và kết nối được với nhau.

- Backend: module structure, error response, validation, audit fields, Flyway, profile cấu hình,
  CORS, health check và OpenAPI.
- Database: migration baseline SQL Server; cấu hình H2 hoặc Testcontainers cho automated test.
- Web: router, layout, theme, API client, error boundary và route guard.
- Mobile: environment config, API client, result/error mapping, route và theme.
- Thiết lập dữ liệu seed phát triển, `.env.example` và hướng dẫn chạy local.

**Điểm kiểm tra:** Chạy được Backend, Web và Mobile; Web/Mobile gọi được health endpoint.

**Trạng thái triển khai:** Hoàn thành kỹ thuật ngày 2026-06-15, chờ người dùng nghiệm thu.

**Kết quả:**

- SQL Server chạy bằng Docker Compose tại cổng host `14330`.
- Flyway `V001` tạo `system_settings`, `audit_events` và schema history thành công.
- Backend có health API, Actuator, OpenAPI, CORS, security baseline, trace ID và error contract.
- Web có router, responsive shell, API client, error boundary và trang trạng thái hệ thống.
- Mobile có environment config, API client, result/error mapping và chỉ báo kết nối.
- Backend test, Web lint/build, Mobile format/analyze/test/build Web đều thành công.

### F01 - Xác thực, tài khoản và RBAC

- Đăng nhập bằng số điện thoại và mật khẩu.
- Access token, refresh token, đăng xuất và xử lý phiên hết hạn.
- Role: `SUPER_ADMIN`, `SCHOOL_ADMIN`, `BAN_GIAM_HIEU`, `GVCN`, `GVBM`, `PHU_HUYNH`.
- Một tài khoản có thể có nhiều role; giáo viên có thể đồng thời là GVCN và GVBM.
- Permission chi tiết theo tính năng và data scope.
- Web quản lý tài khoản: tạo, khóa/mở khóa, reset mật khẩu.
- Web menu/route/action theo permission.
- Mobile login thật thay cho mock và màn hình đăng xuất.
- Quên mật khẩu qua OTP tiếp tục để trạng thái chưa triển khai.

**Điểm kiểm tra:** Đăng nhập bằng từng role, kiểm tra menu, endpoint bị cấm và khóa tài khoản.

**Trạng thái triển khai:** Hoàn thành kỹ thuật ngày 2026-06-15, chờ người dùng nghiệm thu.

**Kết quả:**

- Backend hỗ trợ đăng nhập số điện thoại, JWT access token, refresh token xoay vòng, đăng xuất và thu hồi phiên.
- Mật khẩu được băm bằng BCrypt; refresh token chỉ lưu bản băm SHA-256 trong database.
- Migration `V002` tạo bảng tài khoản, role, permission, quan hệ RBAC và refresh token.
- Có đủ sáu role đã xác nhận; một tài khoản có thể mang nhiều role.
- Web có quản lý tài khoản, khóa/mở khóa, reset mật khẩu, gán role và quản lý ma trận permission.
- Web menu, route và action được ẩn/chặn theo permission; backend vẫn kiểm tra lại bằng method security.
- Mobile dùng API đăng nhập thật, lưu token bằng secure storage và hỗ trợ đăng xuất.
- Các thay đổi quản trị tài khoản/RBAC được ghi vào `audit_events`.
- OTP quên mật khẩu vẫn để ngoài phạm vi F01 theo yêu cầu đã xác nhận.

### F02 - Cấu trúc học vụ và hồ sơ

- Trường, cấp, khối, năm học, học kỳ, lớp và môn học.
- Hồ sơ giáo viên, nhân viên, học sinh và phụ huynh.
- Một học sinh liên kết nhiều phụ huynh; một số điện thoại thuộc một tài khoản.
- Phân công GVCN, GVBM, lớp học và môn dạy.
- Web CRUD, tìm kiếm, lọc và validation.
- Teacher xem đúng lớp/học sinh theo phạm vi.
- Parent App chuyển đổi giữa các hồ sơ học sinh được liên kết.

**Điểm kiểm tra:** Tạo cấu trúc năm học hoàn chỉnh và xác minh data scope của từng actor.

**Trạng thái triển khai:** Hoàn thành kỹ thuật ngày 2026-06-15, chờ nghiệm thu gộp F02-F04.

**Kết quả:**

- Migration `V003` tạo hồ sơ giáo viên/phụ huynh/học sinh, cấp/khối/năm/kỳ/lớp/môn,
  enrollment, GVCN và phân công GVBM.
- Web có dashboard học vụ, danh sách lớp/môn/học sinh/phân công và form tạo dữ liệu chính.
- Web tạo được năm học, lớp, môn, hồ sơ giáo viên/học sinh, liên kết phụ huynh, phân công
  GVCN và GVBM.
- Parent App tải hồ sơ liên kết thật và hỗ trợ chuyển đổi giữa nhiều học sinh.
- Data scope GVCN và Phụ huynh được kiểm tra ở backend.

### F03 - Thời khóa biểu

- Import Excel với chiến lược all-or-nothing.
- Kiểm tra mã lớp, môn, giáo viên, phòng, tiết và xung đột.
- Trả danh sách lỗi theo dòng/cột để sửa file.
- Ghi đè TKB MVP, publish và gửi thông báo cập nhật.
- Teacher xem lịch dạy; Parent App xem lịch ngày/tuần.

**Điểm kiểm tra:** Import file đúng, file sai, xung đột và publish xuống hai portal.

**Trạng thái triển khai:** Hoàn thành kỹ thuật ngày 2026-06-15, chờ nghiệm thu gộp F02-F04.

**Kết quả:**

- Import `.xlsx/.xls` bằng Apache POI với contract cột cố định và validation toàn file trước khi ghi.
- Kiểm tra mã tham chiếu, phân công, trùng lớp và trùng giáo viên; file lỗi trả dòng/cột.
- Publish tạo teaching session tương lai, giữ lịch sử session/điểm danh đã phát sinh và tạo notification.
- Web có upload, kết quả lỗi, danh sách TKB, publish và lịch dạy cá nhân.
- Parent App hiển thị lịch học thật theo hồ sơ đang chọn.

### F04 - Điểm danh

- GVBM điểm danh theo đúng tiết được phân công.
- Trạng thái: có mặt, vắng phép, vắng không phép, đi muộn.
- Ghi chú nội bộ và ghi chú được phép hiển thị cho phụ huynh.
- Giáo viên được sửa trong ngày; sang ngày sau dữ liệu bị khóa.
- Admin có permission phù hợp được sửa sau khóa.
- Parent App nhận và tra cứu trạng thái theo từng tiết, kèm thời gian cụ thể.
- Tạo notification ngay khi giáo viên lưu.

**Điểm kiểm tra:** Quyền theo tiết dạy, khóa qua ngày, sửa sau khóa và thông báo phụ huynh.

**Trạng thái triển khai:** Hoàn thành kỹ thuật ngày 2026-06-15, chờ nghiệm thu gộp F02-F04.

**Kết quả:**

- Teacher Workspace có danh sách tiết dạy, roster, đánh dấu nhanh bốn trạng thái và ghi chú.
- Backend giới hạn theo giáo viên được phân công, khóa qua ngày và yêu cầu lý do khi sửa đặc quyền.
- Admin có màn tra cứu tiết toàn trường và hiệu chỉnh sau khóa bằng lý do bắt buộc.
- Mỗi thay đổi được ghi `attendance_change_logs`.
- Lưu điểm danh tạo notification cho mọi phụ huynh liên kết.
- Parent App tra cứu lịch sử điểm danh theo ngày/tiết/trạng thái/ghi chú.
- E2E local xác nhận lần lượt các mã `403`, `409`, `400`, `200` cho scope, khóa ngày và
  correction; import lỗi giữ nguyên số timetable entry.

### F05 - Điểm số và hạnh kiểm

- Điểm thường xuyên hệ số 1, giữa kỳ hệ số 2, cuối kỳ hệ số 3.
- Môn định lượng và môn đánh giá `Đạt/Không đạt`.
- Khung điểm và quy tắc xếp loại do Admin cấu hình.
- Workflow: `DRAFT -> SUBMITTED -> APPROVED -> PUBLISHED`.
- Khi bị từ chối, bảng điểm trở về `DRAFT` để giáo viên sửa và nộp lại.
- GVCN nhập hạnh kiểm; Ban Giám Hiệu duyệt cùng bảng điểm.
- Parent App chỉ xem dữ liệu đã công bố.

**Điểm kiểm tra:** Tính điểm, workflow duyệt/từ chối/công bố và giới hạn dữ liệu phụ huynh.

**Trạng thái triển khai:** Hoàn thành kỹ thuật ngày 2026-06-15, chờ người dùng nghiệm thu.

**Kết quả:**

- Migration `V004` tạo chính sách điểm, loại đánh giá, sổ điểm, điểm, workflow log, snapshot
  công bố, hạnh kiểm và tổng kết học kỳ.
- Web cho phép School Admin cấu hình hệ số/làm tròn/xếp loại, GVBM nhập và nộp điểm, GVCN
  nhập và nộp hạnh kiểm, BGH duyệt/từ chối/công bố đồng bộ.
- Parent App có tab Bảng điểm và chỉ đọc dữ liệu `PUBLISHED`.
- E2E SQL Server công bố thành công bốn môn của lớp `7A1`; kết quả demo có trung bình `8.5`,
  học lực `EXCELLENT`, hạnh kiểm `GOOD`.

### F06 - Đơn xin nghỉ

**Trạng thái cập nhật 2026-06-16:** Đã nối vertical slice backend, Web Teacher và Parent App; mobile đã hỗ trợ chọn ngày, nghỉ dài ngày, sửa/hủy đơn khi `PENDING`; web duyệt/từ chối bằng UI modal thay cho prompt thô.

- Đơn một ngày: chọn ngày và từng tiết.
- Đơn dài ngày: từ ngày đến ngày.
- Chỉ có trường lý do dạng text.
- GVCN duyệt hoặc từ chối đơn của lớp chủ nhiệm.
- Phụ huynh chỉ sửa/hủy khi đơn ở trạng thái `PENDING`.
- Web Teacher nhận danh sách cần xử lý; Mobile theo dõi trạng thái.
- Backend ghi lịch sử trạng thái và gửi notification cho GVCN/phụ huynh.

**Điểm kiểm tra:** Tạo, sửa, hủy, duyệt, từ chối và kiểm tra data scope theo lớp.

### F07 - CMS, sự kiện và thông báo

**Trạng thái cập nhật 2026-06-16:** Đã nối content publish, notification center, Web Admin và Parent App feed; web đã cho chọn target toàn trường/khối/lớp khi publish.

- Dùng chung content model, phân biệt bằng type: News, Announcement, Event.
- Mỗi tin tức/thông báo/sự kiện có `imageUrl` làm ảnh bìa để hiển thị trên Web Admin và Parent App.
- Trạng thái `DRAFT` và `PUBLISHED`, không có scheduler.
- Target theo toàn trường, khối hoặc lớp.
- Nội dung xuất bản xuất hiện trên feed Parent App.
- Push notification được lưu vào trung tâm thông báo.
- Trạng thái đã đọc/chưa đọc và deep link tới nội dung.
- Giai đoạn hiện tại lưu notification trong DB; push provider ngoài là phần hardening F09.

**Điểm kiểm tra:** Target đúng nhóm, không rò dữ liệu giữa lớp và trạng thái đọc hoạt động.

### F08 - Câu lạc bộ

**Trạng thái cập nhật 2026-06-16:** Đã nối quản lý CLB, danh sách Parent App, đăng ký/hủy atomic và web xem danh sách học sinh đăng ký theo CLB.

- Admin quản lý CLB, ảnh đại diện, giáo viên phụ trách, slot, ngày khai giảng và mô tả.
- CLB được tạo ở trạng thái `DRAFT`; Admin/Ban quản trị dùng hành động duyệt/mở đăng ký để chuyển sang `OPEN`.
- Parent App xem danh sách/chi tiết và số slot còn lại.
- Đăng ký thành công ngay nếu còn slot.
- Một học sinh đăng ký tối đa ba CLB.
- Không có waiting list và thanh toán.
- Không có bước phê duyệt từng đăng ký CLB của phụ huynh theo yêu cầu đã xác nhận; danh sách đăng ký dùng để Admin theo dõi quota.
- Phụ huynh có thể hủy đăng ký.
- Backend xử lý transaction/concurrency để không vượt quota.
- Hủy đăng ký hiện theo giả định `Q-05`: chỉ nghiệp vụ backend kiểm tra trạng thái active, chưa khóa theo ngày khai giảng.

**Điểm kiểm tra:** Slot cuối cùng, đăng ký đồng thời, giới hạn ba CLB và hủy đăng ký.

### F09 - Hoàn thiện sản phẩm và release

**Trạng thái cập nhật 2026-06-16:** Web dashboard không còn placeholder, đã tổng hợp dữ liệu thật từ tài khoản/học vụ/TKB/điểm danh/điểm/đơn nghỉ/CMS/CLB; mobile dịch vụ đã tách tab con để dễ dùng hơn.

- Dashboard Admin, Teacher và Parent tổng hợp dữ liệu thật.
- Hoàn thiện navigation, profile, student switcher và logout.
- Accessibility, responsive, keyboard, safe area và các trạng thái mất mạng.
- Audit cho thao tác quản trị quan trọng.
- Security hardening, rate limit phù hợp và kiểm tra OWASP cơ bản.
- Kiểm thử tải cho mục tiêu 100-200 request/giây ở luồng điểm danh.
- Docker/config deployment, logging, backup/restore và runbook.
- Regression test toàn hệ thống và chuẩn bị dữ liệu demo.
- Còn cần kiểm thử tải, runbook triển khai, backup/restore và OWASP checklist trước release production.

**Điểm kiểm tra:** Chạy end-to-end các luồng chính và checklist production readiness.

## 4. Phạm vi theo portal

| Mốc | Backend | Web Admin | Web Teacher | Parent App |
|---|---:|---:|---:|---:|
| F00 Nền tảng | Có | Có | Có | Có |
| F01 Auth/RBAC | Có | Có | Có | Có |
| F02 Học vụ/hồ sơ | Có | Có | Có | Có |
| F03 TKB | Có | Có | Có | Có |
| F04 Điểm danh | Có | Tra cứu/sửa | Có | Có |
| F05 Điểm/hạnh kiểm | Có | Đã triển khai | Đã triển khai | Đã triển khai |
| F06 Đơn nghỉ | Có | Không bắt buộc | Duyệt | Có |
| F07 CMS/thông báo | Có | Quản lý | Nhận/xem | Có |
| F08 CLB | Có | Quản lý | Xem phụ trách | Có |
| F09 Hoàn thiện | Có | Có | Có | Có |

## 5. Cách phối hợp

- AI chỉ triển khai một mốc tại một thời điểm.
- Trong mỗi mốc, ưu tiên backend rule và test trước, sau đó API consumer và UI.
- Khi bàn giao một mốc, AI dừng để người dùng chạy thử và review giao diện/nghiệp vụ.
- Sửa hết phản hồi của mốc hiện tại trước khi chuyển sang mốc kế tiếp.
- Không âm thầm thay đổi requirement đã xác nhận; thay đổi lớn phải cập nhật tài liệu hoặc ADR.

# Quy trình & Checklist — Student/Parent Features Implementation

> File sống: cập nhật trạng thái từng task khi hoàn thành.
> Trạng thái: ⬜ Chưa làm | 🔄 Đang làm | ✅ Xong | ❌ Blocked

---

## Quy tắc làm việc

### Trước khi code
1. **Read file trước khi edit** — không edit từ trí nhớ
2. **Kiểm tra service → controller → view** — hiểu data flow từ API xuống UI trước khi sửa
3. **Verify response structure** — xem file controller backend để biết response bọc hay không bọc ApiResponse

### Khi code
4. **Ưu tiên fix bug trước khi thêm tính năng** — crash là bug cao hơn feature thiếu
5. **Không sửa mock data** — mock chỉ dùng để test offline; production phải dùng real service
6. **Giữ pattern hiện tại** — GetX, Dio, `response.data['data']` pattern

### Sau khi code
7. **Test trực tiếp trên emulator/device** với account thực tế (student001 / Password@1)
8. **Test cả parent flow** khi sửa backend service — parent account cần verify riêng

### Quy tắc verify từng loại thay đổi

| Loại thay đổi | Verify thêm |
|---|---|
| Sửa service `.dart` | Kiểm tra response structure khớp với backend controller |
| Thêm query param backend | `@RequestParam` có default hay required? |
| Sửa semester ordering | Kiểm tra `SemesterRepository.findAllWithAcademicYear()` — hiện ORDER BY startDate DESC |
| Sửa backend `MeService` | Đảm bảo PARENT role có code path riêng |
| Thêm validation | Đồng bộ giữa Flutter Validator và Spring `@Valid` annotation |

---

## BƯỚC 1 — Fix Bug Ngay (không cần backend, không test thêm)

### 1.1 `attendance_service.dart` — sai response unwrap `[CRASH]`

**File:** `lib/vn/edu/fpt/core/services/attendance_service.dart`

- ⬜ Đọc file để confirm dòng 18: `final list = response.data as List;`
- ⬜ Sửa thành: `final list = response.data['data'] as List;`
- ⬜ Verify: mọi service khác (`grade_service.dart`, `timetable_service.dart`) đều dùng `['data']`

> **Vì sao crash:** `api_client.dart` không có interceptor unwrap. Backend trả `{ code, message, data: [...] }`. Cast Map → List = `TypeError`.

---

### 1.2 `home_controller.dart` — sai index semester `[HIỂN THỊ SAI]`

**File:** `lib/vn/edu/fpt/controllers/home_controller.dart`

- ⬜ Đọc file để confirm dòng 47: `final latest = semesters.last;`
- ⬜ Sửa thành: `final latest = semesters.first;`
- ⬜ Verify: `semester_service.dart` gọi `GET /me/semesters` → `SemesterRepository` ORDER BY `startDate DESC` → index 0 = mới nhất

> **Vì sao sai:** DESC order → `semesters[0]` = HK II (mới nhất), `semesters.last` = HK I (cũ nhất). GPA trên Home luôn hiển thị kỳ cũ.

---

### 1.3 `timetable_controller.dart` — kiểm tra semester default selection

**File:** `lib/vn/edu/fpt/controllers/timetable_controller.dart`

- ⬜ Đọc controller, tìm logic chọn semester mặc định khi màn hình mở
- ⬜ Nếu dùng `semesters.last` → sửa thành `semesters.first`
- ⬜ Nếu dùng logic phức tạp hơn (tìm kỳ đang chạy theo date range) → giữ nguyên, chỉ verify đúng

---

### 1.4 `attendance_controller.dart` — kiểm tra semester default

**File:** `lib/vn/edu/fpt/controllers/attendance_controller.dart`

- ⬜ Đọc controller, tìm `selectedSemesterId` hoặc khởi tạo `semesters`
- ⬜ Đảm bảo default semester = kỳ mới nhất (index 0 sau sort DESC)

---

### 1.5 `grade_controller.dart` — kiểm tra semester default

**File:** `lib/vn/edu/fpt/controllers/grade_controller.dart`

- ⬜ Đọc controller, xác nhận semester default
- ⬜ Sửa nếu cần (pattern giống 1.2)

---

## BƯỚC 2 — Backend: Hỗ trợ phụ huynh xem dữ liệu con

> Hiện tại phụ huynh đăng nhập và gọi `/me/attendance`, `/me/grades`, `/me/timetable` — backend không biết cần trả data của học sinh nào.

### 2.1 Verify cấu trúc bảng parent-student

- ⬜ Đọc entity `Parent.java` — xem relationship với `Student`
- ⬜ Đọc `ParentRepository.java` — có method `findByUserUsername` không?
- ⬜ Xác nhận: một parent có thể liên kết với nhiều học sinh (1-N)

### 2.2 Thêm `studentId` param vào `MeService`

**File:** `myfptschool-be/.../me/service/MeService.java`

- ⬜ Đọc `getTimetable(username, date)` method hiện tại
- ⬜ Thêm overload/param: `getTimetable(username, date, Long studentId)`
  ```java
  // Nếu requester là PARENT:
  //   1. Verify parent.students có chứa studentId không
  //   2. Load timetable của studentId
  // Nếu là STUDENT: bỏ qua studentId param
  ```
- ⬜ Tương tự cho `getAttendance(username, semesterId, Long studentId)`
- ⬜ Tương tự cho `getGrades(username, semesterId, Long studentId)`

### 2.3 Cập nhật controller endpoints

**File:** `myfptschool-be/.../me/controller/MeController.java`

- ⬜ `GET /me/timetable` — thêm `@RequestParam(required=false) Long studentId`
- ⬜ `GET /me/attendance` — thêm `@RequestParam(required=false) Long studentId`
- ⬜ `GET /me/grades` — thêm `@RequestParam(required=false) Long studentId`
- ⬜ Verify: `@PreAuthorize("hasAnyRole('STUDENT','PARENT')")` đã có

### 2.4 Thêm `GET /me/children`

- ⬜ Tạo DTO `ChildSummaryResponse`: `{id, fullName, studentCode, classroomName, grade, campus}`
- ⬜ Thêm method `getMyChildren(username)` vào MeService
- ⬜ Thêm endpoint `GET /me/children` với `@PreAuthorize("hasRole('PARENT')")`

### 2.5 Cập nhật Flutter `auth_controller.dart`

- ⬜ Sau login với PARENT role: gọi `GET /me/children` → populate `students` list
- ⬜ `selectedStudentId.value = students.first.id` (tự động chọn con đầu tiên)
- ⬜ Verify: `home_controller.dart` truyền `studentId` khi là parent

---

## BƯỚC 3 — Màn hình Trang chủ (Home)

### 3.1 Verify lịch học hôm nay

- ⬜ Test với `student001`: login → Home → thấy đúng 3 tiết ngày 16/06
- ⬜ Test tiết trống (cuối tuần): Home → "Hôm nay không có tiết học"
- ⬜ Kiểm tra màu tiết học (colorHex từ backend hay hardcoded?)

### 3.2 Verify GPA section

- ⬜ Sau fix Bug 1.2: GPA hiển thị đúng HK II (id=2), không phải HK I (id=1)
- ⬜ Test học sinh có grades HK II: ĐTB phải khớp với tính tay
- ⬜ Test học sinh không có grades nào: hiển thị "0.0" hay placeholder?

### 3.3 Verify thông báo gần đây

- ⬜ `recentNotices` hiện 3 thông báo mới nhất
- ⬜ Click thông báo → navigate đến `NotificationDetailScreen`
- ⬜ Click "Xem tất cả" → navigate đến `NotificationScreen`

### 3.4 Verify parent home

- ⬜ Parent login → HomeScreen hiển thị `ParentHomeContent`
- ⬜ Chip chọn con hiện đúng danh sách
- ⬜ Đổi con → GPA và lịch học cập nhật theo đúng con mới

---

## BƯỚC 4 — Màn hình Thời khóa biểu (Timetable)

### 4.1 Kiểm tra date-day navigation

- ⬜ Click T2 → hiển thị lịch ngày thứ Hai tuần đó
- ⬜ Click T3 → chuyển đúng ngày
- ⬜ Nút "tuần trước / tuần sau" → cập nhật đúng week range label
- ⬜ Ngày không có tiết → hiển thị "Không có tiết học hôm nay"

### 4.2 Kiểm tra lesson detail modal

- ⬜ Click tiết học → bottom sheet mở đúng thông tin
- ⬜ Tiết `cancelled` → hiển thị trạng thái "Bị hủy" rõ ràng
- ⬜ Tiết `completed` + đã điểm danh → hiện trạng thái "Có mặt / Đi muộn / Vắng"

### 4.3 Kiểm tra semester tab

- ⬜ Tab "HK II" selected mặc định (sau fix Bug 1.3)
- ⬜ Chuyển sang "HK I" → lịch reset về tuần đầu HK I hay tuần hiện tại?
- ⬜ Quyết định UX: khi chuyển kỳ nên nhảy tới ngày nào?

---

## BƯỚC 5 — Màn hình Điểm danh (Attendance)

### 5.1 Sau fix Bug 1.1 — verify màn hình load được

- ⬜ Test `student001` → Điểm danh → không crash
- ⬜ HK II hiển thị: 104+ tiết (từ seed data)
- ⬜ Filter môn: click "Toán" → chỉ hiển thị card Toán

### 5.2 Verify số liệu tổng hợp

- ⬜ Card tổng kết: `totalSessions` = tổng tất cả môn
- ⬜ Phần trăm vắng tính đúng: `(unexcusedAbsent + excusedAbsent) / totalSessions × 100`
- ⬜ Cảnh báo hiện khi `status != 'safe'`

### 5.3 Verify attendance detail

- ⬜ Click card môn → `AttendanceDetailScreen` mở
- ⬜ Session list hiển thị đúng ngày, tiết, trạng thái
- ⬜ Màu session label đúng: `present`=xanh, `late`=vàng, `excused_absent`=cam, `unexcused_absent`=đỏ

### 5.4 Semester default sau fix

- ⬜ Mở màn hình → dropdown mặc định = HK II (sau fix Bug 1.4)
- ⬜ Đổi sang HK I → data reload đúng

---

## BƯỚC 6 — Màn hình Điểm số (Grades)

### 6.1 Verify grade list

- ⬜ Test `student001` HK I: 50 bản ghi, ÷ tổng môn = danh sách môn
- ⬜ Test HK II: 30 bản ghi
- ⬜ Môn `in_progress` (chưa có đủ điểm) hiển thị badge "Đang học"

### 6.2 Verify GPA summary card

- ⬜ ĐTB tính đúng công thức: `∑(ĐTBm × hệ số) / ∑hệ số`
- ⬜ Chỉ tính môn có `subjectAverage != null`
- ⬜ Label "X/Y môn hoàn thành" hiển thị đúng (Y = tổng môn học kỳ đó)

### 6.3 Verify grade detail

- ⬜ Click môn → `GradeDetailScreen` mở
- ⬜ TX scores hiển thị đúng số lượng (TX1, TX2, TX3...)
- ⬜ Điểm GK (hệ số 2), CK (hệ số 3) hiển thị riêng biệt
- ⬜ ĐTBm tính đúng TT22/2021

### 6.4 Kiểm tra `subjectAverage` computation

- ⬜ Đọc `GradeItem` class trong `grade_mock_data.dart` — xem `subjectAverage` là getter hay field
- ⬜ Verify công thức trong `GradeItem`:
  ```
  ĐTBm = (∑ regularScores×1 + midtermScore×2 + finalScore×3) / (n + 2 + 3)
  ```
- ⬜ Test với môn chỉ có 2 điểm TX + GK (chưa CK): `subjectAverage` = null hay partial?

---

## BƯỚC 7 — Màn hình Thông báo (Notifications)

### 7.1 Verify load & display

- ⬜ `student001` có 16 thông báo unread → badge hiện "16"
- ⬜ Danh sách thông báo scroll được
- ⬜ Filter category: click "Sự kiện" → chỉ hiện event notifications

### 7.2 Verify mark as read

- ⬜ Click thông báo → mở detail → unread dot biến mất
- ⬜ "Đánh dấu tất cả đã đọc" → tất cả dot biến mất, counter = 0
- ⬜ Kiểm tra backend có 2 endpoint: `PATCH /me/notifications/{id}/read` và `PATCH /me/notifications/read-all`

### 7.3 Verify pagination

- ⬜ Scroll đến cuối → load thêm (infinite scroll hoặc "Load more" button)
- ⬜ `totalPages` từ API được dùng để biết khi nào dừng load

### 7.4 Category mapping

- ⬜ Verify Flutter enum `NotificationCategory` có đủ 5 giá trị: `study`, `attendance`, `grade`, `event`, `homeroom`
- ⬜ Các notification đã seed thuộc `event` và `homeroom` hiện đúng icon/màu

---

## BƯỚC 8 — Màn hình Liên hệ (Contact)

### 8.1 Verify data load

- ⬜ `student001` → Contact → hiển thị GVCN + 9 GV bộ môn
- ⬜ GVCN hiển thị phần riêng ở đầu (`isHomeroom: true`)
- ⬜ GV bộ môn list đúng thứ tự

### 8.2 Verify phone action

- ⬜ Click số điện thoại → mở app gọi điện (cần device thật, không test được trên emulator)
- ⬜ Trên emulator: không crash, có thể log URL `tel://...`

### 8.3 Kiểm tra parent flow

- ⬜ Parent xem contact của con → `GET /me/teachers?studentId=Y` hay `/me/teachers` đã biết context?
- ⬜ Hiện tại backend `/me/teachers` dùng auth username → với PARENT cần truyền studentId

---

## BƯỚC 9 — Màn hình Hồ sơ (Profile)

### 9.1 Verify profile data

- ⬜ `student001` → Profile → hiển thị đúng thông tin từ `GET /me/profile`
- ⬜ Mã học sinh, lớp, trường hiển thị trong `PersonalInfoScreen`
- ⬜ Phụ huynh → Profile → hiển thị danh sách con trong "Con đang liên kết"

### 9.2 Verify đổi mật khẩu

- ⬜ `student001` đổi password từ `Password@1` → `NewPass@2026`
- ⬜ Đăng xuất → đăng nhập lại với mật khẩu mới: thành công
- ⬜ Sai mật khẩu hiện tại → hiện thông báo lỗi rõ ràng

### 9.3 Đồng nhất validation min password

- ⬜ Đọc `change_password_screen.dart` — confirm đang validate min 8
- ⬜ Đọc backend `ChangePasswordRequest.java` — confirm validate min 6
- ⬜ Quyết định: **thống nhất lên min 8** (an toàn hơn)
  - Flutter: giữ nguyên min 8
  - Backend: đổi `@Size(min = 6)` → `@Size(min = 8)` trong `ChangePasswordRequest`

---

## BƯỚC 10 — Test End-to-End Full Flow

### 10.1 Student flow hoàn chỉnh

- ⬜ Login `student001 / Password@1`
- ⬜ Home: lịch học đúng, GPA đúng kỳ, thông báo load
- ⬜ Timetable: tuần 16-20/06 có đủ 15 tiết, navigate ngày đúng
- ⬜ Attendance: không crash, hiện đúng số liệu HK II
- ⬜ Grades: HK II hiển thị 30 bản ghi, ĐTB tính được
- ⬜ Notifications: 16 thông báo, mark read hoạt động
- ⬜ Contact: 10 giáo viên load đúng
- ⬜ Profile: thông tin đúng, đổi mật khẩu thành công

### 10.2 Parent flow (sau Bước 2)

- ⬜ Login parent account (cần tạo parent test account)
- ⬜ Home hiển thị `ParentHomeContent` với chip chọn con
- ⬜ Chọn con → tất cả tab cập nhật dữ liệu đúng của con đó
- ⬜ Profile hiển thị info phụ huynh + danh sách con

### 10.3 Edge cases

- ⬜ Học sinh chưa có điểm nào → Grades: empty state rõ ràng
- ⬜ Không có tiết học hôm nay → Home + Timetable: "Không có tiết"
- ⬜ Tất cả thông báo đã đọc → không hiện badge
- ⬜ Offline / server unreachable → hiển thị error message (không crash)

---

## Log thay đổi

| Thời gian | Task | Người làm | Ghi chú |
|---|---|---|---|
| | | | |

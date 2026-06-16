# Đặc tả tính năng Học sinh & Phụ huynh — MyFPTSchool (Flutter)

> Viết từ góc nhìn người dùng thực tế. Căn cứ trên code Flutter hiện tại + đối chiếu backend Spring Boot.
> Cập nhật: 2026-06-16. Bug 1–4 đã fix. Parent flow đã hoàn chỉnh cả Flutter lẫn backend.

---

## 1. Triết lý thiết kế

**Nguyên tắc cốt lõi:** Ứng dụng học sinh là **giao diện theo dõi** — không phải nhập liệu. Học sinh/phụ huynh nhìn vào app để biết tình hình học tập hôm nay, tuần này, học kỳ này.

| Giáo viên cần | Học sinh cần | Phụ huynh cần |
|---|---|---|
| Nhập điểm danh, điểm số | Biết lịch học hôm nay | Theo dõi con học tốt không |
| Xem danh sách lớp | Xem kết quả học tập | Nhận thông báo từ trường |
| Gửi thông báo | Liên hệ giáo viên | Xem điểm danh, điểm số của con |

**Hai loại trải nghiệm:**
- **Học sinh (STUDENT)**: Xem dữ liệu của chính mình, cá nhân hóa hoàn toàn
- **Phụ huynh (PARENT)**: Xem dữ liệu con (nếu nhiều con → chọn con), giao diện giống student nhưng thêm lớp "chọn con"

---

## 2. Hai vai trò

| Role | Tên | Phạm vi |
|---|---|---|
| `STUDENT` | Học sinh | Dữ liệu của chính mình |
| `PARENT` | Phụ huynh | Dữ liệu các con đã được liên kết qua bảng `parents → students` |

---

## 3. Kiến trúc điều hướng (Navigation)

### Bottom Navigation (7 tab)

```
┌──────┬───────────┬──────────┬──────────┬──────────┬──────────┬────────┐
│ Home │ Timetable │ Attendance│  Grade  │  Notif  │ Contact  │ Profile│
│ 🏠   │ 📅        │ ✅        │  📊      │  🔔      │  📞      │  👤    │
└──────┴───────────┴──────────┴──────────┴──────────┴──────────┴────────┘
```

### Routing

| Route | Screen | Ghi chú |
|---|---|---|
| `/home` | `HomeScreen` | Phân nhánh student/parent |
| `/timetable` | `TimetableScreen` | Lịch học theo ngày/tuần |
| `/attendance` | `AttendanceScreen` | Điểm danh theo học kỳ/môn |
| `/grade` | `GradeScreen` | Điểm số theo học kỳ |
| `/notification` | `NotificationScreen` | Hộp thư |
| `/contact` | `ContactScreen` | Liên hệ giáo viên |
| `/profile` | `ProfileScreen` | Hồ sơ cá nhân |
| `/personal-info` | `PersonalInfoScreen` | Chi tiết thông tin |

---

## 4. Màn hình 1 — Trang chủ (Home)

### 4.1 Luồng học sinh

```
┌─────────────────────────────────────────────┐
│  Chào buổi sáng, Nguyễn Văn A               │
│  Học sinh · Lớp 10A1 · Thứ Hai, 16/06/2026  │
├─────────────────────────────────────────────┤
│  LỊCH HỌC HÔM NAY                           │
│  ┌──────────────────────────────────────┐   │
│  │ Tiết 1-2 · 07:00  Lịch Sử · P.101   │   │
│  │ Tiết 3-4 · 08:45  Toán · P.202       │   │
│  └──────────────────────────────────────┘   │
│  [Xem toàn bộ thời khóa biểu →]             │
├─────────────────────────────────────────────┤
│  ĐIỂM TRUNG BÌNH HỌC KỲ NÀY                 │
│  ┌──────────────────────────────────────┐   │
│  │  HK II · 2025-2026                   │   │
│  │  ████████░░  7.5  Giỏi               │   │
│  │  ↑ +0.3 so với HK I                  │   │
│  └──────────────────────────────────────┘   │
├─────────────────────────────────────────────┤
│  THÔNG BÁO GẦN ĐÂY                          │
│  • Lịch thi cuối kỳ HK II  [vừa rồi]        │
│  • Nhắc nhở đóng học phí   [2 ngày trước]   │
│  [Xem tất cả →]                              │
├─────────────────────────────────────────────┤
│  SỰ KIỆN SẮP TỚI                            │
│  [Họp phụ huynh 28/6] [Thi cuối kỳ 1/7]    │
└─────────────────────────────────────────────┘
```

### 4.2 Luồng phụ huynh

```
┌─────────────────────────────────────────────┐
│  Xin chào, Trần Thị B (Phụ huynh)           │
│  Theo dõi quá trình học của con              │
├─────────────────────────────────────────────┤
│  [Con: Nguyễn Văn A ▼]  ← nếu nhiều con     │
│                                              │
│  Nguyễn Văn A · 10A1 · Trường FPT           │
│  ┌────────────────────────────────────┐      │
│  │ Chuyên cần: 95% | ĐTB: 7.5 | ⚠ 0 │      │
│  └────────────────────────────────────┘      │
├─────────────────────────────────────────────┤
│  Lịch học hôm nay của con (giống student)    │
│  Thông báo & sự kiện (giống student)         │
└─────────────────────────────────────────────┘
```

### 4.3 Luồng dữ liệu

```
GET /me/timetable?date=YYYY-MM-DD         → lịch học hôm nay
GET /me/notifications?page=0&size=5      → recent notices
GET /me/notifications?page=0&size=5&category=event  → events
GET /me/semesters                         → list học kỳ
GET /me/grades?semesterId=X               → tính GPA hiện tại
```

> ✅ **Đã fix:** `home_controller.dart:47` — đổi `semesters.last` → `semesters.first`. Backend trả DESC nên index 0 = học kỳ mới nhất.

---

## 5. Màn hình 2 — Thời khóa biểu (Timetable)

### Mục tiêu
Học sinh biết ngày nào học gì, tiết mấy, phòng nào. Xem theo từng ngày trong tuần.

### Layout

```
[← Tuần trước]  16/06 – 22/06/2026  [Tuần sau →]

T2  T3  T4  T5  T6  T7  CN
16  17  18  19  20  21  22

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Thứ Hai, 16/06/2026

⏱ 07:00 – 08:35  Tiết 1-2
  ┌─────────────────────────────┐
  │ Lịch Sử                    │
  │ 📍 Phòng 101  👤 GV: ...   │
  │ ● Đã học                   │
  └─────────────────────────────┘

⏱ 08:45 – 10:20  Tiết 3-4
  ┌─────────────────────────────┐
  │ Toán                        │
  │ 📍 Phòng 202  👤 GV: ...   │
  │ ✓ Có mặt                   │
  └─────────────────────────────┘
```

- Click tiết → bottom sheet chi tiết (môn, phòng, thầy, trạng thái)
- Badge trạng thái: **Có mặt** (xanh), **Vắng** (đỏ), **Chưa diễn ra** (xám), **Bị hủy** (gạch ngang)

### Selector học kỳ
- Tabs ngang chọn học kỳ (HK I / HK II)
- Mặc định: học kỳ đang chạy
- Chuyển kỳ → reset về tuần đầu của kỳ đó hoặc tuần hiện tại

### Luồng dữ liệu

```
GET /me/semesters           → danh sách học kỳ (để hiện tabs)
GET /me/timetable?date=X    → lịch học của ngày được chọn
  Response: [{
    id, date, subjectName, teacherName,
    startTime, endTime, slotLabel,
    roomCode, colorHex, status, hasMaterials
  }]
```

### Trạng thái tiết học (từ backend)

| Status | Hiển thị | Màu |
|---|---|---|
| `scheduled` | Chưa diễn ra | Xám |
| `completed` + attendance `present` | Có mặt | Xanh |
| `completed` + attendance `late` | Đi muộn | Vàng |
| `completed` + attendance `absent*` | Vắng | Đỏ |
| `completed` + không có record | Chưa điểm danh | Cam |
| `cancelled` | Bị hủy | Gạch ngang |

---

## 6. Màn hình 3 — Điểm danh (Attendance)

### Mục tiêu
Học sinh/phụ huynh theo dõi tình hình chuyên cần từng môn trong học kỳ.

### Layout

```
[Chọn học kỳ ▼]  HK II – 2025-2026

┌──────────────────────────────────────────────┐
│  TỔNG KẾT CHUYÊN CẦN                        │
│  104 tiết học | 99 có mặt | 2 vắng có phép  │
│  1 vắng không phép | 2 đi muộn               │
│  ⚠ Ngưỡng cảnh báo: 20% (không quá 21 tiết) │
└──────────────────────────────────────────────┘

[Tất cả] [Toán] [Lý] [Hóa] [...]  ← filter môn

┌──────────────────────────┐
│ Toán · GV Nguyễn A       │
│ ● AN TOÀN                │
│ ✓ 18  ↓ 0  P 0  M 0      │
│ ▓▓▓▓▓▓░░  0 / 20 tiết vắng│
└──────────────────────────┘
  → click → AttendanceDetailScreen

┌──────────────────────────┐
│ Lịch Sử · GV Trần B      │
│ ⚠ CHÚ Ý                  │
│ ✓ 14  ↓ 2  P 1  M 1      │
│ ▓▓▓▓▓▓▓░  4 / 20 tiết vắng│
└──────────────────────────┘
```

### Chi tiết từng môn (AttendanceDetailScreen)

```
Toán · GV Nguyễn Văn A
● AN TOÀN  (0/20 tiết vắng)

[✓ Có mặt: 18]  [↓ Vắng CP: 0]  [↑ Vắng KP: 0]  [⏱ Muộn: 0]
████████████░░░░  0%

── Lịch sử điểm danh ──────────────────
16/06 · Tiết 3-4  ✓ Có mặt
09/06 · Tiết 3-4  ✓ Có mặt
04/06 · Tiết 5    ⏱ Đi muộn
```

### Trạng thái cảnh báo

| Status | Điều kiện | Màu |
|---|---|---|
| `safe` | vắng < ngưỡng | Xanh |
| `attention` | vắng ≥ 70% ngưỡng | Vàng |
| `danger` | vắng ≥ ngưỡng | Cam |
| `exceeded` | vắng > ngưỡng (bị cấm thi) | Đỏ |

> Backend tính status và trả về trong response, Flutter chỉ hiển thị. Tốt.

### Luồng dữ liệu

```
GET /me/semesters                  → danh sách học kỳ (dropdown)
GET /me/attendance?semesterId=X    → list môn + tổng hợp chuyên cần
  Response (trong ApiResponse.data): [{
    classroomSubjectId, subjectName, teacherName,
    totalSessions, presentSessions, lateSessions,
    excusedAbsent, unexcusedAbsent, warningThreshold,
    status,
    sessions: [{date, slotLabel, status, subjectName}]
  }]
```

> ✅ **Đã fix:** `attendance_service.dart:18` — đổi `response.data as List` → `response.data['data'] as List`. `api_client.dart` không có interceptor auto-unwrap nên phải unwrap thủ công như các service khác.

---

## 7. Màn hình 4 — Điểm số (Grades)

### Mục tiêu
Học sinh xem điểm từng môn, hiểu cơ cấu điểm, biết ĐTB học kỳ và xếp loại.

### Layout

```
[Chọn học kỳ ▼]  [Chọn năm học ▼]

┌────────────────────────────────────────┐
│  HK II – 2025-2026                     │
│  8/10 môn hoàn thành                   │
│  ████████░░  ĐTB: 7.5  Giỏi           │
└────────────────────────────────────────┘

Toán  (Hệ số 2)         7.8  Giỏi     →
Ngữ Văn  (Hệ số 1)      7.2  Khá      →
Tiếng Anh  (Hệ số 1)    8.0  Giỏi     →
Vật Lý  (Hệ số 1)       [Đang học]    →
```

### Chi tiết từng môn (GradeDetailScreen)

```
Toán · HK II – 2025-2026

7.8  Giỏi

── Điểm thường xuyên (Hệ số 1) ──────
TX1: 8.0   TX2: 7.5   TX3: 8.5

── Đánh giá định kỳ ──────────────────
Giữa kỳ (Hệ số 2):  7.0
Cuối kỳ (Hệ số 3):  8.5

── Công thức tính (TT22/2021) ─────────
ĐTBm = (8.0×1 + 7.5×1 + 8.5×1 + 7.0×2 + 8.5×3) / (3+2+3)
     = (24 + 14 + 25.5) / 8
     = 63.5 / 8 = 7.9 ≈ 7.8
```

### Xếp loại học lực

| ĐTB | Xếp loại |
|---|---|
| ≥ 8.0 | Giỏi |
| ≥ 6.5 | Khá |
| ≥ 5.0 | Trung bình |
| ≥ 3.5 | Yếu |
| < 3.5 | Kém |

### GPA học kỳ (ĐTB chung)

```
ĐTBhk = (∑ ĐTBm × hệ số môn) / (∑ hệ số môn)
```

Tính client-side trong `home_controller.dart`. Cần tất cả môn đã có điểm đủ để tính chính xác.

### Luồng dữ liệu

```
GET /me/semesters                → học kỳ + năm học (dropdown)
GET /me/grades?semesterId=X      → list môn + bảng điểm
  Response (trong ApiResponse.data): [{
    classroomSubjectId, subjectName, subjectCoefficient,
    regularScores: [8.0, 7.5, ...],
    midtermScore, finalScore,
    status: 'passed'|'warning'|'in_progress'
  }]
```

> Backend **không** trả `subjectAverage` — Flutter tính client-side từ `regularScores + midtermScore + finalScore`. Cần kiểm tra công thức trong `grade_mock_data.dart::GradeItem` có khớp với TT22/2021 không.

---

## 8. Màn hình 5 — Thông báo (Notifications)

### Mục tiêu
Học sinh nhận và đọc thông báo từ trường/giáo viên. Hỗ trợ lọc theo danh mục.

### Layout

```
Thông báo  (5 chưa đọc)       [Đánh dấu tất cả đã đọc]

[Tất cả] [Học tập] [Điểm danh] [Điểm số] [Sự kiện] [Chủ nhiệm]
           (2)       (1)          (0)       (2)        (0)

● Lịch thi cuối kỳ HK II                        [sự kiện]
  Lịch thi từ ngày 01/07/2026...                vừa rồi

● Nhắc nhở đóng học phí                          [chủ nhiệm]
  Hạn đóng học phí HK II là 30/06...             1 ngày trước

✓ Họp phụ huynh cuối năm                         [chủ nhiệm]
  Vào sáng 28/06 tại phòng A2.01...              2 ngày trước
```

### Chi tiết thông báo

```
Lịch thi cuối kỳ HK II        [sự kiện]
20:30, 16/06/2026

Lịch thi từ ngày 01/07/2026. Xem chi tiết tại văn phòng...

────────────────────────────
[Xem lịch học →]       ← deep-link nếu có relatedEntityId
```

### Danh mục thông báo

| Category (backend) | Label | Icon màu |
|---|---|---|
| `study` | Học tập | Xanh dương |
| `attendance` | Điểm danh | Xanh lá |
| `grade` | Điểm số | Tím |
| `event` | Sự kiện | Cam |
| `homeroom` | Chủ nhiệm | Đỏ |

### Luồng dữ liệu

```
GET /me/notifications?page=0&size=20&category=X
  Response (KHÔNG bọc trong ApiResponse): {
    content: [{id, title, body, category, createdAt, isRead}],
    totalPages, totalElements, unreadCount
  }

PATCH /me/notifications/{id}/read   → đánh dấu đã đọc 1 thông báo
PATCH /me/notifications/read-all    → đánh dấu tất cả đã đọc
```

> Backend `NotificationController` trả trực tiếp `NotificationPageResponse` (không qua `ApiResponse`) — khác với các endpoint khác. Flutter xử lý đúng trường hợp này.

### Tính năng thiếu
- Deep-link từ thông báo sang màn hình liên quan (cần `relatedEntityType` + `relatedEntityId` trong response)
- Push notification (FCM) khi có thông báo mới — chưa implement

---

## 9. Màn hình 6 — Liên hệ giáo viên (Contact)

### Mục tiêu
Học sinh biết ai đang dạy mình và liên hệ khi cần.

### Layout

```
Liên hệ giáo viên — Lớp 10A1

── Giáo viên chủ nhiệm ──────────────────────
👤  Nguyễn Văn A
    📚 Lịch Sử
    📞 0901 234 567     ← click → gọi điện
    ✉  nguyenvana@fpt.edu.vn

── Giáo viên bộ môn ─────────────────────────
👤  Trần Thị B      Toán
    📞 0912 345 678

👤  Lê Văn C        Tiếng Anh
    📞 0923 456 789
```

### Luồng dữ liệu

```
GET /me/teachers
  Response (trong ApiResponse.data): [{
    name, subject, phone, email, isHomeroom
  }]
```

### Hành động
- Click số điện thoại → `url_launcher: tel://0901234567`
- Click email → `url_launcher: mailto://...` (chưa implement đầy đủ)

---

## 10. Màn hình 7 — Hồ sơ (Profile)

### Layout học sinh

```
👤  Nguyễn Văn A  ← avatar khởi tạo từ tên
    Học sinh

──────────────────────────────
📋 Thông tin cá nhân  →
🔔 Cài đặt thông báo  →
🔐 Đổi mật khẩu       →
📄 Điều khoản & Chính sách  →
🚪 Đăng xuất
```

### Thông tin cá nhân (PersonalInfoScreen)

```
[Ảnh học sinh]  Nguyễn Văn A
                Học sinh · 10A1

── Thông tin học sinh ──
Mã HS:       HS001
Lớp:         10A1
Khối:        10
Campus:      FPT HCM
Ngày sinh:   10/05/2010
Giới tính:   Nam

── Liên hệ ──
SĐT:         0901 234 567
Email:       nguyenvana@student.fpt.edu.vn

── Phụ huynh ──
Họ tên:      Trần Thị B
SĐT:         0912 345 678
```

### Đổi mật khẩu

```
Mật khẩu hiện tại:  [________]
Mật khẩu mới:       [________]  (tối thiểu 8 ký tự)
Xác nhận:           [________]
                    [Đổi mật khẩu]

PATCH /me/password { currentPassword, newPassword }
```

> ✅ **Đã fix:** Backend `ChangePasswordRequest` đổi lên `@Size(min = 8)`. Flutter và backend đều validate min 8 ký tự.

### Layout phụ huynh (khác phần thông tin)

```
── Thông tin phụ huynh ──
Ngày sinh:   01/01/1975
Giới tính:   Nữ
SĐT:         0912 345 678
Email:       tranb@gmail.com

── Con đang liên kết ──
Nguyễn Văn A  |  HS001  |  10A1  |  FPT HCM
  SĐT con: 0901 234 567
```

### Luồng dữ liệu

```
GET /me/profile
  Response (trong ApiResponse.data): {
    [STUDENT]: studentCode, fullName, dateOfBirth, gender,
               phone, email, classroomName, grade, campus,
               guardianName, guardianPhone
    [PARENT]:  fullName, dateOfBirth, gender, phone, email,
               students: [{name, studentCode, classroomName, grade, campus, phone}]
  }
```

---

## 11. Luồng phụ huynh — Xem dữ liệu con

### Yêu cầu

Phụ huynh đăng nhập và xem tất cả thông tin giống học sinh nhưng của **con họ**, không phải của bản thân.

### Cơ chế (Flutter + Backend — đã hoàn chỉnh)

```dart
// AuthController: sau login PARENT → tự gọi GET /me/profile → extract children
final selectedStudentId = RxnInt();  // tự set = children.first.id

// Tất cả service đều truyền studentId khi auth.isParent
GET /me/attendance?semesterId=X&studentId=Y
GET /me/grades?semesterId=X&studentId=Y
GET /me/timetable?date=X&studentId=Y
GET /me/teachers?studentId=Y
```

### Trạng thái backend — ✅ Đã implement

`TimetableService`, `AttendanceService`, `GradeService` đều xử lý `studentId` param với parent-child verification:
- Nếu role = `PARENT`: tìm `Parent` theo username → kiểm tra `parent.children` có chứa `studentId` không → trả data của con đó
- Nếu không truyền `studentId`: tự động lấy `children.first`
- Nếu role = `STUDENT`: bỏ qua `studentId`, dùng chính student của user đó

---

## 12. Lỗi & Mâu thuẫn logic

### ✅ Bug 1 — FIXED: Attendance service dùng sai response path

**File:** `lib/.../core/services/attendance_service.dart:18`

```dart
// Trước (crash): response.data as List
// Sau (đúng):   response.data['data'] as List
```

`api_client.dart` không có interceptor auto-unwrap → mọi service phải tự unwrap `['data']`.

---

### ✅ Bug 2 — FIXED: Home controller dùng học kỳ sai

**File:** `lib/.../controllers/home_controller.dart:47`

```dart
// Trước (sai): semesters.last   → HK I (cũ nhất)
// Sau (đúng):  semesters.first  → HK II (mới nhất, DESC order)
```

---

### ✅ Bug 3 — FIXED: Phụ huynh không thể xem dữ liệu con

Backend đã implement đầy đủ parent-child verification trong `TimetableService`, `AttendanceService`, `GradeService`. Flutter `AuthController` tự load children sau login và truyền `studentId` vào mọi API call.

---

### ✅ Bug 4 — FIXED: Validation mật khẩu không nhất quán

`ChangePasswordRequest.java` đổi `@Size(min = 6)` → `@Size(min = 8)`. Cả Flutter và backend đều validate min 8 ký tự.

---

### ✅ Bug 5 — VERIFIED OK: Timetable/Attendance/Grade controllers

`timetable_controller.dart`, `attendance_controller.dart`, `grade_controller.dart` đều dùng `list.first` đúng. Chỉ `home_controller` bị bug (đã fix ở Bug 2).

---

### 🔲 Bug 6 — LOW: Notification deep-link chưa có data (chưa fix)

**File:** `lib/.../view/notification/notification_detail_screen.dart`

Button "Xem điểm danh" / "Xem bảng điểm" chỉ navigate về màn hình gốc, không tới item cụ thể vì backend `NotificationResponse` không có `relatedEntityType` + `relatedEntityId`.

**Để fix:** Thêm 2 trường nullable vào `NotificationResponse`, `Notification` entity, và Flutter `SchoolNotification` model.

---

## 13. API hiện có — Học sinh / Phụ huynh

| Endpoint | Method | Auth | Mô tả |
|---|---|---|---|
| `/me/timetable?date=X` | GET | STUDENT, PARENT | Lịch học theo ngày |
| `/me/attendance?semesterId=X` | GET | STUDENT, PARENT | Điểm danh theo học kỳ |
| `/me/grades?semesterId=X` | GET | STUDENT, PARENT | Điểm số theo học kỳ |
| `/me/teachers` | GET | STUDENT, PARENT | Danh sách giáo viên |
| `/me/notifications` | GET | ALL | Hộp thư thông báo |
| `/me/notifications/{id}/read` | PATCH | ALL | Đánh dấu đã đọc |
| `/me/profile` | GET | ALL | Hồ sơ cá nhân |
| `/me/semesters` | GET | STUDENT, PARENT | Danh sách học kỳ |
| `/me/password` | PATCH | ALL | Đổi mật khẩu |

### API đã có (không cần bổ sung thêm)

`studentId` param đã được implement ở tất cả endpoint student-facing. Parent flow hoàn chỉnh.

---

## 14. Thứ tự implement khuyến nghị

```
✅ Bước 1 — Fix bug quan trọng nhất
  → attendance_service.dart: response.data['data']  [DONE]
  → home_controller.dart: semesters.first           [DONE]

✅ Bước 2 — Verify semester ordering controllers
  → timetable/attendance/grade controllers đều dùng list.first [OK]

✅ Bước 3 — Backend: hỗ trợ parent child access
  → Đã implement đầy đủ trong TimetableService/AttendanceService/GradeService [DONE]

✅ Bước 4 — Wire màn hình với real API
  → Tất cả màn hình đã dùng real service (commit dc6b454) [DONE]

✅ Bước 5 — Validation nhất quán
  → ChangePasswordRequest min 8, Flutter min 8 [DONE]

🔲 Bước 6 — Push notification (tương lai)
  → Tích hợp FCM (Firebase Cloud Messaging)
  → Backend: gửi push khi tạo notification mới
  → Notification deep-link: thêm relatedEntityType + relatedEntityId
```

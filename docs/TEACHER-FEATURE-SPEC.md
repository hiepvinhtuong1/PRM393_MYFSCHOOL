# Đặc tả tính năng Giáo viên — MyFPTSchool

> Viết từ góc nhìn giáo viên thực tế. Căn cứ trên code hiện tại + tham chiếu production.
> Cập nhật: 2026-06-16.

---

## 1. Triết lý thiết kế

**Nguyên tắc cốt lõi:** Giao diện giáo viên phải được tổ chức theo **thời gian** và **dữ liệu của chính họ** — không phải theo loại entity (học sinh / lớp / môn) như góc nhìn của Admin.

| Admin cần | Giáo viên cần |
|---|---|
| Quản lý toàn bộ dữ liệu trường | Làm việc với lớp/môn được phân công |
| Cấu hình hệ thống | Điểm danh & nhập điểm nhanh |
| Xem báo cáo tổng hợp | Biết hôm nay dạy gì, còn việc gì chưa làm |

---

## 2. Hai vai trò giáo viên

| Role | Tên | Phạm vi |
|---|---|---|
| `TEACHER` | Giáo viên bộ môn (GVBM) | Các lớp/môn được phân công (`classroom_subjects`) |
| `HOMEROOM_TEACHER` | Giáo viên chủ nhiệm (GVCN) | Tất cả của GVBM + thêm nghiệp vụ lớp chủ nhiệm |

> Hiện tại trong code, hai role có quyền API giống nhau. Phần **GVCN-specific** được đánh dấu `[GVCN]` trong tài liệu này — là tính năng cần bổ sung về sau.

---

## 3. Kiến trúc điều hướng (Navigation)

### Sidebar giáo viên (thay thế sidebar hiện tại khi `!isAdmin`)

```
MyFPTSchool
├── [Dashboard]        Tổng quan
│
├── ── GIẢNG DẠY ──
├── [Calendar]         Lịch dạy
├── [ClipboardList]    Điểm danh
├── [BarChart3]        Điểm số
│
├── ── HỌC SINH ──
├── [Users]            Học sinh lớp tôi
│
├── [GVCN] ── LỚP CHỦ NHIỆM ──
├── [School]   [GVCN] Lớp chủ nhiệm
│
├── ── KHÁC ──
├── [Bell]             Thông báo
└── [User]             Hồ sơ của tôi
```

### Routing

| Path | Component | Ghi chú |
|---|---|---|
| `/dashboard` | `TeacherDashboard` hoặc `AdminDashboard` theo role | Branch theo `isAdmin` |
| `/my-timetable` | `MyTimetablePage` | Lịch dạy cá nhân |
| `/attendance` | `AttendancePage` (cải tiến) | Hỗ trợ `?lessonId=X` deep-link |
| `/grades` | `GradesPage` (cải tiến) | Chỉ hiện CS của mình |
| `/my-students` | `MyStudentsPage` | Học sinh các lớp mình dạy |
| `/homeroom` | `HomeroomPage` | **[GVCN]** Lớp chủ nhiệm |
| `/notifications` | `NotificationListPage` | Inbox + gửi |
| `/profile` | `ProfilePage` | Hồ sơ + đổi mật khẩu |

---

## 4. Màn hình 1 — Dashboard (Tổng quan)

### Mục tiêu
Giáo viên mở app → **biết ngay** hôm nay dạy gì và còn việc gì chưa xử lý.

### Layout

```
┌──────────────────────────────────────────────────────────┐
│  Xin chào, Nguyễn Văn A   |  Thứ Hai, 16/06/2026        │
├──────────────────────────────────────────────────────────┤
│  TIẾT HỌC HÔM NAY                                        │
│  ┌────────────────────────────────────────────────────┐  │
│  │ 08:00–09:30  Toán  |  Lớp 10A1  |  Phòng 101      │  │
│  │ ● Chưa điểm danh          [Điểm danh ngay →]       │  │
│  ├────────────────────────────────────────────────────┤  │
│  │ 10:00–11:30  Toán  |  Lớp 11B2  |  Phòng 203      │  │
│  │ ✓ Đã điểm danh  23/25 có mặt   [Xem lại →]        │  │
│  ├────────────────────────────────────────────────────┤  │
│  │ Không còn tiết nào hôm nay                         │  │
│  └────────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────┤
│  CẦN XỬ LÝ                                               │
│  ⚠  3 tiết trong tuần chưa điểm danh   [Xem →]          │
│  ⚠  Toán 10A1 — 5 học sinh chưa có điểm GK  [Nhập →]    │
├──────────────────────────────────────────────────────────┤
│  THỐNG KÊ NHANH                                          │
│  [ 4 lớp đang dạy ]  [ 12 tiết tuần này ]  [ 2 môn ]    │
└──────────────────────────────────────────────────────────┘
```

### Luồng dữ liệu

```
GET /me/lessons/today
  → [{lessonId, date, slotLabel, startTime, endTime, room,
      classroomName, subjectName, status,
      attendanceRecorded: boolean, presentCount, totalStudents}]

GET /me/classroom-subjects (không cần semesterId — lấy kỳ đang chạy)
  → dùng để tính "đang dạy X lớp, Y môn"
```

### Hành động

| Nút | Điều hướng |
|---|---|
| "Điểm danh ngay" | `/attendance?lessonId=123` |
| "Xem lại" | `/attendance?lessonId=123` (mode readonly) |
| "Xem →" (tiết chưa điểm danh) | `/attendance` với filter tuần này |
| "Nhập →" (thiếu điểm) | `/grades?csId=456` |

---

## 5. Màn hình 2 — Lịch dạy (My Timetable)

### Mục tiêu
Xem lịch dạy trong tuần, biết trạng thái từng tiết, điều hướng nhanh.

### Layout

```
[← Tuần trước]  Tuần 24/2026 · 16/06 – 22/06  [Tuần sau →]  [Hôm nay]

       Thứ Hai   Thứ Ba   Thứ Tư   Thứ Năm   Thứ Sáu
T1-2   Toán      —        Toán     —          —
       10A1               11B2
       P.101              P.203
       ✓Đã học            ●Chưa ĐD

T3-4   —         Lý       —        Lý         —
                 10A1              11C3
                 P.301             P.301
                 ✓                 ○Scheduled
```

- Click vào một tiết → side panel hoặc navigate sang điểm danh/chi tiết tiết đó
- Badge màu theo trạng thái: xanh = đã học + đã điểm danh, cam = đã học chưa điểm danh, đỏ = đã hủy, xám = scheduled

### Học kỳ selector
- Mặc định chọn học kỳ đang chạy (detect theo ngày hiện tại vs `startDate/endDate`)
- Có thể chuyển sang xem học kỳ khác

### Luồng dữ liệu

```
GET /me/classroom-subjects?semesterId=X
  → danh sách CS của giáo viên

GET /admin/classroom-subjects/{csId}/lessons
  → danh sách tiết học, filter trong tuần đang xem ở frontend
```

---

## 6. Màn hình 3 — Điểm danh

### Mục tiêu
Nhập điểm danh nhanh nhất có thể. Ưu tiên luồng "đến từ Dashboard" (lessonId sẵn rồi).

### Luồng A — Đến từ Dashboard (deep-link)

```
/attendance?lessonId=123
  → Tự động load tiết 123
  → Hiển thị: "Toán 10A1 · 16/06/2026 · Tiết 1-2 · Phòng 101"
  → Danh sách học sinh với trạng thái
  → [Lưu điểm danh]
```

Không cần chọn gì — vào thẳng bảng học sinh luôn.

### Luồng B — Vào trang Điểm danh trực tiếp

```
Chọn Môn/Lớp  →  Chọn Tiết học
(chỉ 2 bước, không cần chọn học kỳ trước)
```

- Dropdown "Môn/Lớp": lấy từ `/me/classroom-subjects` → chỉ hiện lớp của giáo viên mình
- Dropdown "Tiết học": lọc bỏ tiết đã hủy, sắp xếp mới nhất lên đầu, highlight tiết hôm nay

### Bảng điểm danh

| STT | Mã HS | Họ tên | Trạng thái | Ghi chú |
|---|---|---|---|---|
| 1 | HS001 | Nguyễn Văn A | [Có mặt ▼] | |
| 2 | HS002 | Trần Thị B | [Vắng có phép ▼] | Đơn đã nộp |

- Trạng thái: Có mặt / Đi muộn / Vắng có phép / Vắng không phép
- Mặc định khi chưa nhập: để trống (không tự điền "Có mặt" để tránh nhập nhầm)
- Nút "Có mặt tất cả" — fill nhanh toàn bộ, sau đó sửa riêng ai vắng
- Thống kê realtime: Có mặt X | Vắng Y | Chưa ghi Z
- [Lưu điểm danh] → gọi `POST /admin/lessons/{id}/attendance`

### Luồng dữ liệu

```
GET /me/classroom-subjects           → dropdown Môn/Lớp
GET /admin/classroom-subjects/{id}/lessons  → dropdown Tiết học
GET /admin/lessons/{id}/attendance   → bảng học sinh + trạng thái hiện tại
POST /admin/lessons/{id}/attendance  → lưu
```

---

## 7. Màn hình 4 — Điểm số

### Mục tiêu
Nhập điểm cho các lớp được phân công. Chỉ hiện dữ liệu của giáo viên mình.

### Layout

```
[Chọn Môn/Lớp ▼]  ← chỉ hiện CS của giáo viên mình

Toán · Lớp 10A1 · HK1 2025-2026 · GV: Nguyễn Văn A
                              [Xuất Excel]  [Lưu điểm]

┌──────────┬─────────────┬──────┬──────┬──────┬──────────┐
│ Mã HS    │ Họ tên      │ TX1  │ TX2  │ GK   │ CK       │
├──────────┼─────────────┼──────┼──────┼──────┼──────────┤
│ HS001    │ Nguyễn ...  │ 8.5  │ 7.0  │[9.0] │          │
│ HS002    │ Trần ...    │ 6.0  │      │[7.5] │          │
└──────────┴─────────────┴──────┴──────┴──────┴──────────┘

[ ] ô đang chỉnh sửa, màu highlight
```

- Không cần chọn học kỳ trước — dropdown "Môn/Lớp" tự include tên học kỳ
- Ô điểm click để edit, nhấn Tab/Enter để sang ô kế tiếp
- Số liệu thay đổi → nút "Lưu điểm" sáng lên (disabled nếu không có thay đổi)
- Xuất Excel → `GET /admin/classroom-subjects/{id}/grades/export`

### Luồng dữ liệu

```
GET /me/classroom-subjects                       → dropdown
GET /admin/classroom-subjects/{id}/grades        → bảng điểm
POST /admin/classroom-subjects/{id}/grades       → bulk upsert
GET /admin/classroom-subjects/{id}/grades/export → Excel
```

---

## 8. Màn hình 5 — Học sinh lớp tôi

### Mục tiêu
Giáo viên xem học sinh của các lớp mình đang dạy — không phải toàn bộ trường.

### Layout

```
Lớp tôi đang dạy (HK1 2025-2026)

[Toán · 10A1 · 35 HS]  [Toán · 11B2 · 33 HS]  [Toán · 11C3 · 32 HS]
   ↑ click để expand

── Lớp 10A1 ── 35 học sinh ────────────────────────
[Tìm tên...]
Mã HS   | Họ tên          | Ngày sinh  | Giới tính | SĐT
HS001   | Nguyễn Văn A    | 10/05/2010 | Nam       | ...
HS002   | Trần Thị B      | ...        | Nữ        | ...
```

- Không có nút Thêm / Sửa / Khóa (read-only hoàn toàn)
- Có thể xem được SĐT phụ huynh kèm nếu cần (tùy thiết kế)
- Tab để switch giữa các lớp đang dạy

### Luồng dữ liệu

```
GET /me/classroom-subjects → list CS → extract unique classroomIds
GET /admin/classrooms/{id}/students → danh sách HS từng lớp
```

---

## 9. Màn hình 6 — Lớp chủ nhiệm `[GVCN]`

> **Tính năng tương lai** — chỉ hiển thị với `role === 'HOMEROOM_TEACHER'`

### Mục tiêu
GVCN quản lý lớp chủ nhiệm: xem tổng quan, nhập hạnh kiểm, xử lý đơn nghỉ.

### Tab 1 — Tổng quan lớp

```
Lớp chủ nhiệm: 10A1  |  Năm học: 2025-2026
35 học sinh  |  GVCN: Nguyễn Văn A

[Danh sách HS]  [Hạnh kiểm]  [Đơn nghỉ]
```

### Tab 2 — Hạnh kiểm (Conduct)

- Nhập hạnh kiểm từng học sinh cuối học kỳ: Tốt / Khá / Trung bình / Yếu
- Ghi chú nhận xét
- Lưu nháp → Nộp (chuyển sang BGH duyệt)

### Tab 3 — Đơn nghỉ học (Leave Requests)

```
● Chờ duyệt (3)
─────────────────────────────────────
Nguyễn Văn A | 18/06/2026 | Tiết 1-2 | Lý do: Khám bệnh
  [Duyệt ✓]  [Từ chối ✗]

Trần Thị B | 20/06/2026 | Cả ngày | Lý do: Việc gia đình
  [Duyệt ✓]  [Từ chối ✗]
```

- Từ chối bắt buộc nhập lý do
- Đơn được duyệt → tự động gắn `EXCUSED_ABSENT` khi điểm danh tiết đó

---

## 10. Màn hình 7 — Thông báo

### Hộp thư đến (Inbox)
- Nhận thông báo từ Admin / hệ thống
- Đánh dấu đã đọc khi click
- Badge đỏ hiển thị số chưa đọc ở sidebar

### Đã gửi
- Lịch sử thông báo giáo viên đã gửi đi
- Hiển thị: tiêu đề, phạm vi, số người nhận, thời gian

### Soạn thông báo
- **Phạm vi gửi:**
  - Cả lớp → dropdown chỉ hiện lớp giáo viên đang dạy (không phải toàn trường)
  - Toàn trường
  - Cá nhân (nhập userId)
- Danh mục: Điểm danh / Điểm số / Chủ nhiệm / Học tập / Sự kiện
- Tiêu đề + Nội dung

> **Bug hiện tại cần sửa:** dropdown "Cả lớp" đang load tất cả lớp trong trường (`GET /admin/classrooms`). Với giáo viên, phải filter chỉ hiện lớp giáo viên đang dạy.

---

## 11. Màn hình 8 — Hồ sơ của tôi

### Thông tin hiển thị
- Họ tên, email, mã giáo viên
- Role: Giáo viên bộ môn / Giáo viên chủ nhiệm
- Lớp đang dạy (học kỳ hiện tại)

### Đổi mật khẩu
```
Mật khẩu hiện tại: [________]
Mật khẩu mới:     [________]
Xác nhận:         [________]
                  [Đổi mật khẩu]
```
`PATCH /me/password { currentPassword, newPassword }`

---

## 12. API cần bổ sung ở Backend

Hiện tại thiếu 2 endpoint để teacher-centric UX hoạt động:

### 12.1 `GET /me/classroom-subjects`

```
Query: semesterId? (nếu không truyền → tất cả hoặc kỳ đang chạy)
Response: [{
  id, classroomId, classroomName, subjectId, subjectName,
  semesterId, semesterName, academicYear,
  totalLessons, completedLessons
}]
```

**Logic backend:**
```java
// Lấy teacher theo account.username = authentication.getName()
// Trả classroom_subjects WHERE teacher_id = teacher.id
// Filter thêm semesterId nếu có
```

### 12.2 `GET /me/lessons/today`

```
Response: [{
  lessonId, classroomSubjectId,
  classroomName, subjectName, roomCode,
  lessonDate, slotLabel, startTime, endTime,
  status,
  attendanceRecorded: boolean,
  presentCount: int,
  totalStudents: int
}]
```

**Logic backend:**
```java
// Teacher's classroom_subjects → lessons WHERE lesson_date = today
// LEFT JOIN attendance_records để tính presentCount
// attendanceRecorded = exists any attendance_record for this lesson
```

---

## 13. Tóm tắt trạng thái implementation

### Đã có (chỉ cần refactor UX)

| Tính năng | Trạng thái | Việc cần làm |
|---|---|---|
| Điểm danh nhập | ✅ API có | Thêm deep-link `?lessonId`, bỏ bước chọn học kỳ |
| Điểm số nhập | ✅ API có | Dùng `/me/classroom-subjects` thay vì all |
| TKB xem | ✅ API có | Filter theo giáo viên |
| Thông báo gửi/nhận | ✅ API có | Sửa dropdown lớp → chỉ lớp mình |
| Đổi mật khẩu | ✅ API có | Tạo ProfilePage mới |

### Cần thêm API

| Endpoint | Dùng cho |
|---|---|
| `GET /me/classroom-subjects` | Tất cả dropdown giáo viên |
| `GET /me/lessons/today` | Dashboard "tiết hôm nay" |

### Cần làm mới hoàn toàn

| Tính năng | Độ ưu tiên |
|---|---|
| TeacherDashboard (tiết hôm nay, alerts) | 🔴 Cao |
| Sidebar tách ADMIN / TEACHER | 🔴 Cao |
| MyStudentsPage (học sinh lớp mình) | 🟡 Trung bình |
| MyTimetablePage (lịch theo tuần) | 🟡 Trung bình |
| ProfilePage | 🟢 Thấp |
| HomeroomPage (GVCN) | ⬜ Tương lai |

### Bug cần fix ngay

| Bug | Ảnh hưởng |
|---|---|
| `/students/new` không trong AdminRoute | Giáo viên vào được form tạo HS |
| StudentListPage không ẩn nút admin | Giáo viên thấy Thêm/Sửa/Import/Khóa |
| TimetablePage nút Xóa không check isAdmin | Giáo viên click Xóa → 403 thầm lặng |
| NotificationComposePage dropdown lớp = toàn trường | Giáo viên thấy 30 lớp, không phải lớp mình |

---

## 14. Thứ tự implement khuyến nghị

```
Bước 1 — Fix bug (không cần backend)
  → Ẩn nút admin trong StudentListPage
  → Đưa /students/new, /students/:id/edit vào AdminRoute
  → Ẩn nút Xóa trong TimetablePage khi !isAdmin

Bước 2 — Backend: 2 endpoint mới
  → GET /me/classroom-subjects
  → GET /me/lessons/today

Bước 3 — Frontend: TeacherDashboard
  → Tiết hôm nay với link điểm danh
  → Alert chưa điểm danh / thiếu điểm

Bước 4 — Frontend: cải tiến 3 trang hiện có
  → AttendancePage: bỏ bước chọn học kỳ, thêm deep-link ?lessonId
  → GradesPage: dùng /me/classroom-subjects
  → NotificationComposePage: lọc lớp theo giáo viên

Bước 5 — Frontend: trang mới
  → MyStudentsPage
  → MyTimetablePage (lịch theo tuần)
  → ProfilePage

Bước 6 — Sidebar tách ADMIN / TEACHER
  → navItems khác nhau theo isAdmin
```

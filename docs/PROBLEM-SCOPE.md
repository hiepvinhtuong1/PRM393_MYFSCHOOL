# Quy mô bài toán: MyFPTSchool Clone

Ngày phân tích: 11/06/2026  
Nguồn: mock data files + screen map + yêu cầu mở rộng web admin

---

## 1. Bài toán tổng thể

Hệ thống gồm **hai nền tảng** dùng chung một database:

| Nền tảng | Mục đích | Người dùng |
|---|---|---|
| **Mobile App** (Flutter) | Xem thông tin, nhận thông báo | Học sinh, Phụ huynh |
| **Web Admin** (React / Next.js) | Quản lý và cập nhật dữ liệu | Giáo viên, Ban giám hiệu |

Mobile chỉ **đọc**. Web chủ yếu **ghi** — mọi dữ liệu học sinh nhìn thấy trên app đều được tạo ra từ web.

---

## 2. Actors đầy đủ

### 2.1 Mobile — phía người học

| Actor | Mô tả | Quyền |
|---|---|---|
| **Học sinh** | Xem lịch, điểm, điểm danh, thông báo của chính mình | Chỉ đọc dữ liệu cá nhân |
| **Phụ huynh** | Giám sát thông tin học tập của con | Chỉ đọc dữ liệu con liên kết |

### 2.2 Web — phía nhà trường

| Actor | Mô tả | Phạm vi quản lý |
|---|---|---|
| **Giáo viên bộ môn** | Nhập điểm, xác nhận điểm danh cho môn mình dạy | Môn học + lớp được phân công |
| **GVCN** (Giáo viên chủ nhiệm) | Quản lý lớp, gửi thông báo cho phụ huynh, xem toàn bộ thông tin học sinh lớp mình | Toàn bộ học sinh trong lớp chủ nhiệm |
| **Ban giám hiệu / Admin** | Quản lý toàn bộ hệ thống: học sinh, giáo viên, lớp, thời khóa biểu, năm học | Toàn trường |

> **Quan hệ vai trò**: một người có thể vừa là giáo viên bộ môn vừa là GVCN (như Nguyễn Thị Mai Loan trong mock data dạy Ngữ Văn và là GVCN lớp 10A1).

---

## 3. Phân chia chức năng theo nền tảng

### 3.1 Mobile App — những gì học sinh/phụ huynh làm được

| Tính năng | Học sinh | Phụ huynh |
|---|---|---|
| Xem thời khóa biểu ngày/tuần | ✓ | ✓ (của con) |
| Xem điểm danh + cảnh báo ngưỡng | ✓ | ✓ (của con) |
| Xem bảng điểm + chi tiết đầu điểm | ✓ | ✓ (của con) |
| Nhận và đọc thông báo | ✓ | ✓ |
| Xem liên hệ giáo viên / nhà trường | ✓ | ✓ |
| Xem hồ sơ cá nhân | ✓ | ✓ (hồ sơ bản thân + hồ sơ con) |
| Gọi điện thoại giáo viên | ✓ | ✓ |
| Chọn học sinh liên kết (nhiều con) | — | ✓ |

### 3.2 Web Admin — những gì nhà trường làm được

| Tính năng | GV bộ môn | GVCN | Admin |
|---|---|---|---|
| **Học vụ** | | | |
| Quản lý năm học / học kỳ | — | — | ✓ |
| Quản lý lớp học | — | Xem | ✓ |
| Phân công giảng dạy (GV ↔ môn ↔ lớp) | — | — | ✓ |
| Quản lý học sinh (thêm/sửa/khoá) | — | Xem lớp mình | ✓ |
| Quản lý giáo viên | — | — | ✓ |
| Liên kết phụ huynh – học sinh | — | — | ✓ |
| **Thời khóa biểu** | | | |
| Tạo/sửa thời khóa biểu | — | — | ✓ |
| Nhập lịch học bù / đổi phòng | — | — | ✓ |
| **Điểm danh** | | | |
| Nhập / xác nhận điểm danh từng tiết | ✓ (môn mình) | ✓ (lớp mình) | ✓ |
| Cập nhật lý do vắng (có phép/không phép) | ✓ | ✓ | ✓ |
| Xem báo cáo điểm danh toàn lớp | — | ✓ | ✓ |
| **Điểm số** | | | |
| Nhập / sửa điểm TX, ĐGKK, ĐCK | ✓ (môn mình) | — | ✓ |
| Chốt điểm (khoá chỉnh sửa) | ✓ | — | ✓ |
| Xuất bảng điểm | — | ✓ | ✓ |
| **Thông báo** | | | |
| Gửi thông báo cho lớp / cá nhân | — | ✓ | ✓ |
| Gửi thông báo toàn trường | — | — | ✓ |
| Tạo thông báo tự động (cảnh báo vắng, điểm mới) | — | — | ✓ (cấu hình) |

---

## 4. Cấu trúc học thuật

### 4.1 Tổ chức trường

```
Campus (Cơ sở)
 └─ Năm học (2025-2026, ...)
     └─ Học kỳ (HK I / HK II)
         └─ Lớp (10A1, 10A2, ...)  ← GVCN
             └─ Học sinh (35–40 em/lớp)
```

**Quyết định Phase 1:** Lớp học là **dữ liệu cố định**, seed 1 lần khi deploy, không có API tạo/xóa lớp.

| Khối | Danh sách lớp |
|---|---|
| Khối 10 | 10A1, 10A2, ..., 10A10 |
| Khối 11 | 11A1, 11A2, ..., 11A10 |
| Khối 12 | 12A1, 12A2, ..., 12A10 |

**Tổng: 30 lớp.** Admin chỉ cần `GET /admin/classrooms` để chọn lớp khi thêm học sinh, không cần POST/PUT/DELETE classroom.

### 4.2 Phân công giảng dạy

```
Giáo viên
 └─ Phân công (classroom_subjects)
     └─ Môn × Lớp × Học kỳ
         └─ Tiết học cụ thể (lessons)
```

### 4.3 Môn học Phase 1

8 môn rút ra từ mock data (lớp 10A1, HK II 2025-2026):

| Môn | Tiết/HK | Tiết/tuần |
|---|---|---|
| Toán | 70 | 4 |
| Ngữ Văn | 70 | 3–4 |
| Tiếng Anh | 52 | 3 |
| Vật Lý | 52 | 2–3 |
| Hóa Học | 52 | 2–3 |
| Sinh Học | 35 | 2 |
| Lịch Sử | 35 | 2 |
| Địa Lý | 35 | 2 |

**Tổng: ~401 tiết/HK/học sinh**, ~22 tiết/tuần, 18 tuần/HK.

### 4.4 Lịch tiết chuẩn THPT

| Tiết | Giờ bắt đầu | Giờ kết thúc |
|---|---|---|
| 1 | 07:00 | 07:45 |
| 2 | 07:50 | 08:35 |
| 3 | 08:45 | 09:30 |
| 4 | 09:35 | 10:20 |
| 5 | 10:30 | 11:15 |
| 6 | 11:20 | 12:05 |
| 7 | 13:00 | 13:45 |
| 8 | 13:50 | 14:35 |
| 9 | 14:45 | 15:30 |
| 10 | 15:35 | 16:20 |

---

## 5. Nghiệp vụ điểm danh

### 5.1 Trạng thái mỗi lần điểm danh

| Trạng thái | Ghi chú | Tính vào ngưỡng |
|---|---|---|
| Có mặt | `present` | Không |
| Đi muộn | `late` | Tùy quy định (0.5 hoặc 1) |
| Vắng có phép | `excused_absent` | Có |
| Vắng không phép | `unexcused_absent` | Có (nặng hơn) |

### 5.2 Ngưỡng cảnh báo

```
warningThreshold = totalSessions × 20%
```

Ví dụ: Toán 70 tiết → ngưỡng 14; Sinh Học 35 tiết → ngưỡng 7.

### 5.3 Mức cảnh báo

| Mức | Điều kiện | Màu |
|---|---|---|
| An toàn | `totalAbsent < threshold × 0.5` | Xanh lá |
| Cần chú ý | `threshold × 0.5 ≤ totalAbsent < threshold × 0.8` | Vàng |
| Nguy hiểm | `threshold × 0.8 ≤ totalAbsent < threshold` | Đỏ |
| Vượt ngưỡng | `totalAbsent ≥ threshold` | Đỏ đậm |

### 5.4 Luồng điểm danh (Web → Mobile)

```
GV mở Web → chọn tiết học → nhập trạng thái từng học sinh
→ lưu attendance_records → hệ thống tính lại summary
→ nếu vượt ngưỡng → tạo notification tự động → app học sinh/phụ huynh nhận
```

---

## 6. Nghiệp vụ điểm số

### 6.1 Cấu trúc điểm (THPT Việt Nam)

| Đầu điểm | Hệ số | Số lần/HK |
|---|---|---|
| Điểm thường xuyên (TX1–TX3) | ×1 | 3 |
| Đánh giá giữa kỳ (ĐGKK) | ×2 | 1 |
| Điểm cuối kỳ (ĐCK) | ×3 | 1 |

### 6.2 Công thức điểm tổng kết

```
ĐTK = (TX1 + TX2 + TX3 + ĐGKK×2 + ĐCK×3) / 8
```

### 6.3 Thang xếp loại

| Điểm | Xếp loại |
|---|---|
| ≥ 8.0 | Giỏi |
| ≥ 6.5 | Khá |
| ≥ 5.0 | Trung bình |
| < 5.0 | Yếu / Kém |

### 6.4 Luồng nhập điểm (Web → Mobile)

```
GV mở Web → chọn môn + lớp + HK → nhập điểm TX / ĐGKK / ĐCK
→ lưu grade_records → hệ thống tính ĐTK + GPA
→ tạo notification "điểm TX mới" → app học sinh/phụ huynh nhận
→ GV "chốt điểm" → khoá chỉnh sửa, hiển thị trạng thái đã chốt trên app
```

---

## 7. Nghiệp vụ thông báo

### 7.1 Danh mục

| Danh mục | Nguồn tạo | Màn hình đích (mobile) |
|---|---|---|
| `attendance` | Tự động từ hệ thống | Attendance |
| `grade` | Tự động khi GV nhập điểm | Grade Detail |
| `homeroom` | GVCN soạn thủ công trên Web | — |
| `study` | Admin / GVCN soạn trên Web | Timetable |
| `event` | Admin soạn trên Web | — |

### 7.2 Phạm vi gửi

| Phạm vi | Ai gửi |
|---|---|
| Cá nhân (1 học sinh / phụ huynh) | Hệ thống tự động |
| Lớp học (toàn bộ học sinh + phụ huynh) | GVCN, Admin |
| Toàn trường | Admin |

---

## 8. Thực thể và bảng database

### 8.1 Nhóm Identity & Auth (dùng chung 2 nền tảng)

| Bảng | Mô tả |
|---|---|
| `users` | Tài khoản đăng nhập, role: `student / parent / teacher / homeroom_teacher / admin` |
| `user_sessions` | Token, expiry, platform (mobile/web) |
| `students` | Hồ sơ học sinh (mã HS, lớp, cơ sở, dob, gender, phone, email) |
| `parents` | Hồ sơ phụ huynh (mã PH, dob, gender, phone, email) |
| `parent_students` | Liên kết phụ huynh – học sinh (n-n, nhiều con / nhiều phụ huynh) |
| `teachers` | Hồ sơ giáo viên (tên, phone, email) |

### 8.2 Nhóm Cấu trúc học thuật

| Bảng | Mô tả | Ai quản lý |
|---|---|---|
| `campuses` | Cơ sở trường | Admin |
| `academic_years` | Năm học | Admin |
| `semesters` | Học kỳ (thuộc năm học) | Admin |
| `classrooms` | Lớp học (thuộc cơ sở, có GVCN) | Admin |
| `subjects` | Môn học (tên, màu, tổng tiết/HK) | Admin |
| `classroom_subjects` | Phân công: teacher + subject + classroom + semester | Admin |

### 8.3 Nhóm Thời khóa biểu

| Bảng | Mô tả | Ai quản lý |
|---|---|---|
| `time_slots` | 10 tiết chuẩn (startTime, endTime) | Admin (cấu hình 1 lần) |
| `rooms` | Phòng học (mã phòng, tòa nhà) | Admin |
| `lessons` | Tiết học: classroom_subject + date + time_slot + room + status | Admin |

### 8.4 Nhóm Điểm danh

| Bảng | Mô tả | Ai ghi |
|---|---|---|
| `attendance_records` | student + lesson + status + note | GV bộ môn, GVCN, Admin |

> `attendance_summary` là **computed view** — không cần bảng riêng.

### 8.5 Nhóm Điểm số

| Bảng | Mô tả | Ai ghi |
|---|---|---|
| `score_components` | Cấu hình đầu điểm: loại, hệ số, thứ tự | Admin (cấu hình) |
| `grade_records` | student + classroom_subject + component + value + is_locked | GV bộ môn, Admin |

> `grade_summary` (ĐTK, GPA) là **computed view**.

### 8.6 Nhóm Thông báo

| Bảng | Mô tả | Ai ghi |
|---|---|---|
| `notifications` | title, body, category, target_type, created_by | GVCN, Admin, Hệ thống |
| `notification_recipients` | notification + user + is_read | Hệ thống |

### 8.7 Tổng số bảng Phase 1

| Nhóm | Số bảng |
|---|---|
| Identity & Auth | 6 |
| Cấu trúc học thuật | 6 |
| Thời khóa biểu | 3 |
| Điểm danh | 1 |
| Điểm số | 2 |
| Thông báo | 2 |
| **Tổng** | **20 bảng** |

---

## 9. Quy mô dữ liệu (1 trường, 3 khối)

| Thực thể | Ước tính |
|---|---|
| Học sinh | ~1.000 |
| Phụ huynh | ~1.500 (một học sinh có thể 2 phụ huynh) |
| Giáo viên | ~60–80 |
| Lớp | **30 lớp cố định** (10 lớp × 3 khối: 10A1–10A10, 11A1–11A10, 12A1–12A10) |
| Môn học | 10–15 |
| Tiết học / HK | ~400 tiết × 30 lớp = ~12.000 lessons |
| Bản ghi điểm danh / HK | ~12.000 lessons × 38 học sinh = ~456.000 |
| Bản ghi điểm / HK | 1.000 hs × 8 môn × 5 đầu điểm = ~40.000 |
| Thông báo / tháng | ~100–500 |

> Với quy mô này, **PostgreSQL** là lựa chọn phù hợp cho production. **SQLite** chỉ dùng cho local dev/demo.

---

## 10. Kiến trúc hệ thống tổng quan

```
┌─────────────────┐     ┌─────────────────┐
│   Mobile App    │     │    Web Admin    │
│  (Flutter)      │     │  (React/Next)   │
│                 │     │                 │
│  Học sinh       │     │  Giáo viên      │
│  Phụ huynh      │     │  GVCN           │
│                 │     │  Admin          │
└────────┬────────┘     └────────┬────────┘
         │  READ only            │  READ + WRITE
         │                       │
         └──────────┬────────────┘
                    │
            ┌───────▼────────┐
            │   REST API /   │
            │   GraphQL      │
            │   (Backend)    │
            └───────┬────────┘
                    │
            ┌───────▼────────┐
            │   PostgreSQL   │
            │   (20 bảng)    │
            └────────────────┘
```

---

## 11. Phân chia phát triển theo phase

### Phase 1 — MVP học tập (có mock data)

**Mobile:** Đăng nhập, Home, Timetable, Attendance, Grades, Notifications, Profile, Contact  
**Web:** Đăng nhập admin, quản lý học sinh/lớp/giáo viên, nhập điểm danh, nhập điểm, gửi thông báo

### Phase 2 — Nội dung và hoạt động

**Mobile:** Tin tức, Hoạt động ngoại khóa, Câu lạc bộ  
**Web:** CMS tin tức, quản lý hoạt động/CLB, đăng ký

### Phase 3 — Sinh hoạt và quản trị

**Mobile:** Khen thưởng/kỷ luật, Ký túc xá, Cài đặt thông báo  
**Web:** Quản lý kỷ luật/khen thưởng, quản lý ký túc xá, báo cáo tổng hợp

> **DB note:** Phase 3 cần thêm bảng `student_enrollments (student_id, classroom_id, start_date, end_date)` để hỗ trợ tính năng hồ sơ học bạ theo năm. Hiện tại `students.classroom_id` chỉ lưu lớp hiện tại — lịch sử vẫn suy ra được qua `attendance_records → classroom_subjects` nhưng không có bảng rõ ràng. Xem chi tiết trong `schema.sql` phần BACKLOG.

### Phase 4 — Hoàn thiện

**Mobile:** Offline cache, push notification, đa ngôn ngữ  
**Web:** Export Excel/PDF, dashboard báo cáo, phân quyền chi tiết

---

## 12. Quyết định đã chốt

1. **Backend: Java Spring Boot + RESTful API** ✅ Stack: Spring Web, Spring Security + JWT (5 role), Spring Data JPA, Flyway, Springdoc OpenAPI.
2. **`attendance_summary` → computed trong Service** ✅ — tính từ `attendance_records`, không cần view/bảng riêng.
3. **Một phụ huynh liên kết nhiều học sinh** ✅ — `parent_students` n-n. UI Phase 1 hiển thị 1 con.
4. **`grade_records` không có `is_locked`** ✅ — giáo viên sửa điểm bất cứ lúc nào.
5. **Notifications → Fanout-on-write** ✅ — mỗi người nhận là 1 row `notification_recipients`.
6. **Lớp học cố định 30 lớp** ✅ — seed 1 lần khi deploy, không có API tạo/xóa lớp. Admin chỉ `GET /admin/classrooms`.

---

## 13. Business Validation Rules

### Auth
| Field | Rule |
|---|---|
| `username` | 4–50 ký tự, chỉ chữ thường + số + `_`, không khoảng trắng |
| `password` | 6–100 ký tự |

### Học sinh
| Field | Rule |
|---|---|
| `studentCode` | 3–20 ký tự, chữ hoa + số, không ký tự đặc biệt |
| `fullName` | 2–100 ký tự |
| `dateOfBirth` | `dd/MM/yyyy`, tuổi từ 14–20 (THPT) |
| `gender` | `"Nam"` hoặc `"Nữ"` |
| `phone` | 10 số, regex `^0[3-9]\d{8}$` |
| `email` | Format email hợp lệ |
| `password` | Nếu cung cấp: 6–100 ký tự |

### Giáo viên
| Field | Rule |
|---|---|
| `fullName` | 2–100 ký tự |
| `email` | Format email hợp lệ, unique trong bảng teachers |
| `phone` | `^0[3-9]\d{8}$` (nếu có) |
| `dateOfBirth` | ≥ 22 tuổi (nếu có) |

### Phụ huynh
| Field | Rule |
|---|---|
| `fullName` | 2–100 ký tự |
| `phone` | `^0[3-9]\d{8}$` |
| `dateOfBirth` | ≥ 18 tuổi (nếu có) |
| Liên kết | Không liên kết cùng 1 học sinh 2 lần |

### Phân công giảng dạy
| Rule |
|---|
| Unique: cùng GV + môn + lớp + học kỳ không được phân công 2 lần |
| Tất cả FK phải tồn tại |

### Tiết học
| Rule |
|---|
| `lessonDate` trong khoảng `semester.startDate` – `semester.endDate` |
| `startSlotId ≤ endSlotId` |
| Không trùng slot cho cùng lớp trong cùng ngày |

### Điểm danh
| Rule |
|---|
| Học sinh phải thuộc lớp của tiết học |
| Không điểm danh tiết tương lai |

### Điểm số
| Rule |
|---|
| `0.0 ≤ score ≤ 10.0`, bội số của `0.25` |
| Học sinh phải thuộc lớp của classroom_subject |
| TEACHER chỉ nhập điểm môn mình dạy |

### Thông báo
| Field | Rule |
|---|---|
| `title` | 1–200 ký tự |
| `body` | 1–5000 ký tự |
| `targetId` | Tương ứng với `target_type`: individual→userId, classroom→classroomId, all→null |

### Import Excel
| Rule |
|---|
| Chỉ chấp nhận `.xlsx` |
| Tối đa 500 dòng / lần |
| Tối đa 10MB |

---

## 14. Phạm vi Admin API (Phase 1)

| Nhóm | Endpoint | Ai dùng |
|---|---|---|
| **Học vụ (read-only)** | `GET /admin/classrooms` | Admin, GVCN |
| | `GET /admin/classrooms/{id}/students` | Admin, GVCN |
| | `GET /admin/subjects` | Admin, GV |
| **Học sinh** | `POST /admin/students` | Admin |
| | `PUT /admin/students/{id}` | Admin |
| | `GET /admin/students/{id}` | Admin, GVCN |
| **Giáo viên** | `POST /admin/teachers` | Admin |
| | `PUT /admin/teachers/{id}` | Admin |
| | `GET /admin/teachers` | Admin |
| **Phân công** | `POST /admin/classroom-subjects` | Admin |
| | `GET /admin/classroom-subjects?classroomId=&semesterId=` | Admin, GVCN |
| **Điểm danh** | `POST /admin/lessons/{id}/attendance` | GV, GVCN, Admin |
| | `GET /admin/lessons/{id}/attendance` | GV, GVCN, Admin |
| **Điểm số** | `POST /admin/grades` | GV, Admin |
| | `PUT /admin/grades/{id}` | GV, Admin |
| | `GET /admin/classroom-subjects/{id}/grades` | GV, GVCN, Admin |
| **Thông báo** | `POST /admin/notifications` | GVCN, Admin |

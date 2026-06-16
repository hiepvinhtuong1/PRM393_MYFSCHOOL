# Nghiệp vụ Giáo viên — MyFPTSchool (thực tế)

> Mô tả dựa trên code đang chạy. Cập nhật: 2026-06-16.
> Xem `docs/TEACHER-BUSINESS.md` để tham khảo mô hình từ dự án khác (production-grade).

---

## 1. Hai role giáo viên trong hệ thống

| Spring Role | Tên gọi | Ghi chú |
|---|---|---|
| `TEACHER` | Giáo viên bộ môn (GVBM) | Dạy môn |
| `HOMEROOM_TEACHER` | Giáo viên chủ nhiệm (GVCN) | Phụ trách lớp |

**Thực tế trong code:** cả hai role có **quyền giống hệt nhau**. Mọi `@PreAuthorize` đều dùng `hasAnyRole('ADMIN', 'TEACHER', 'HOMEROOM_TEACHER')`. Không có phân biệt nghiệp vụ ở backend giữa TEACHER và HOMEROOM_TEACHER.

Ở frontend, `isAdmin` được tính bằng `user?.role === 'ADMIN'` — cả hai role giáo viên đều là `isAdmin = false` và bị `AdminRoute` redirect về `/dashboard` nếu cố vào route admin.

---

## 2. Giao diện giáo viên (Web App)

Giáo viên dùng web app (không có mobile app — Flutter chỉ dành cho STUDENT và PARENT).

### Sidebar hiển thị cho giáo viên

| Mục | Route | Ghi chú |
|---|---|---|
| Dashboard | `/dashboard` | Thống kê tổng quan |
| Học sinh | `/students` | Xem danh sách học sinh |
| Lớp học | `/classrooms` | Xem danh sách lớp |
| Thời khóa biểu | `/timetable` | Xem + quản lý tiết học |
| Điểm danh | `/attendance` | Nhập điểm danh theo tiết |
| Điểm số | `/grades` | Nhập điểm theo môn/lớp |
| Thông báo | `/notifications`, `/notifications/new` | Xem + soạn thông báo |

### Sidebar ẩn (adminOnly: true — giáo viên không thấy)

Phụ huynh, Giáo viên, Phân công, Năm học, Học kỳ, Môn học, Phòng học.

### AdminRoute guard

Các route sau bị bảo vệ bằng `AdminRoute` — giáo viên bị redirect về `/dashboard`:

```
/teachers, /parents, /assignments, /semesters, /subjects, /academic-years, /rooms
```

---

## 3. Quyền API của giáo viên

### Giáo viên được phép (ADMIN + TEACHER + HOMEROOM_TEACHER)

| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/v1/me` | Thông tin tài khoản |
| PATCH | `/api/v1/me/password` | Đổi mật khẩu |
| GET | `/api/v1/admin/academic-years` | Danh sách năm học |
| GET | `/api/v1/admin/semesters` | Danh sách học kỳ |
| GET | `/api/v1/admin/subjects` | Danh sách môn học |
| GET | `/api/v1/admin/classrooms` | Danh sách lớp học |
| GET | `/api/v1/admin/students` | Danh sách học sinh |
| GET | `/api/v1/admin/teachers` | Danh sách giáo viên |
| GET | `/api/v1/admin/classroom-subjects` | Danh sách phân công (lọc theo classroomId, semesterId) |
| GET | `/api/v1/admin/classroom-subjects/{id}/lessons` | Tiết học của phân công |
| **POST** | `/api/v1/admin/classroom-subjects/{id}/lessons` | **Tạo tiết học mới** |
| **PATCH** | `/api/v1/admin/lessons/{id}` | **Cập nhật trạng thái/phòng/ghi chú tiết học** |
| GET | `/api/v1/admin/rooms` | Danh sách phòng học |
| GET | `/api/v1/admin/time-slots` | Danh sách tiết trong ngày |
| GET | `/api/v1/admin/lessons/{id}/attendance` | Xem điểm danh tiết học |
| **POST** | `/api/v1/admin/lessons/{id}/attendance` | **Nhập / cập nhật điểm danh** |
| GET | `/api/v1/admin/classroom-subjects/{id}/grades` | Bảng điểm môn/lớp |
| **POST** | `/api/v1/admin/classroom-subjects/{id}/grades` | **Nhập điểm hàng loạt** |
| **PUT** | `/api/v1/admin/grades/{id}` | **Sửa điểm một bản ghi** |
| GET | `/api/v1/admin/classroom-subjects/{id}/grades/export` | Xuất bảng điểm ra Excel |
| GET | `/api/v1/admin/notifications` | Lịch sử thông báo đã gửi |
| **POST** | `/api/v1/admin/notifications` | **Gửi thông báo** |

### Chỉ ADMIN mới được

| Method | Endpoint |
|---|---|
| DELETE | `/api/v1/admin/lessons/{id}` |
| POST, PUT | `/api/v1/admin/rooms` |
| POST | `/api/v1/admin/classroom-subjects` |
| DELETE | `/api/v1/admin/classroom-subjects/{id}` |
| POST, PUT | `/api/v1/admin/subjects` |
| POST, PUT | `/api/v1/admin/semesters` |
| POST, PUT | `/api/v1/admin/academic-years` |
| POST, PUT, DELETE | `/api/v1/admin/teachers`, `/admin/parents`, `/admin/students`, `/admin/classrooms` |

---

## 4. Luồng Thời khóa biểu (Timetable)

```
Admin tạo Năm học → Học kỳ → Phân công (ClassroomSubject: lớp + môn + giáo viên)
  → Giáo viên/Admin tạo Tiết học (Lesson) cho từng phân công
  → Tiết học có: ngày, giờ (timeSlot), phòng, trạng thái
```

### Trạng thái Tiết học

| Trạng thái | Mô tả |
|---|---|
| `SCHEDULED` | Lên lịch (mặc định) |
| `COMPLETED` | Đã dạy |
| `CANCELLED` | Đã hủy |

Giáo viên `PATCH /admin/lessons/{id}` để cập nhật trạng thái, phòng, ghi chú. Chỉ ADMIN mới xóa được tiết học.

### Điều hướng trên UI

1. Chọn **Học kỳ** → load danh sách phân công (`GET /admin/classroom-subjects?semesterId=X`)
2. Chọn **Môn / Lớp** (ClassroomSubject) → load tiết học (`GET /admin/classroom-subjects/{id}/lessons`)
3. Hiển thị dạng danh sách hoặc lịch

---

## 5. Luồng Điểm danh (Attendance)

```
Chọn Học kỳ → Chọn Môn/Lớp → Chọn Tiết học
  → GET /admin/lessons/{id}/attendance  (danh sách học sinh + trạng thái)
  → Giáo viên tích trạng thái từng học sinh
  → POST /admin/lessons/{id}/attendance  (lưu toàn bộ)
```

### Trạng thái điểm danh

| Giá trị | Nghĩa |
|---|---|
| `PRESENT` | Có mặt |
| `ABSENT` | Vắng mặt |
| `LATE` | Trễ |
| `EXCUSED` | Vắng có phép |

**Không có lock theo ngày** — giáo viên có thể sửa điểm danh bất kỳ tiết nào bất kỳ lúc nào.

**Không enforce data scope** — giáo viên có thể điểm danh bất kỳ tiết của bất kỳ phân công nào (MVP simplification).

---

## 6. Luồng Điểm số (Grades)

```
Chọn Học kỳ → Chọn Môn/Lớp (ClassroomSubject)
  → GET /admin/classroom-subjects/{id}/grades  (bảng điểm: học sinh × cột điểm)
  → Giáo viên nhập điểm vào bảng
  → POST /admin/classroom-subjects/{id}/grades  (bulk upsert)
  → Hoặc PUT /admin/grades/{id}  (sửa 1 ô điểm)
  → Xuất Excel: GET /admin/classroom-subjects/{id}/grades/export
```

### Cấu trúc bảng điểm

```
ClassroomSubject
  └── students[]
        └── scores[componentId → score]
              componentId: các cột điểm (TX1, TX2, GK, CK, ...)
              score: số thực hoặc null (chưa nhập)
```

**Không có workflow** (không có DRAFT/SUBMITTED/APPROVED/PUBLISHED). Giáo viên nhập xong là lưu luôn — không có bước duyệt.

**Không enforce data scope** — giáo viên có thể nhập điểm cho bất kỳ ClassroomSubject nào.

---

## 7. Luồng Thông báo (Notifications)

### Gửi thông báo

```
POST /api/v1/admin/notifications
Body: {
  title: string,
  content: string,
  targetType: "all" | "classroom" | "individual",
  targetId?: number  (bắt buộc khi targetType != "all")
}
```

Validation phía frontend (Zod `.superRefine`): nếu `targetType = "individual"` hoặc `"classroom"` thì phải có `targetId`.

### Xem thông báo đã gửi

`GET /api/v1/admin/notifications` — trả về danh sách thông báo do tài khoản đang đăng nhập gửi (filter theo `senderUsername`).

---

## 8. Đổi mật khẩu

`PATCH /api/v1/me/password` với body `{ currentPassword, newPassword }`.

Accessible bởi tất cả role kể cả STUDENT và PARENT qua `MeController`.

---

## 9. Bug frontend hiện tại (giáo viên thấy thứ không nên thấy)

| Trang | Vấn đề | Hậu quả |
|---|---|---|
| `StudentListPage` | Nút "Thêm học sinh", "Import Excel", "Sửa", "Khóa/Mở khóa" **không check `isAdmin`** | Giáo viên thấy và bấm được → backend trả 403, không có error message |
| `StudentListPage` | Route `/students/new` và `/students/:id/edit` **không nằm trong `AdminRoute`** | Giáo viên navigate trực tiếp vào form tạo/sửa học sinh được |
| `TimetablePage` | Nút "Xóa" tiết học hiển thị cho tất cả, nhưng `DELETE /admin/lessons/{id}` là admin-only | Giáo viên click Xóa → xác nhận dialog → backend 403 → **không có error message nào hiển thị** |

## 10. Những gì MyFPTSchool chưa có (so với hệ thống đầy đủ)

| Tính năng | Trạng thái | Ghi chú |
|---|---|---|
| Data scope per teacher | ❌ Chưa có | Teacher thấy và sửa được tất cả dữ liệu |
| Gradebook workflow (DRAFT→APPROVED) | ❌ Chưa có | Nhập điểm thẳng, không qua duyệt |
| Attendance lock theo ngày | ❌ Chưa có | Có thể sửa điểm danh tự do |
| Phân biệt quyền TEACHER vs HOMEROOM_TEACHER | ❌ Chưa có | Hai role có quyền giống hệt |
| GVCN duyệt đơn nghỉ | ❌ Chưa có | Không có leave request |
| GVCN nhập hạnh kiểm | ❌ Chưa có | Không có conduct record |
| Teacher mobile app | ❌ Không có | Flutter chỉ cho STUDENT + PARENT |
| Import TKB bằng Excel | ❌ Chưa có | Giáo viên/Admin thêm tiết thủ công |

---

## 10. Sơ đồ entity liên quan đến giáo viên

```
AcademicYear (năm học: label, startDate, endDate)
  └── Semester (học kỳ: name, startDate, endDate)
        └── ClassroomSubject (phân công: classroom + subject + teacher + semester)
              ├── Lesson[] (tiết học: date, timeSlot, room, status)
              │     └── AttendanceRecord[] (student + status + note)
              └── GradeRecord[] (student + scoreComponent + score)

Teacher (hồ sơ: employeeCode, fullName, account)
  └── ClassroomSubject.teacher FK

Notification (title, content, targetType, targetId, senderAccount)
```

---

## 11. Luồng đăng nhập của giáo viên

```
POST /api/v1/auth/login  { username, password, platform: "web" }
  → JWT accessToken (lưu localStorage)
  → GET /api/v1/me  { id, username, fullName, email, role: "TEACHER" | "HOMEROOM_TEACHER" }
  → Frontend xác định isAdmin = false
  → Sidebar hiển thị mục dành cho giáo viên
  → AdminRoute chặn /teachers, /parents, /assignments, /semesters, /subjects, /academic-years, /rooms
```

Token tự động refresh khi nhận 401. Không có token rotation hay refresh token riêng biệt hiện tại.

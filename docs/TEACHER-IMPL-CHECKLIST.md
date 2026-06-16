# Quy trình & Checklist — Teacher Features Implementation

> File sống: cập nhật trạng thái từng task khi hoàn thành.
> Trạng thái: ⬜ Chưa làm | 🔄 Đang làm | ✅ Xong | ❌ Blocked

---

## Quy tắc làm việc

### Trước khi code
1. **Read file trước khi edit** — không edit từ trí nhớ
2. **Đọc file liên quan** — nếu sửa component A mà B import A, đọc B trước
3. **Hiểu data flow** — biết API nào trả gì trước khi viết query

### Khi code
4. **Một nhiệm vụ một lần** — không nhảy task, hoàn thành rồi mới sang
5. **Không tạo file mới khi có thể edit file cũ** — tránh trùng lặp
6. **Giữ nguyên pattern hiện tại** — TanStack Query, Zod, inline form
7. **Không comment giải thích WHAT** — chỉ comment khi WHY không rõ

### Sau khi code
8. **Verify import** — mọi import phải tồn tại, không import chưa có
9. **Verify props/types** — không dùng `any`, type phải đúng
10. **Check file liên quan** — nếu thêm route mới → check router.tsx; thêm API → check queryKeys

### Quy tắc verify từng loại thay đổi

| Loại thay đổi | Verify thêm |
|---|---|
| Thêm route | `router.tsx` có import đúng không |
| Thêm sidebar item | `Sidebar.tsx` navItems, icon import |
| Thêm API endpoint | `queryKeys.ts` có key chưa, `api.ts` pattern đúng không |
| Sửa Backend entity | Repository method tồn tại |
| Sửa Backend controller | Service method tồn tại, `@PreAuthorize` đúng |

---

## BƯỚC 1 — Fix Bug (frontend only, không cần backend)

### 1.1 StudentListPage — ẩn nút admin khi `!isAdmin`
- ⬜ Thêm `const { isAdmin } = useAuth()` vào StudentListPage
- ⬜ Ẩn nút "Thêm học sinh" khi `!isAdmin`
- ⬜ Ẩn nút "Import Excel" và "Tải template" khi `!isAdmin`
- ⬜ Ẩn link "Sửa" và nút "Khóa/Mở khóa" khi `!isAdmin`

### 1.2 Router — bảo vệ route học sinh
- ⬜ Đưa `/students/new` vào `AdminRoute`
- ⬜ Đưa `/students/:id/edit` vào `AdminRoute`

### 1.3 TimetablePage — fix nút Xóa
- ⬜ Ẩn nút "Xóa" khi `!isAdmin`
- ⬜ Thêm error toast/message khi `deleteLesson.isError`

---

## BƯỚC 2 — Backend: 2 endpoint mới

### 2.1 `GET /me/classroom-subjects`
- ⬜ Đọc entity Teacher, ClassroomSubject, MeController
- ⬜ Tạo DTO `MyClassroomSubjectResponse`
- ⬜ Thêm method `getMyClassroomSubjects(username)` vào service
- ⬜ Thêm endpoint vào `MeController` với `@PreAuthorize("hasAnyRole('TEACHER','HOMEROOM_TEACHER')")`
- ⬜ Verify: query đúng (filter theo teacher account username)

### 2.2 `GET /me/lessons/today`
- ⬜ Tạo DTO `TodayLessonResponse`
- ⬜ Thêm method `getTodayLessons(username)` vào service
- ⬜ Thêm endpoint vào `MeController`
- ⬜ Verify: join lesson → classroom_subject → teacher → account

---

## BƯỚC 3 — Frontend: TeacherDashboard

### 3.1 Tạo `TeacherDashboardPage`
- ⬜ Tạo `src/features/dashboard/TeacherDashboardPage.tsx`
- ⬜ Section "Tiết học hôm nay" — gọi `GET /me/lessons/today`
- ⬜ Mỗi tiết có: giờ, môn, lớp, phòng, badge trạng thái điểm danh
- ⬜ Nút "Điểm danh ngay" → navigate `/attendance?lessonId=X`
- ⬜ Section "Cần xử lý" — tiết chưa điểm danh, lớp thiếu điểm (tính từ data có sẵn)
- ⬜ Thống kê nhỏ: số lớp đang dạy, số tiết tuần này

### 3.2 Branch Dashboard theo role
- ⬜ Sửa `DashboardPage.tsx`: nếu `isAdmin` → giữ nguyên; nếu không → render `TeacherDashboardPage`

### 3.3 Frontend query key
- ⬜ Thêm `queryKeys.me.lessons.today()` vào `queryKeys.ts`
- ⬜ Thêm `queryKeys.me.classroomSubjects()` vào `queryKeys.ts`

---

## BƯỚC 4 — Cải tiến 3 trang hiện có

### 4.1 AttendancePage — deep-link + bỏ bước chọn học kỳ
- ⬜ Đọc URL param `lessonId` từ `useSearchParams`
- ⬜ Nếu có `lessonId` → auto-load attendance ngay, bỏ qua dropdown
- ⬜ Dropdown "Môn/Lớp" gọi `GET /me/classroom-subjects` (không cần chọn học kỳ trước)
- ⬜ Tự detect học kỳ từ thông tin CS (không cần user chọn)
- ⬜ Nút "Có mặt tất cả" — fill tất cả = present, rồi sửa riêng
- ⬜ Verify: flow B (vào trang thẳng) vẫn hoạt động

### 4.2 GradesPage — dùng `/me/classroom-subjects`
- ⬜ Thay `GET /admin/classroom-subjects?semesterId=X` → `GET /me/classroom-subjects`
- ⬜ Bỏ selector học kỳ (CS response đã có semesterName trong label)
- ⬜ Verify: xuất Excel, lưu điểm vẫn dùng csId đúng

### 4.3 NotificationComposePage — filter lớp
- ⬜ Khi `!isAdmin` và `targetType === 'classroom'`: load từ `/me/classroom-subjects` thay vì `/admin/classrooms`
- ⬜ Hiển thị `{classroomName} — {subjectName}` thay vì chỉ tên lớp
- ⬜ Verify: admin vẫn thấy toàn bộ lớp

---

## BƯỚC 5 — Trang mới

### 5.1 `MyStudentsPage` — học sinh lớp mình
- ⬜ Tạo `src/features/students/MyStudentsPage.tsx`
- ⬜ Load `/me/classroom-subjects` → extract unique classrooms
- ⬜ Tab hoặc card group theo từng lớp
- ⬜ Mỗi lớp: load `/admin/classrooms/{id}/students`
- ⬜ Read-only: không có nút Thêm/Sửa/Khóa

### 5.2 `MyTimetablePage` — lịch theo tuần
- ⬜ Tạo `src/features/timetable/MyTimetablePage.tsx`
- ⬜ Điều hướng tuần: ← tuần trước | tuần sau → | [Hôm nay]
- ⬜ Grid: ngày trong tuần × tiết trong ngày
- ⬜ Mỗi cell: môn, lớp, phòng, badge trạng thái
- ⬜ Click cell → navigate `/attendance?lessonId=X`
- ⬜ Load: `/me/classroom-subjects` → `/admin/classroom-subjects/{id}/lessons` → filter theo tuần

### 5.3 `ProfilePage` — hồ sơ + đổi mật khẩu
- ⬜ Tạo `src/features/profile/ProfilePage.tsx`
- ⬜ Hiển thị: họ tên, email, role, mã GV
- ⬜ Form đổi mật khẩu: currentPassword, newPassword, confirm
- ⬜ Gọi `PATCH /me/password`

---

## BƯỚC 6 — Sidebar & Routing

### 6.1 Sidebar tách theo role
- ⬜ Đọc `Sidebar.tsx` hiện tại
- ⬜ Tạo `teacherNavItems` riêng: Dashboard, Lịch dạy, Điểm danh, Điểm số, Học sinh lớp tôi, [GVCN] Lớp chủ nhiệm, Thông báo, Hồ sơ
- ⬜ Sidebar render `teacherNavItems` khi `!isAdmin`, `adminNavItems` khi `isAdmin`

### 6.2 Router — thêm routes mới
- ⬜ `/my-timetable` → `MyTimetablePage`
- ⬜ `/my-students` → `MyStudentsPage`
- ⬜ `/profile` → `ProfilePage`
- ⬜ Verify: routes mới không nằm trong `AdminRoute`

---

## Log thay đổi

| Thời gian | Task | Ghi chú |
|---|---|---|
| | | |

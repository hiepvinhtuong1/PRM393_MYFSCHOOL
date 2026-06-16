# Backend Design: MyFPTSchool API

Stack: Java 21 · Spring Boot 3.x · PostgreSQL 15 · Flyway · Springdoc OpenAPI

---

## 1. Kiến trúc

**Layered Architecture theo feature** — mỗi tính năng nghiệp vụ là một package độc lập, bên trong có đủ 3 layer: Controller → Service → Repository.

Lý do chọn cách này thay vì package-by-layer (`controller/`, `service/`, `repository/`):
- Mỗi developer có thể sở hữu 1 feature mà không đụng file của người khác.
- Dễ đọc: mở package `attendance/` là thấy toàn bộ logic điểm danh.
- Scale tốt hơn khi thêm feature mới.

```
Incoming request
    │
    ▼
Controller          ← validate input, map DTO, trả response
    │
    ▼
Service             ← business logic, gọi nhiều repo nếu cần
    │
    ▼
Repository          ← Spring Data JPA, truy vấn database
    │
    ▼
Entity / View       ← JPA entity mapped tới bảng / view PostgreSQL
```

---

## 2. Cấu trúc project

```
src/
├── main/
│   ├── java/vn/edu/fpt/myfptschool/
│   │   │
│   │   ├── common/                         # Dùng chung, không thuộc domain nào
│   │   │   ├── dto/
│   │   │   │   ├── ApiResponse.java         # Response envelope chung
│   │   │   │   └── PageResponse.java        # Pagination wrapper
│   │   │   ├── exception/
│   │   │   │   ├── GlobalExceptionHandler.java
│   │   │   │   ├── ResourceNotFoundException.java
│   │   │   │   ├── ForbiddenException.java
│   │   │   │   └── ValidationException.java
│   │   │   └── util/
│   │   │       └── DateUtils.java
│   │   │
│   │   ├── config/                         # Spring config beans
│   │   │   ├── SecurityConfig.java          # Spring Security + JWT
│   │   │   ├── CorsConfig.java
│   │   │   └── OpenApiConfig.java           # Springdoc / Swagger
│   │   │
│   │   ├── security/                       # JWT infrastructure
│   │   │   ├── JwtFilter.java              # OncePerRequestFilter
│   │   │   ├── JwtProvider.java            # generate / validate token
│   │   │   └── UserPrincipal.java          # implements UserDetails
│   │   │
│   │   ├── auth/                           # Đăng nhập / đăng xuất
│   │   │   ├── AuthController.java
│   │   │   ├── AuthService.java
│   │   │   ├── dto/
│   │   │   │   ├── LoginRequest.java
│   │   │   │   └── LoginResponse.java
│   │   │   └── entity/
│   │   │       ├── User.java
│   │   │       └── UserSession.java
│   │   │
│   │   ├── student/                        # Học sinh
│   │   │   ├── StudentController.java
│   │   │   ├── StudentService.java
│   │   │   ├── StudentRepository.java
│   │   │   ├── dto/
│   │   │   │   ├── StudentResponse.java
│   │   │   │   └── StudentRequest.java
│   │   │   └── entity/
│   │   │       └── Student.java
│   │   │
│   │   ├── parent/                         # Phụ huynh
│   │   │   ├── ParentController.java
│   │   │   ├── ParentService.java
│   │   │   ├── ParentRepository.java
│   │   │   ├── dto/
│   │   │   └── entity/
│   │   │       ├── Parent.java
│   │   │       └── ParentStudent.java      # junction entity
│   │   │
│   │   ├── teacher/                        # Giáo viên
│   │   │   ├── TeacherController.java
│   │   │   ├── TeacherService.java
│   │   │   ├── TeacherRepository.java
│   │   │   ├── dto/
│   │   │   └── entity/
│   │   │       └── Teacher.java
│   │   │
│   │   ├── academic/                       # Cấu trúc học thuật
│   │   │   ├── AcademicController.java
│   │   │   ├── AcademicService.java
│   │   │   ├── dto/
│   │   │   └── entity/
│   │   │       ├── Campus.java
│   │   │       ├── AcademicYear.java
│   │   │       ├── Semester.java
│   │   │       ├── Classroom.java
│   │   │       ├── Subject.java
│   │   │       └── ClassroomSubject.java   # phân công giảng dạy
│   │   │
│   │   ├── timetable/                      # Thời khóa biểu
│   │   │   ├── TimetableController.java
│   │   │   ├── TimetableService.java
│   │   │   ├── TimetableRepository.java
│   │   │   ├── dto/
│   │   │   │   └── LessonResponse.java
│   │   │   └── entity/
│   │   │       ├── Lesson.java
│   │   │       ├── Room.java
│   │   │       └── TimeSlot.java
│   │   │
│   │   ├── attendance/                     # Điểm danh
│   │   │   ├── AttendanceController.java
│   │   │   ├── AttendanceService.java
│   │   │   ├── AttendanceRepository.java
│   │   │   ├── dto/
│   │   │   │   ├── AttendanceRecordRequest.java
│   │   │   │   ├── AttendanceSummaryResponse.java
│   │   │   │   └── AttendanceSessionResponse.java
│   │   │   └── entity/
│   │   │       ├── AttendanceRecord.java
│   │   │       └── AttendanceSummary.java  # @Immutable view entity
│   │   │
│   │   ├── grade/                          # Điểm số
│   │   │   ├── GradeController.java
│   │   │   ├── GradeService.java
│   │   │   ├── GradeRepository.java
│   │   │   ├── dto/
│   │   │   │   ├── GradeRecordRequest.java
│   │   │   │   ├── GradeSubjectResponse.java
│   │   │   │   └── GradeSummaryResponse.java
│   │   │   └── entity/
│   │   │       ├── GradeRecord.java
│   │   │       ├── GradeSummary.java       # @Immutable view entity
│   │   │       └── ScoreComponent.java
│   │   │
│   │   └── notification/                   # Thông báo
│   │       ├── NotificationController.java
│   │       ├── NotificationService.java
│   │       ├── NotificationRepository.java
│   │       ├── dto/
│   │       │   ├── NotificationRequest.java
│   │       │   └── NotificationResponse.java
│   │       └── entity/
│   │           ├── Notification.java
│   │           └── NotificationRecipient.java
│   │
│   └── resources/
│       ├── application.yml
│       ├── application-dev.yml
│       ├── application-prod.yml
│       └── db/migration/                   # Flyway migrations
│           ├── V1__create_schema.sql        # 20 bảng
│           ├── V2__seed_static_data.sql     # time_slots, score_components
│           └── V3__seed_dev_data.sql        # dữ liệu test (dev only)
│
└── test/
    └── java/vn/edu/fpt/myfptschool/
        ├── auth/
        │   └── AuthControllerTest.java
        ├── attendance/
        │   └── AttendanceServiceTest.java
        └── grade/
            └── GradeServiceTest.java
```

---

## 3. API conventions

### 3.1 URL pattern

```
/api/v1/{resource}
/api/v1/{resource}/{id}
/api/v1/{resource}/{id}/{sub-resource}
```

| Nhóm | Prefix | Dùng bởi |
|---|---|---|
| Mobile (học sinh/phụ huynh) | `/api/v1/me/...` | App Flutter |
| Quản trị (giáo viên/admin) | `/api/v1/admin/...` | Web React |
| Dùng chung | `/api/v1/auth/...` | Cả hai |

Ví dụ:
```
POST   /api/v1/auth/login
GET    /api/v1/me/timetable?date=2026-06-11
GET    /api/v1/me/attendance?semesterId=1
GET    /api/v1/me/grades?semesterId=1
GET    /api/v1/me/notifications?page=0&size=20
PUT    /api/v1/me/notifications/{id}/read

GET    /api/v1/admin/classrooms
GET    /api/v1/admin/classrooms/{id}/students
POST   /api/v1/admin/lessons/{id}/attendance
PUT    /api/v1/admin/grades
POST   /api/v1/admin/notifications
```

### 3.2 Response envelope

Mọi response đều bọc trong `ApiResponse<T>`:

```json
// Thành công
{
  "success": true,
  "data": { ... },
  "message": null,
  "timestamp": "2026-06-11T07:00:00Z"
}

// Thành công với pagination
{
  "success": true,
  "data": {
    "content": [ ... ],
    "page": 0,
    "size": 20,
    "totalElements": 45,
    "totalPages": 3
  }
}

// Lỗi
{
  "success": false,
  "data": null,
  "message": "Học sinh không tồn tại",
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "field": null
  },
  "timestamp": "2026-06-11T07:00:00Z"
}
```

### 3.3 HTTP status codes

| Tình huống | Status |
|---|---|
| Thành công, có data | `200 OK` |
| Tạo resource mới | `201 Created` |
| Không có data trả về | `204 No Content` |
| Sai input | `400 Bad Request` |
| Chưa đăng nhập | `401 Unauthorized` |
| Không có quyền | `403 Forbidden` |
| Không tìm thấy | `404 Not Found` |
| Lỗi server | `500 Internal Server Error` |

---

## 4. Security design

### 4.1 Roles và quyền

| Role | Mô tả |
|---|---|
| `STUDENT` | Đọc dữ liệu cá nhân |
| `PARENT` | Đọc dữ liệu học sinh liên kết |
| `TEACHER` | Đọc + ghi điểm danh/điểm số môn mình dạy |
| `HOMEROOM_TEACHER` | Như TEACHER + quản lý lớp chủ nhiệm |
| `ADMIN` | Toàn quyền |

### 4.2 JWT flow

```
Client gửi POST /auth/login { username, password }
    → AuthService xác thực
    → JwtProvider.generateToken(userId, role)
    → Lưu UserSession vào DB
    → Trả { accessToken, expiresIn }

Request tiếp theo: Header Authorization: Bearer <token>
    → JwtFilter kiểm tra token
    → Load UserPrincipal từ DB hoặc cache
    → SecurityContextHolder.setAuthentication(...)
    → Controller nhận @AuthenticationPrincipal UserPrincipal
```

### 4.3 Phân quyền tại Controller

```java
// Học sinh chỉ xem của mình
@GetMapping("/me/timetable")
@PreAuthorize("hasAnyRole('STUDENT', 'PARENT')")
public ApiResponse<List<LessonResponse>> getMyTimetable(
    @AuthenticationPrincipal UserPrincipal principal,
    @RequestParam @DateTimeFormat(iso = DATE) LocalDate date
) { ... }

// Giáo viên nhập điểm danh
@PostMapping("/admin/lessons/{lessonId}/attendance")
@PreAuthorize("hasAnyRole('TEACHER', 'HOMEROOM_TEACHER', 'ADMIN')")
public ApiResponse<Void> recordAttendance(...) { ... }

// Chỉ admin
@PostMapping("/admin/classrooms")
@PreAuthorize("hasRole('ADMIN')")
public ApiResponse<ClassroomResponse> createClassroom(...) { ... }
```

---

## 5. Xử lý view entity (attendance_summary, grade_summary)

PostgreSQL view map vào JPA entity dùng annotation `@Immutable` — Spring chỉ đọc, không bao giờ ghi:

```java
@Entity
@Table(name = "attendance_summary")
@Immutable                          // org.hibernate.annotations.Immutable
@IdClass(AttendanceSummaryId.class)
public class AttendanceSummary {

    @Id private Long studentId;
    @Id private Long subjectId;
    @Id private Long semesterId;

    private int totalSessions;
    private int presentSessions;
    private int lateSessions;
    private int excusedAbsent;
    private int unexcusedAbsent;
    private int totalAbsent;
}
```

Service tính `AttendanceStatus` (safe/attention/danger/exceeded) từ `totalAbsent` và `warningThreshold` của Subject — không lưu trạng thái này vào DB.

---

## 6. Database migrations (Flyway)

```
resources/db/migration/
├── V1__create_schema.sql       # Toàn bộ 20 bảng + indexes
├── V2__seed_static_data.sql    # time_slots (10 tiết) + score_components (5 đầu điểm)
└── V3__seed_dev_data.sql       # Campus, năm học, lớp, học sinh, GV mẫu (chỉ chạy dev)
```

Flyway chạy tự động khi app khởi động. File `V3` chỉ được include trong `application-dev.yml`, không có trong `application-prod.yml`.

---

## 7. Cấu hình môi trường

```yaml
# application.yml (base)
spring:
  datasource:
    url: ${DB_URL}
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
  jpa:
    open-in-view: false          # tắt để tránh N+1 ẩn
    show-sql: false
  flyway:
    enabled: true
    locations: classpath:db/migration

app:
  jwt:
    secret: ${JWT_SECRET}
    expiration-ms: 86400000      # 24h

# application-dev.yml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/myfptschool_dev
  flyway:
    locations: classpath:db/migration,classpath:db/seed-dev
  jpa:
    show-sql: true
```

---

## 8. Những điểm cần chú ý khi code

| Vấn đề | Giải pháp |
|---|---|
| N+1 với attendance/grade | Dùng `@Query` JPQL với JOIN FETCH hoặc native SQL projection |
| Giáo viên chỉ sửa được môn mình dạy | Service kiểm tra `classroomSubject.teacherId == principal.id` trước khi ghi |
| Phụ huynh chỉ xem được con liên kết | Service kiểm tra `parentStudents` trước khi trả data |
| Fanout notification lớn | Gọi `notificationRepository.saveAll(recipients)` batch insert 1 lần |
| View entity không có @Id tự nhiên | Dùng `@IdClass` composite key như ví dụ trên |

# Backend Coding Rules

Áp dụng cho toàn bộ code Spring Boot của dự án.  
Mỗi rule có lý do — hiểu lý do mới biết khi nào được phép linh hoạt.

---

## 1. Entity

### 1.1 Không dùng `@Data` trên entity
`@Data` sinh setter cho tất cả fields. Dùng `@Getter` thay thế, viết setter/method tường minh cho những field cần thay đổi.

```java
// ❌
@Entity @Data
public class Student { ... }

// ✅
@Entity @Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Student { ... }
```

### 1.2 No-arg constructor để `PROTECTED`, không phải `PUBLIC`
Hibernate cần no-arg constructor để đọc từ DB, nhưng business code không được phép `new Student()` mà không truyền data.

### 1.3 Field không thay đổi sau khi tạo thì không có setter
Ví dụ: `studentCode`, `id`, `createdAt`. Đánh dấu `updatable = false` trên `@Column` để DB cũng từ chối.

```java
@Column(unique = true, nullable = false, updatable = false)
private String studentCode;
```

### 1.4 Thay đổi state phải đi qua method có tên nghiệp vụ, không phải raw setter

```java
// ❌
student.setClassroom(newClassroom);

// ✅
student.transferToClassroom(newClassroom);
```

### 1.5 Dùng `BaseEntity` cho các field chung

```java
@MappedSuperclass
@Getter
public abstract class BaseEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(updatable = false)
    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() { createdAt = updatedAt = LocalDateTime.now(); }

    @PreUpdate
    protected void onUpdate() { updatedAt = LocalDateTime.now(); }
}
```

### 1.6 View entity dùng `@Immutable`
`attendance_summary` và `grade_summary` là PostgreSQL view, map sang entity bằng `@Immutable` — Hibernate không bao giờ ghi vào đây.

```java
@Entity
@Table(name = "attendance_summary")
@Immutable
@Getter
public class AttendanceSummary { ... }
```

### 1.7 Luôn dùng `FetchType.LAZY` cho quan hệ
`EAGER` là mặc định của `@ManyToOne` trong một số trường hợp — override lại để tránh load data không cần thiết.

```java
@ManyToOne(fetch = FetchType.LAZY)
private Classroom classroom;
```

---

## 2. Service

### 2.1 Mỗi Service chỉ làm việc của domain mình
`AttendanceService` không được gọi `GradeRepository`. Nếu cần data của domain khác, inject Service của domain đó.

### 2.2 Logic nghiệp vụ nằm trong Service, không phải Controller
Controller chỉ nhận request → gọi Service → trả response. Không có if-else nghiệp vụ trong Controller.

### 2.3 Đặt `@Transactional` đúng chỗ
- `@Transactional` trên method Service khi có ghi DB.
- `@Transactional(readOnly = true)` cho các method chỉ đọc — PostgreSQL tối ưu hơn.
- Không đặt `@Transactional` trên Controller.

```java
@Transactional(readOnly = true)
public AttendanceSummaryResponse getSummary(Long studentId, Long semesterId) { ... }

@Transactional
public void recordAttendance(Long lessonId, List<AttendanceRecordRequest> requests) { ... }
```

### 2.4 Kiểm tra quyền sở hữu data trong Service, không dựa vào @PreAuthorize đơn thuần
`@PreAuthorize("hasRole('STUDENT')")` chỉ kiểm tra role, không kiểm tra học sinh A có được xem data của học sinh B không.

```java
public AttendanceSummaryResponse getSummary(Long studentId, UserPrincipal principal) {
    // Học sinh chỉ xem được của mình
    if (principal.isStudent() && !principal.getStudentId().equals(studentId)) {
        throw new ForbiddenException("Không có quyền truy cập");
    }
    // Phụ huynh chỉ xem được con liên kết
    if (principal.isParent() && !parentStudentRepository.exists(principal.getParentId(), studentId)) {
        throw new ForbiddenException("Học sinh không thuộc danh sách liên kết");
    }
    ...
}
```

### 2.5 Business logic được tính toán nằm trong object, không tính lại trong Service

```java
// ❌ Service tự tính ngưỡng
if (summary.getTotalAbsent() >= summary.getWarningThreshold() * 0.8) { ... }

// ✅ Hỏi object
if (summary.isAtRisk()) { ... }
```

---

## 3. Controller

### 3.1 Controller phải mỏng — không có logic nghiệp vụ

```java
@GetMapping("/me/attendance")
public ApiResponse<AttendanceSummaryResponse> getAttendance(
    @AuthenticationPrincipal UserPrincipal principal,
    @RequestParam Long semesterId
) {
    return ApiResponse.ok(attendanceService.getSummary(principal, semesterId));
}
```

### 3.2 Validate input tại Controller bằng Bean Validation

```java
public ApiResponse<Void> recordAttendance(
    @PathVariable Long lessonId,
    @Valid @RequestBody List<AttendanceRecordRequest> requests // @Valid kích hoạt validation
) { ... }
```

```java
public class AttendanceRecordRequest {
    @NotNull private Long studentId;
    @NotNull @Pattern(regexp = "present|late|excused_absent|unexcused_absent")
    private String status;
}
```

### 3.3 Luôn đặt `@PreAuthorize` rõ ràng trên mỗi endpoint

```java
@PostMapping("/admin/lessons/{id}/attendance")
@PreAuthorize("hasAnyRole('TEACHER', 'HOMEROOM_TEACHER', 'ADMIN')")
public ApiResponse<Void> recordAttendance(...) { ... }
```

### 3.4 URL theo convention đã định nghĩa
- Mobile: `/api/v1/me/...`
- Web admin: `/api/v1/admin/...`
- Auth: `/api/v1/auth/...`

---

## 4. Repository

### 4.1 Dùng `@Query` cho các truy vấn phức tạp, không dựa vào method name dài

```java
// ❌ Method name dài, khó đọc, dễ sai
List<Lesson> findByClassroomSubjectClassroomIdAndLessonDate(Long classroomId, LocalDate date);

// ✅ JPQL rõ ràng
@Query("""
    SELECT l FROM Lesson l
    JOIN l.classroomSubject cs
    WHERE cs.classroom.id = :classroomId
    AND l.lessonDate = :date
    ORDER BY l.startSlot.slotNumber
    """)
List<Lesson> findByClassroomAndDate(
    @Param("classroomId") Long classroomId,
    @Param("date") LocalDate date
);
```

### 4.2 Tránh N+1 — dùng JOIN FETCH hoặc projection
Khi load danh sách Lesson mà cần thông tin Teacher, Subject — JOIN FETCH trong query thay vì để Hibernate lazy load từng cái.

```java
@Query("""
    SELECT l FROM Lesson l
    JOIN FETCH l.classroomSubject cs
    JOIN FETCH cs.subject
    JOIN FETCH cs.teacher
    WHERE l.lessonDate = :date AND cs.classroom.id = :classroomId
    """)
List<Lesson> findWithDetailsForDate(@Param("classroomId") Long id, @Param("date") LocalDate date);
```

### 4.3 Dùng Projection khi chỉ cần một số fields
Không load cả entity khi chỉ cần hiển thị tên + mã học sinh.

```java
public interface StudentSummary {
    String getStudentCode();
    String getFullName();
}

List<StudentSummary> findByClassroomId(Long classroomId);
```

---

## 5. DTO

### 5.1 Không trả Entity trực tiếp ra ngoài Controller
Entity có thể chứa fields nhạy cảm, có quan hệ circular, không ổn định khi schema thay đổi. Luôn map sang DTO.

### 5.2 Tách biệt Request DTO và Response DTO

```
dto/
├── request/
│   └── AttendanceRecordRequest.java   // dữ liệu vào — có validation annotations
└── response/
    └── AttendanceSummaryResponse.java // dữ liệu ra — không có validation
```

### 5.3 Dùng static factory method thay vì constructor nhiều tham số

```java
@Getter
public class LessonResponse {
    private Long id;
    private String subjectName;
    private String teacherName;
    private String roomCode;
    private String slotLabel;

    public static LessonResponse from(Lesson lesson) {
        LessonResponse dto = new LessonResponse();
        dto.id = lesson.getId();
        dto.subjectName = lesson.getClassroomSubject().getSubject().getName();
        dto.teacherName = lesson.getClassroomSubject().getTeacher().getFullName();
        dto.roomCode = lesson.getRoom().getCode();
        dto.slotLabel = "Tiết " + lesson.getStartSlot().getSlotNumber()
            + (lesson.getStartSlot() != lesson.getEndSlot()
                ? "-" + lesson.getEndSlot().getSlotNumber() : "");
        return dto;
    }
}
```

---

## 6. Exception handling

### 6.1 Dùng custom exception, không throw `RuntimeException` trực tiếp

```java
// ❌
throw new RuntimeException("Không tìm thấy học sinh");

// ✅
throw new ResourceNotFoundException("Student", studentId);
```

### 6.2 Xử lý tập trung tại `GlobalExceptionHandler`

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleNotFound(ResourceNotFoundException ex) {
        return ResponseEntity.status(404)
            .body(ApiResponse.error("RESOURCE_NOT_FOUND", ex.getMessage()));
    }

    @ExceptionHandler(ForbiddenException.class)
    public ResponseEntity<ApiResponse<Void>> handleForbidden(ForbiddenException ex) {
        return ResponseEntity.status(403)
            .body(ApiResponse.error("FORBIDDEN", ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidation(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
            .map(e -> e.getField() + ": " + e.getDefaultMessage())
            .collect(Collectors.joining(", "));
        return ResponseEntity.status(400)
            .body(ApiResponse.error("VALIDATION_ERROR", message));
    }
}
```

---

## 7. Security

### 7.1 Không lưu password dạng plain text — dùng BCrypt

```java
passwordEncoder.encode(rawPassword);      // lưu vào DB
passwordEncoder.matches(raw, encoded);    // kiểm tra khi login
```

### 7.2 Không log thông tin nhạy cảm

```java
// ❌
log.info("User {} đăng nhập với password {}", username, password);

// ✅
log.info("User {} đăng nhập thành công", username);
```

### 7.3 JWT secret phải lấy từ environment variable, không hardcode

```yaml
# ❌ application.yml
app.jwt.secret: "mysecretkey123"

# ✅
app.jwt.secret: ${JWT_SECRET}
```

---

## 8. Naming conventions

| Thành phần | Convention | Ví dụ |
|---|---|---|
| Package | lowercase, dot-separated | `vn.edu.fpt.myfptschool.attendance` |
| Class | PascalCase | `AttendanceService` |
| Method | camelCase, động từ đứng đầu | `getSummary()`, `recordAttendance()` |
| Variable | camelCase | `studentId`, `semesterId` |
| Constant | UPPER_SNAKE_CASE | `MAX_ABSENT_THRESHOLD` |
| Table/Column (SQL) | snake_case | `attendance_records`, `student_id` |
| API endpoint | kebab-case | `/api/v1/me/grade-records` |
| Migration file | `V{n}__{description}.sql` | `V1__create_schema.sql` |

---

## 9. Những thứ không được làm

| Không làm | Thay bằng |
|---|---|
| `@Autowired` trên field | Constructor injection |
| `@Data` trên entity | `@Getter` + method tường minh |
| Logic nghiệp vụ trong Controller | Chuyển vào Service |
| Trả Entity ra ngoài API | Map sang DTO |
| `new` dependency trong class | Inject qua constructor |
| Hard-code config (secret, URL) | Environment variable |
| Bắt `Exception` chung chung | Bắt đúng loại exception |
| `System.out.println` để debug | Dùng `log.debug(...)` |
| `SELECT *` kiểu lazy load N+1 | JOIN FETCH hoặc Projection |
| Logic tính ngưỡng/trạng thái rải rác | Đưa vào method của domain object |

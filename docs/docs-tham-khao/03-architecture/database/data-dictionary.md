# Data dictionary

**Trạng thái:** F01-F05 đã triển khai theo `V002`-`V004`; F06-F08 đã nối vertical slice theo `V005`
Các kiểu dữ liệu dưới đây dùng SQL Server. Cột audit chuẩn được mô tả trong
[README database](README.md) và được lược bớt khỏi bảng để dễ đọc.

## 1. Identity và RBAC

### `accounts`

| Cột | Kiểu | Ràng buộc / ý nghĩa |
|---|---|---|
| `id` | `bigint identity` | PK |
| `phone_normalized` | `varchar(20)` | `UNIQUE NOT NULL`, định dạng chuẩn hóa |
| `display_name` | `nvarchar(150)` | Tên hiển thị |
| `password_hash` | `varchar(255)` | Không bao giờ lưu plaintext |
| `status` | `varchar(20)` | `ACTIVE`, `LOCKED`, `DISABLED` |
| `failed_login_count` | `int` | Mặc định 0 |
| `locked_until` | `datetimeoffset(0)` | Nullable |
| `password_changed_at` | `datetimeoffset(0)` | Nullable |
| `last_login_at` | `datetimeoffset(0)` | Nullable |
| `row_version` | `rowversion` | Optimistic locking |

### RBAC và phiên

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `roles` | `code varchar(50)`, `name nvarchar(100)`, `is_system bit` | Unique `code` |
| `permissions` | `code varchar(100)`, `name`, `module` | Unique `code` |
| `account_roles` | `account_id`, `role_id` | PK/unique cặp |
| `role_permissions` | `role_id`, `permission_id` | PK/unique cặp |
| `refresh_tokens` | `account_id`, `token_hash`, `expires_at`, `revoked_at`, `replaced_by_token_id` | Unique `token_hash`; index account + active |
| `device_tokens` | `account_id`, `platform`, `token`, `device_id`, `last_seen_at`, `is_active` | Unique provider token |
| `password_reset_events` | `account_id`, `reset_by_account_id`, `temporary_password_expires_at`, `completed_at` | Audit cho reset thủ công; không lưu mật khẩu |

## 2. Con người và quan hệ

### Hồ sơ

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `teachers` | `account_id`, `employee_code`, `full_name`, `email`, `status` | Unique account, employee code |
| `parents` | `account_id`, `full_name`, `email`, `status` | Unique account |
| `students` | `student_code`, `full_name`, `date_of_birth`, `gender`, `status` | Unique student code; index full name |
| `parent_students` | `parent_id`, `student_id`, `relationship_type`, `is_primary`, `is_active`, `linked_at` | Unique parent + student |

`gender` và `relationship_type` cần danh mục được chốt trước migration; có thể dùng lookup
table nếu nhà trường cần cấu hình.

## 3. Cấu trúc học vụ

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `school_levels` | `code`, `name`, `display_order`, `is_active` | Unique `code` |
| `grade_levels` | `school_level_id`, `code`, `name`, `ordinal`, `is_active` | Unique level + code |
| `school_years` | `code`, `start_date`, `end_date`, `status` | Unique code; check start < end |
| `terms` | `school_year_id`, `code`, `name`, `period_type`, `start_date`, `end_date`, `status` | Unique year + code |
| `classes` | `school_year_id`, `grade_level_id`, `code`, `name`, `default_room`, `status` | Unique year + code |
| `enrollments` | `student_id`, `class_id`, `enrolled_at`, `ended_at`, `status` | Unique student + class; một enrollment active/năm |
| `subjects` | `code`, `name`, `assessment_mode`, `is_active` | Unique code; mode `NUMERIC/PASS_FAIL` |
| `curriculum_subjects` | `school_year_id`, `grade_level_id`, `subject_id`, `weekly_periods`, `is_required` | Unique year + grade + subject |
| `teaching_assignments` | `term_id`, `class_id`, `subject_id`, `teacher_id`, `status` | Unique term + class + subject |
| `homeroom_assignments` | `school_year_id`, `class_id`, `teacher_id`, `status` | Một GVCN active cho lớp |

`FULL_YEAR` là reporting period trong `terms`, không phải một học kỳ giảng dạy để phân công.
Application phải ngăn tạo `teaching_assignments` cho period này.

## 4. Thời khóa biểu

### `lesson_periods`

| Cột | Kiểu | Ý nghĩa |
|---|---|---|
| `id` | `bigint identity` | PK |
| `period_number` | `tinyint` | Số tiết |
| `name` | `nvarchar(50)` | Ví dụ `Tiết 1` |
| `start_time` | `time(0)` | Giờ bắt đầu |
| `end_time` | `time(0)` | Giờ kết thúc |
| `is_active` | `bit` | Master status |

Unique `period_number`; check start < end.

### Bảng thời khóa biểu

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `timetable_imports` | `file_name`, `file_hash`, `status`, `total_rows`, `error_count`, `error_details_json`, `imported_by_account_id`, `completed_at` | Index status/time; không chứa file nhạy cảm |
| `timetables` | `class_id`, `term_id`, `import_id`, `status`, `published_at`, `published_by_account_id`, `row_version` | Một timetable active cho class + term |
| `timetable_entries` | `timetable_id`, `day_of_week`, `lesson_period_id`, `teaching_assignment_id`, `room` | Unique timetable + day + period |
| `teaching_sessions` | `timetable_entry_id`, `class_id`, `subject_id`, `teacher_id`, `session_date`, `lesson_period_id`, `room`, `status` | Unique class + date + period; index teacher/date |

`teaching_sessions` là snapshot theo ngày để lịch sử điểm danh không đổi khi TKB bị ghi đè.
Nếu import thất bại, dữ liệu timetable rollback toàn bộ; bản ghi attempt/error của
`timetable_imports` lưu kết quả import và chi tiết lỗi; validation hoàn tất trước khi ghi
`timetables`/`timetable_entries`.

## 5. Điểm danh

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `attendance_records` | `teaching_session_id`, `student_id`, `status`, `note`, `leave_request_id`, `recorded_by_teacher_id`, `recorded_at`, `locked_at`, `row_version` | Unique session + student; index student/date qua session |
| `attendance_change_logs` | `attendance_record_id`, `old_status`, `new_status`, `old_note`, `new_note`, `reason`, `changed_by_account_id`, `changed_at` | Append-only |
| `attendance_correction_requests` | `attendance_record_id`, `requested_by_account_id`, `reason`, `status`, `reviewed_by_account_id`, `reviewed_at` | Dùng nếu nghiệp vụ “gửi yêu cầu sửa” cần workflow riêng |

`attendance_correction_requests` đang là bảng đề xuất vì người dùng đã nói giáo viên phải
“gửi yêu cầu lên Admin”, nhưng chưa chốt màn hình/trạng thái chi tiết.

## 6. Cấu hình và sổ điểm

### Cấu hình

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `grading_policies` | `school_year_id`, `grade_level_id`, `name`, `rounding_scale`, `formula_expression`, `status`, `effective_from` | Một policy active theo year + grade |
| `assessment_types` | `grading_policy_id`, `code`, `name`, `coefficient`, `assessment_mode`, `display_order` | Unique policy + code; coefficient > 0 |
| `academic_rating_rules` | `grading_policy_id`, `rating_code`, `name`, `min_average`, `max_average`, `conditions_json`, `display_order` | Không overlap khoảng điểm |
| `conduct_rating_options` | `school_year_id`, `code`, `name`, `display_order`, `is_active` | Unique year + code |

`formula_expression`/`conditions_json` chỉ được dùng sau khi có whitelist/parser an toàn;
không thực thi expression tùy ý từ database.

### Dữ liệu điểm

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `gradebooks` | `teaching_assignment_id`, `grading_policy_id`, `status`, `submitted_at/by`, `approved_at/by`, `published_at/by`, `rejection_reason`, `row_version` | Unique assignment |
| `assessments` | `gradebook_id`, `assessment_type_id`, `title`, `assessment_date`, `max_score`, `display_order`, `status` | Index gradebook + type |
| `scores` | `assessment_id`, `student_id`, `numeric_score decimal(5,2)`, `qualitative_result`, `note`, `entered_by`, `row_version` | Unique assessment + student; exactly một dạng kết quả |
| `score_change_logs` | `score_id`, `old_value`, `new_value`, `reason`, `changed_by_account_id`, `changed_at` | Append-only |
| `gradebook_workflow_logs` | `gradebook_id`, `from_status`, `to_status`, `action`, `reason`, `actor_account_id`, `acted_at` | Append-only |
| `published_subject_results` | `student_id`, `term_id`, `subject_id`, `gradebook_id`, `numeric_average`, `qualitative_result`, `published_at` | Unique student + term + subject |

`published_subject_results` là snapshot read model. Không tính lại dữ liệu đã công bố trực
tiếp từ scores nếu policy sau đó thay đổi.

## 7. Hạnh kiểm và tổng kết

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `conduct_records` | `student_id`, `term_id`, `class_id`, `rating_code`, `comment`, `status`, `entered_by_teacher_id`, `approved_by_account_id`, `published_at`, `row_version` | Unique student + term |
| `conduct_workflow_logs` | `conduct_record_id`, `from_status`, `to_status`, `reason`, `actor_account_id`, `acted_at` | Append-only |
| `student_term_summaries` | `student_id`, `term_id`, `class_id`, `numeric_average`, `academic_rating_code`, `conduct_rating_code`, `status`, `published_at` | Unique student + term |

Summary được tạo/cập nhật khi publish để Parent App đọc ổn định.

## 8. Đơn nghỉ học

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `leave_requests` | `student_id`, `submitted_by_parent_id`, `request_type`, `start_date`, `end_date`, `reason`, `status`, `reviewed_by_teacher_id`, `reviewed_at`, `rejection_reason`, `row_version` | Index student/date/status; check date |
| `leave_request_periods` | `leave_request_id`, `absence_date`, `lesson_period_id` | Unique request + date + period |
| `leave_request_history` | `leave_request_id`, `from_status`, `to_status`, `reason`, `actor_account_id`, `acted_at` | Append-only |

Đơn dài ngày không bắt buộc tạo từng period. Service xác định các teaching session nằm trong
khoảng ngày khi đồng bộ `EXCUSED_ABSENCE`.

## 9. CMS, targeting và notification

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `contents` | `content_type`, `status`, `title`, `summary`, `image_url`, `body`, `event_start_at`, `event_end_at`, `location`, `published_at/by`, `row_version` | Index type/status/published |
| `content_media` | `content_id`, `media_type`, `storage_key`, `url`, `alt_text`, `display_order` | Không lưu binary trong DB |
| `content_targets` | `content_id`, `target_type`, `grade_level_id`, `class_id` | Check đúng một scope; unique target |
| `notifications` | `recipient_account_id`, `notification_type`, `title`, `body`, `deep_link`, `source_type`, `source_id`, `read_at`, `created_at` | Index recipient + read + created |
| `notification_deliveries` | `notification_id`, `device_token_id`, `provider_message_id`, `status`, `attempt_count`, `sent_at`, `last_error` | Index pending/retry |
| `outbox_events` | `aggregate_type`, `aggregate_id`, `event_type`, `payload_json`, `status`, `attempt_count`, `available_at`, `processed_at` | Index status + available |

Target `SCHOOL` không có FK scope; `GRADE` cần `grade_level_id`; `CLASS` cần `class_id`.

## 10. Câu lạc bộ

| Bảng | Cột nghiệp vụ chính | Constraint/index |
|---|---|---|
| `clubs` | `name`, `description`, `image_url`, `teacher_id`, `capacity`, `start_date`, `registration_open_at`, `registration_close_at`, `status`, `row_version` | Capacity > 0 |
| `club_registrations` | `club_id`, `student_id`, `submitted_by_parent_id`, `status`, `registered_at`, `cancelled_at`, `row_version` | Unique active club + student; index student/status |

Migration triển khai: `V005__leave_content_club.sql`; `V006__content_club_images.sql` bổ sung ảnh bìa cho CMS và CLB.

Giả định còn mở:

- `notification_deliveries` chưa tạo ở `V005`; notification hiện lưu vào bảng `notifications` để phục vụ trung tâm thông báo.
- Hủy đăng ký CLB chưa khóa theo ngày khai giảng; cần chốt `Q-05` trước khi hardening release.

Không lưu `registered_count` như nguồn sự thật nếu chưa có cơ chế cập nhật atomic. Khi cần tối
ưu, có thể thêm counter được bảo vệ bằng transaction/constraint.

## 11. Audit dùng chung

### `audit_events`

| Cột | Kiểu | Ý nghĩa |
|---|---|---|
| `id` | `bigint identity` | PK |
| `actor_account_id` | `bigint` | Nullable cho system job |
| `action` | `varchar(100)` | Ví dụ `GRADE_CORRECTED` |
| `entity_type` | `varchar(100)` | Aggregate bị tác động |
| `entity_id` | `bigint` | ID aggregate |
| `before_json` | `nvarchar(max)` | Dữ liệu trước đã lọc PII |
| `after_json` | `nvarchar(max)` | Dữ liệu sau đã lọc PII |
| `reason` | `nvarchar(500)` | Bắt buộc cho correction quan trọng |
| `trace_id` | `varchar(64)` | Liên kết request/log |
| `occurred_at` | `datetimeoffset(0)` | Thời điểm |

Audit event là append-only. Không dùng nó thay cho các workflow log chuyên biệt cần truy vấn
thường xuyên.

## Index quan trọng

```text
accounts(phone_normalized) UNIQUE
parent_students(parent_id, student_id) UNIQUE
enrollments(student_id, class_id) UNIQUE
teaching_assignments(term_id, class_id, subject_id) UNIQUE
timetable_entries(timetable_id, day_of_week, lesson_period_id) UNIQUE
teaching_sessions(class_id, session_date, lesson_period_id) UNIQUE
attendance_records(teaching_session_id, student_id) UNIQUE
scores(assessment_id, student_id) UNIQUE
published_subject_results(student_id, term_id, subject_id) UNIQUE
leave_requests(student_id, start_date, end_date, status)
notifications(recipient_account_id, read_at, created_at DESC)
club_registrations(club_id, student_id) filtered UNIQUE for active registration
outbox_events(status, available_at)
```

## Constraint cần kiểm thử ở application và database

- Phụ huynh chỉ thao tác với học sinh đã liên kết active.
- Giáo viên chỉ thao tác trong phân công/homeroom assignment active.
- Numeric subject chỉ có `numeric_score`; Pass/Fail subject chỉ có qualitative result.
- Score nằm trong `[0, max_score]`.
- Chỉ một GVCN active cho lớp/năm học.
- Chỉ một gradebook cho teaching assignment.
- Không để một giáo viên hoặc một lớp bị xếp hai tiết trùng cùng ngày/period.
- Đơn `REJECTED` bắt buộc có rejection reason.
- Tối đa ba registration active trên mỗi học sinh cần transaction/application lock; SQL Server
  không biểu diễn trực tiếp bằng simple `CHECK`.
- Số registration active của CLB không vượt capacity.
- Chỉ state transition hợp lệ mới được update.

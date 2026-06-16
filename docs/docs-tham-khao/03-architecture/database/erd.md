# ERD MyFPTSchool

**Trạng thái:** F01-F05 đã triển khai; F06-F08 là logical baseline
ERD được tách theo bounded context để dễ đọc. Quan hệ cross-context được mô tả bằng FK trong
[data dictionary](data-dictionary.md).

## Identity và con người

```mermaid
erDiagram
    accounts ||--o{ account_roles : has
    roles ||--o{ account_roles : assigned
    roles ||--o{ role_permissions : grants
    permissions ||--o{ role_permissions : includes
    accounts ||--o{ refresh_tokens : owns
    accounts ||--o{ device_tokens : registers

    accounts ||--o| teachers : represents
    accounts ||--o| parents : represents
    parents ||--o{ parent_students : links
    students ||--o{ parent_students : links

    accounts {
      bigint id PK
      varchar phone_normalized UK
      nvarchar display_name
      varchar password_hash
      varchar status
      rowversion row_version
    }
    roles {
      bigint id PK
      varchar code UK
      nvarchar name
    }
    permissions {
      bigint id PK
      varchar code UK
    }
    teachers {
      bigint id PK
      bigint account_id FK
      varchar employee_code UK
    }
    parents {
      bigint id PK
      bigint account_id FK
    }
    students {
      bigint id PK
      varchar student_code UK
      nvarchar full_name
      date date_of_birth
      varchar status
    }
```

## Cấu trúc học vụ

```mermaid
erDiagram
    school_levels ||--o{ grade_levels : contains
    school_years ||--o{ terms : contains
    school_years ||--o{ classes : opens
    grade_levels ||--o{ classes : classifies
    classes ||--o{ enrollments : has
    students ||--o{ enrollments : enrolls
    subjects ||--o{ curriculum_subjects : appears
    grade_levels ||--o{ curriculum_subjects : requires
    school_years ||--o{ curriculum_subjects : applies
    terms ||--o{ teaching_assignments : schedules
    classes ||--o{ teaching_assignments : receives
    subjects ||--o{ teaching_assignments : teaches
    teachers ||--o{ teaching_assignments : assigned
    classes ||--o{ homeroom_assignments : has
    teachers ||--o{ homeroom_assignments : leads

    school_years {
      bigint id PK
      varchar code UK
      date start_date
      date end_date
      varchar status
    }
    terms {
      bigint id PK
      bigint school_year_id FK
      varchar code
      varchar period_type
      date start_date
      date end_date
    }
    classes {
      bigint id PK
      bigint school_year_id FK
      bigint grade_level_id FK
      varchar code
      nvarchar name
    }
    enrollments {
      bigint id PK
      bigint student_id FK
      bigint class_id FK
      varchar status
    }
    teaching_assignments {
      bigint id PK
      bigint term_id FK
      bigint class_id FK
      bigint subject_id FK
      bigint teacher_id FK
    }
```

## Thời khóa biểu và điểm danh

```mermaid
erDiagram
    classes ||--o{ timetables : owns
    terms ||--o{ timetables : scopes
    timetable_imports ||--o| timetables : creates
    timetables ||--o{ timetable_entries : contains
    teaching_assignments ||--o{ timetable_entries : realizes
    lesson_periods ||--o{ timetable_entries : occupies
    timetable_entries ||--o{ teaching_sessions : generates
    teaching_sessions ||--o{ attendance_records : records
    students ||--o{ attendance_records : receives
    attendance_records ||--o{ attendance_change_logs : changes

    timetables {
      bigint id PK
      bigint class_id FK
      bigint term_id FK
      varchar status
      datetimeoffset published_at
      rowversion row_version
    }
    timetable_entries {
      bigint id PK
      bigint timetable_id FK
      tinyint day_of_week
      bigint lesson_period_id FK
      bigint teaching_assignment_id FK
      nvarchar room
    }
    teaching_sessions {
      bigint id PK
      bigint timetable_entry_id FK
      date session_date
      varchar status
    }
    attendance_records {
      bigint id PK
      bigint teaching_session_id FK
      bigint student_id FK
      varchar status
      nvarchar note
      bigint leave_request_id FK
      rowversion row_version
    }
```

## Điểm và hạnh kiểm

```mermaid
erDiagram
    school_years ||--o{ grading_policies : configures
    grading_policies ||--o{ assessment_types : defines
    grading_policies ||--o{ academic_rating_rules : rates
    teaching_assignments ||--|| gradebooks : owns
    gradebooks ||--o{ assessments : contains
    assessment_types ||--o{ assessments : classifies
    assessments ||--o{ scores : receives
    students ||--o{ scores : earns
    gradebooks ||--o{ gradebook_workflow_logs : transitions
    students ||--o{ published_subject_results : receives
    terms ||--o{ published_subject_results : scopes
    students ||--o{ conduct_records : receives
    terms ||--o{ conduct_records : scopes
    students ||--o{ student_term_summaries : summarizes
    terms ||--o{ student_term_summaries : scopes

    grading_policies {
      bigint id PK
      bigint school_year_id FK
      bigint grade_level_id FK
      tinyint rounding_scale
      varchar status
    }
    gradebooks {
      bigint id PK
      bigint teaching_assignment_id FK
      varchar status
      datetimeoffset submitted_at
      datetimeoffset published_at
      rowversion row_version
    }
    assessments {
      bigint id PK
      bigint gradebook_id FK
      bigint assessment_type_id FK
      nvarchar title
      date assessment_date
    }
    scores {
      bigint id PK
      bigint assessment_id FK
      bigint student_id FK
      decimal numeric_score
      varchar qualitative_result
      rowversion row_version
    }
```

## Đơn nghỉ, nội dung và CLB

```mermaid
erDiagram
    students ||--o{ leave_requests : requests
    parents ||--o{ leave_requests : submits
    leave_requests ||--o{ leave_request_periods : selects
    leave_requests ||--o{ leave_request_history : transitions

    contents ||--o{ content_targets : targets
    contents ||--o{ content_media : contains
    accounts ||--o{ notifications : receives
    contents ||--o{ notifications : references

    teachers ||--o{ clubs : leads
    clubs ||--o{ club_registrations : receives
    students ||--o{ club_registrations : joins
    parents ||--o{ club_registrations : submits

    leave_requests {
      bigint id PK
      bigint student_id FK
      bigint parent_id FK
      varchar request_type
      date start_date
      date end_date
      nvarchar reason
      varchar status
      rowversion row_version
    }
    contents {
      bigint id PK
      varchar content_type
      varchar status
      nvarchar title
      nvarchar summary
      nvarchar image_url
      nvarchar body
      datetimeoffset event_start_at
      datetimeoffset event_end_at
      nvarchar location
      datetimeoffset published_at
    }
    notifications {
      bigint id PK
      bigint recipient_account_id FK
      nvarchar title
      nvarchar body
      datetimeoffset read_at
    }
    clubs {
      bigint id PK
      nvarchar name
      nvarchar description
      nvarchar image_url
      bigint teacher_id FK
      int capacity
      date start_date
      datetimeoffset registration_open_at
      datetimeoffset registration_close_at
      varchar status
      rowversion row_version
    }
    club_registrations {
      bigint id PK
      bigint club_id FK
      bigint student_id FK
      varchar status
      datetimeoffset registered_at
      rowversion row_version
    }
```

-- =============================================================================
-- MyFPTSchool Database Schema
-- PostgreSQL 15+
-- Generated: 11/06/2026
-- =============================================================================

-- -----------------------------------------------------------------------------
-- EXTENSIONS
-- -----------------------------------------------------------------------------

CREATE EXTENSION IF NOT EXISTS pgcrypto; -- dùng cho password hashing nếu cần

-- -----------------------------------------------------------------------------
-- HELPER: auto-update updated_at
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- NHÓM 1: IDENTITY & AUTH
-- =============================================================================

CREATE TABLE users (
    id          BIGSERIAL    PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role        VARCHAR(20)  NOT NULL
                    CHECK (role IN ('student', 'parent', 'teacher', 'homeroom_teacher', 'admin')),
    is_active   BOOLEAN      NOT NULL DEFAULT true,
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- -----------------------------------------------------------------------------

CREATE TABLE user_sessions (
    id          BIGSERIAL   PRIMARY KEY,
    user_id     BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token       TEXT        NOT NULL UNIQUE,
    platform    VARCHAR(10) NOT NULL CHECK (platform IN ('mobile', 'web')),
    expires_at  TIMESTAMP   NOT NULL,
    created_at  TIMESTAMP   NOT NULL DEFAULT NOW()
);

-- -----------------------------------------------------------------------------

CREATE TABLE campuses (
    id      BIGSERIAL    PRIMARY KEY,
    name    VARCHAR(100) NOT NULL,          -- 'FPT School Alpha Campus'
    address TEXT,
    phone   VARCHAR(20),
    email   VARCHAR(100),
    website VARCHAR(100)
);

-- -----------------------------------------------------------------------------

CREATE TABLE teachers (
    id          BIGSERIAL    PRIMARY KEY,
    user_id     BIGINT       UNIQUE REFERENCES users(id) ON DELETE SET NULL,
    full_name   VARCHAR(100) NOT NULL,
    phone       VARCHAR(20),
    email       VARCHAR(100),
    campus_id   BIGINT       REFERENCES campuses(id)
);

-- -----------------------------------------------------------------------------

CREATE TABLE academic_years (
    id         BIGSERIAL   PRIMARY KEY,
    label      VARCHAR(20) NOT NULL UNIQUE, -- '2025-2026'
    start_date DATE        NOT NULL,
    end_date   DATE        NOT NULL
);

-- -----------------------------------------------------------------------------

CREATE TABLE semesters (
    id               BIGSERIAL   PRIMARY KEY,
    academic_year_id BIGINT      NOT NULL REFERENCES academic_years(id),
    name             VARCHAR(10) NOT NULL CHECK (name IN ('HK I', 'HK II')),
    start_date       DATE        NOT NULL,
    end_date         DATE        NOT NULL,
    UNIQUE (academic_year_id, name)
);

-- -----------------------------------------------------------------------------

CREATE TABLE classrooms (
    id                  BIGSERIAL   PRIMARY KEY,
    name                VARCHAR(20) NOT NULL,               -- '10A1'
    grade_level         SMALLINT    NOT NULL CHECK (grade_level IN (10, 11, 12)),
    campus_id           BIGINT      NOT NULL REFERENCES campuses(id),
    homeroom_teacher_id BIGINT      REFERENCES teachers(id),
    academic_year_id    BIGINT      NOT NULL REFERENCES academic_years(id),
    UNIQUE (name, academic_year_id, campus_id)
);

-- -----------------------------------------------------------------------------

CREATE TABLE students (
    id           BIGSERIAL    PRIMARY KEY,
    user_id      BIGINT       UNIQUE REFERENCES users(id) ON DELETE SET NULL,
    student_code VARCHAR(20)  NOT NULL UNIQUE,  -- 'HS20260018'
    full_name    VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender       VARCHAR(10)  CHECK (gender IN ('Nam', 'Nữ', 'Khác')),
    phone        VARCHAR(20),
    email        VARCHAR(100),
    classroom_id BIGINT       REFERENCES classrooms(id),
    campus_id    BIGINT       REFERENCES campuses(id)
);

-- -----------------------------------------------------------------------------

CREATE TABLE parents (
    id          BIGSERIAL    PRIMARY KEY,
    user_id     BIGINT       UNIQUE REFERENCES users(id) ON DELETE SET NULL,
    parent_code VARCHAR(20)  NOT NULL UNIQUE,   -- 'PH20260018'
    full_name   VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender      VARCHAR(10)  CHECK (gender IN ('Nam', 'Nữ', 'Khác')),
    phone       VARCHAR(20),
    email       VARCHAR(100)
);

-- -----------------------------------------------------------------------------

-- Một phụ huynh có thể liên kết nhiều học sinh (n-n)
CREATE TABLE parent_students (
    parent_id  BIGINT NOT NULL REFERENCES parents(id) ON DELETE CASCADE,
    student_id BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    PRIMARY KEY (parent_id, student_id)
);

-- =============================================================================
-- NHÓM 2: CẤU TRÚC HỌC THUẬT
-- =============================================================================

CREATE TABLE subjects (
    id                        BIGSERIAL   PRIMARY KEY,
    name                      VARCHAR(50) NOT NULL,   -- 'Toán', 'Ngữ Văn'
    color_hex                 VARCHAR(7),              -- '#F37021'
    sessions_per_semester     SMALLINT                 -- 70, 52, 35
);

-- -----------------------------------------------------------------------------

-- Phân công giảng dạy: giáo viên nào dạy môn nào, lớp nào, học kỳ nào
CREATE TABLE classroom_subjects (
    id           BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT    NOT NULL REFERENCES classrooms(id),
    subject_id   BIGINT    NOT NULL REFERENCES subjects(id),
    teacher_id   BIGINT    NOT NULL REFERENCES teachers(id),
    semester_id  BIGINT    NOT NULL REFERENCES semesters(id),
    UNIQUE (classroom_id, subject_id, semester_id)
);

-- =============================================================================
-- NHÓM 3: THỜI KHÓA BIỂU
-- =============================================================================

-- 10 tiết chuẩn THPT, dữ liệu tĩnh (seed 1 lần)
CREATE TABLE time_slots (
    id          SMALLSERIAL PRIMARY KEY,
    slot_number SMALLINT    NOT NULL UNIQUE,  -- 1-10
    start_time  TIME        NOT NULL,
    end_time    TIME        NOT NULL
);

-- -----------------------------------------------------------------------------

CREATE TABLE rooms (
    id        BIGSERIAL   PRIMARY KEY,
    code      VARCHAR(30) NOT NULL,             -- 'Phòng 201', 'Phòng Lab 1'
    campus_id BIGINT      NOT NULL REFERENCES campuses(id),
    UNIQUE (code, campus_id)
);

-- -----------------------------------------------------------------------------

CREATE TABLE lessons (
    id                   BIGSERIAL   PRIMARY KEY,
    classroom_subject_id BIGINT      NOT NULL REFERENCES classroom_subjects(id),
    lesson_date          DATE        NOT NULL,
    start_slot_id        SMALLINT    NOT NULL REFERENCES time_slots(id),
    end_slot_id          SMALLINT    NOT NULL REFERENCES time_slots(id),
    room_id              BIGINT      REFERENCES rooms(id),
    status               VARCHAR(20) NOT NULL DEFAULT 'scheduled'
                             CHECK (status IN ('scheduled', 'completed', 'cancelled', 'makeup')),
    has_materials        BOOLEAN     NOT NULL DEFAULT false,
    note                 TEXT,
    UNIQUE (classroom_subject_id, lesson_date, start_slot_id)
);

-- =============================================================================
-- NHÓM 4: ĐIỂM DANH
-- =============================================================================

CREATE TABLE attendance_records (
    id          BIGSERIAL   PRIMARY KEY,
    student_id  BIGINT      NOT NULL REFERENCES students(id),
    lesson_id   BIGINT      NOT NULL REFERENCES lessons(id),
    status      VARCHAR(20) NOT NULL
                    CHECK (status IN ('present', 'late', 'excused_absent', 'unexcused_absent')),
    note        TEXT,
    recorded_by BIGINT      REFERENCES users(id),
    recorded_at TIMESTAMP   NOT NULL DEFAULT NOW(),
    UNIQUE (student_id, lesson_id)
);

-- =============================================================================
-- NHÓM 5: ĐIỂM SỐ
-- =============================================================================

-- Cấu hình đầu điểm, dữ liệu tĩnh (seed 1 lần)
CREATE TABLE score_components (
    id            SMALLSERIAL PRIMARY KEY,
    code          VARCHAR(10) NOT NULL UNIQUE,  -- 'TX1', 'TX2', 'TX3', 'DGKK', 'DCK'
    name          VARCHAR(50) NOT NULL,
    weight        SMALLINT    NOT NULL,          -- 1, 1, 1, 2, 3
    display_order SMALLINT    NOT NULL
);

-- -----------------------------------------------------------------------------

CREATE TABLE grade_records (
    id                   BIGSERIAL      PRIMARY KEY,
    student_id           BIGINT         NOT NULL REFERENCES students(id),
    classroom_subject_id BIGINT         NOT NULL REFERENCES classroom_subjects(id),
    component_id         SMALLINT       NOT NULL REFERENCES score_components(id),
    score                NUMERIC(4, 2)  CHECK (score >= 0 AND score <= 10),
    recorded_by          BIGINT         REFERENCES users(id),
    recorded_at          TIMESTAMP      NOT NULL DEFAULT NOW(),
    UNIQUE (student_id, classroom_subject_id, component_id)
);

-- =============================================================================
-- NHÓM 6: THÔNG BÁO
-- =============================================================================

CREATE TABLE notifications (
    id          BIGSERIAL    PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    body        TEXT         NOT NULL,
    category    VARCHAR(20)  NOT NULL
                    CHECK (category IN ('attendance', 'grade', 'homeroom', 'study', 'event')),
    target_type VARCHAR(20)  NOT NULL
                    CHECK (target_type IN ('individual', 'classroom', 'all')),
    -- student_id nếu individual, classroom_id nếu classroom, NULL nếu all
    target_id   BIGINT,
    created_by  BIGINT       REFERENCES users(id),
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- -----------------------------------------------------------------------------

-- Fanout-on-write: mỗi người nhận là 1 row
CREATE TABLE notification_recipients (
    id              BIGSERIAL PRIMARY KEY,
    notification_id BIGINT    NOT NULL REFERENCES notifications(id) ON DELETE CASCADE,
    user_id         BIGINT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    is_read         BOOLEAN   NOT NULL DEFAULT false,
    read_at         TIMESTAMP,
    UNIQUE (notification_id, user_id)
);

-- =============================================================================
-- INDEXES
-- =============================================================================

-- Auth
CREATE INDEX idx_user_sessions_token   ON user_sessions(token);
CREATE INDEX idx_user_sessions_user    ON user_sessions(user_id);

-- Timetable — query thường: lấy lịch theo ngày, theo lớp
CREATE INDEX idx_lessons_date          ON lessons(lesson_date);
CREATE INDEX idx_lessons_cs_date       ON lessons(classroom_subject_id, lesson_date);

-- Attendance — query thường: lấy điểm danh theo học sinh, theo tiết
CREATE INDEX idx_attendance_student    ON attendance_records(student_id);
CREATE INDEX idx_attendance_lesson     ON attendance_records(lesson_id);

-- Grades — query thường: lấy điểm theo học sinh + môn
CREATE INDEX idx_grade_student         ON grade_records(student_id);
CREATE INDEX idx_grade_cs              ON grade_records(classroom_subject_id);

-- Notifications — query thường: lấy thông báo chưa đọc của user
CREATE INDEX idx_notif_recipients_user ON notification_recipients(user_id, is_read);

-- =============================================================================
-- VIEWS (computed, không lưu bảng riêng)
-- =============================================================================

CREATE VIEW attendance_summary AS
SELECT
    ar.student_id,
    cs.subject_id,
    cs.semester_id,
    cs.classroom_id,
    COUNT(*)                                                        AS total_sessions,
    COUNT(*) FILTER (WHERE ar.status = 'present')                  AS present_sessions,
    COUNT(*) FILTER (WHERE ar.status = 'late')                     AS late_sessions,
    COUNT(*) FILTER (WHERE ar.status = 'excused_absent')           AS excused_absent,
    COUNT(*) FILTER (WHERE ar.status = 'unexcused_absent')         AS unexcused_absent,
    COUNT(*) FILTER (WHERE ar.status IN ('excused_absent', 'unexcused_absent')) AS total_absent
FROM attendance_records ar
JOIN lessons             l  ON ar.lesson_id             = l.id
JOIN classroom_subjects  cs ON l.classroom_subject_id   = cs.id
GROUP BY ar.student_id, cs.subject_id, cs.semester_id, cs.classroom_id;

-- -----------------------------------------------------------------------------

-- Công thức: ĐTK = SUM(score × weight) / SUM(weight)
-- Với: TX1=×1, TX2=×1, TX3=×1, ĐGKK=×2, ĐCK=×3  →  tổng hệ số = 8
CREATE VIEW grade_summary AS
SELECT
    gr.student_id,
    gr.classroom_subject_id,
    cs.subject_id,
    cs.semester_id,
    cs.classroom_id,
    ROUND(
        SUM(gr.score * sc.weight) / NULLIF(SUM(sc.weight), 0),
        1
    )                   AS final_grade,
    COUNT(gr.id)        AS components_filled,
    (SELECT COUNT(*) FROM score_components) AS components_total
FROM grade_records       gr
JOIN score_components    sc ON gr.component_id          = sc.id
JOIN classroom_subjects  cs ON gr.classroom_subject_id  = cs.id
GROUP BY gr.student_id, gr.classroom_subject_id, cs.subject_id, cs.semester_id, cs.classroom_id;

-- =============================================================================
-- SEED DATA (dữ liệu tĩnh, không thay đổi)
-- =============================================================================

INSERT INTO time_slots (slot_number, start_time, end_time) VALUES
    (1,  '07:00', '07:45'),
    (2,  '07:50', '08:35'),
    (3,  '08:45', '09:30'),
    (4,  '09:35', '10:20'),
    (5,  '10:30', '11:15'),
    (6,  '11:20', '12:05'),
    (7,  '13:00', '13:45'),
    (8,  '13:50', '14:35'),
    (9,  '14:45', '15:30'),
    (10, '15:35', '16:20');

INSERT INTO score_components (code, name, weight, display_order) VALUES
    ('TX1',  'Điểm thường xuyên 1', 1, 1),
    ('TX2',  'Điểm thường xuyên 2', 1, 2),
    ('TX3',  'Điểm thường xuyên 3', 1, 3),
    ('DGKK', 'Đánh giá giữa kỳ',   2, 4),
    ('DCK',  'Điểm cuối kỳ',        3, 5);

-- =============================================================================
-- BACKLOG — chưa implement, thêm khi cần
-- =============================================================================

-- [Phase 3] Lịch sử lớp học của học sinh qua các năm
--
-- Vấn đề: students.classroom_id chỉ lưu lớp HIỆN TẠI. Khi học sinh lên lớp,
-- field này bị ghi đè và không biết năm trước học lớp nào.
-- Lịch sử attendance/grade vẫn còn nguyên (truy ngược qua classroom_subjects),
-- nhưng nếu cần report "học bạ theo năm" hoặc "lịch sử lớp" thì cần bảng này.
--
-- CREATE TABLE student_enrollments (
--     id           BIGSERIAL PRIMARY KEY,
--     student_id   BIGINT    NOT NULL REFERENCES students(id),
--     classroom_id BIGINT    NOT NULL REFERENCES classrooms(id),
--     start_date   DATE      NOT NULL,
--     end_date     DATE,                    -- NULL nếu đang là lớp hiện tại
--     UNIQUE (student_id, classroom_id)
-- );
--
-- Khi dùng: bỏ students.classroom_id, thay bằng query:
--   SELECT classroom_id FROM student_enrollments
--   WHERE student_id = ? AND end_date IS NULL
--   LIMIT 1;

# Cấu trúc dự án

**Trạng thái:** Proposed baseline  
**Cập nhật:** 2026-06-15

Tài liệu này là contract về vị trí file và dependency direction. Source hiện tại vẫn là
scaffold; chỉ tạo folder khi có code thực tế, không commit folder rỗng.

## Repository root

```text
prm393_course_project/
├── .agents/
│   ├── rules/                         # Rule cho Antigravity
│   ├── skills/                        # Project skills cho Codex
│   └── workflows/                     # Workflow Antigravity
├── docs/
│   ├── 00-project/                    # Tầm nhìn, glossary, câu hỏi mở
│   ├── 01-business/                   # Actor, RBAC, workflow
│   ├── 02-requirements/               # Màn hình, use case, acceptance criteria
│   ├── 03-architecture/               # C4, API, database, ADR, structure
│   ├── 04-design/                     # Design tokens và UI conventions
│   ├── 05-quality/                    # DoD, NFR, test strategy
│   ├── 06-ai/                         # Quy ước cộng tác với AI
│   └── 07-references/                 # Nguồn tham khảo
├── mysfchoolse1911webapp/             # React Admin + Teacher
├── myfschoolse1911/                   # Flutter Parent App
├── myfschoolse1911backend/            # Spring Boot API
├── AGENTS.md
├── GEMINI.md
└── README.md
```

Repository hiện là monorepo theo nghĩa quản lý chung source và tài liệu, nhưng ba application
vẫn build/deploy độc lập.

## React web

**Ứng dụng:** `mysfchoolse1911webapp`  
**Portal:** School Admin Portal và Teacher Workspace.

### Cây thư mục đích

```text
mysfchoolse1911webapp/
├── public/
├── src/
│   ├── app/
│   │   ├── App.jsx                    # Composition root
│   │   ├── router/                    # Route definitions, lazy loading
│   │   ├── providers/                 # Auth, query, theme, error boundary
│   │   ├── layouts/                   # AdminLayout, TeacherLayout
│   │   └── config/                    # Runtime-safe client config
│   ├── features/
│   │   ├── auth/
│   │   ├── accounts/
│   │   ├── rbac/
│   │   ├── academic-structure/
│   │   ├── timetable/
│   │   ├── attendance/
│   │   ├── gradebook/
│   │   ├── conduct/
│   │   ├── leave-requests/
│   │   ├── content/
│   │   ├── notifications/
│   │   └── clubs/
│   ├── shared/
│   │   ├── api/                       # HTTP client, interceptors, error mapper
│   │   ├── auth/                      # PermissionGate, session helpers
│   │   ├── components/                # Component dùng lại thực sự
│   │   ├── design-system/             # Token/theme/component primitives
│   │   ├── hooks/
│   │   ├── lib/                       # Wrapper thư viện ngoài
│   │   ├── types/                     # Kiểu dùng xuyên feature
│   │   └── utils/
│   ├── assets/
│   ├── main.jsx
│   └── index.css
├── tests/
│   ├── integration/
│   └── fixtures/
├── .env.example
├── eslint.config.js
├── package.json
└── vite.config.js
```

### Cấu trúc một feature

```text
features/attendance/
├── api/
│   ├── attendanceApi.js
│   └── attendanceKeys.js
├── components/
├── hooks/
├── pages/
├── schemas/                            # Form/request validation
├── model/                              # UI/domain types và state thuần
├── routes.js
└── index.js                            # Public API của feature
```

### Quy tắc dependency

```text
app -> features -> shared
feature A -X-> internal file của feature B
```

- Feature chỉ import feature khác qua public API `index`.
- `shared` không import `features`.
- Component không gọi HTTP trực tiếp; đi qua feature API/hook.
- Không rải `role === ...`; UI kiểm tra permission code qua `PermissionGate`.
- Dữ liệu server không được sao chép tùy tiện vào global client state.
- Chưa tạo `shared/components` cho component chỉ dùng một feature.

### JavaScript hay TypeScript

Source hiện là JavaScript. Trước feature production đầu tiên nên chốt ADR chuyển TypeScript.
Nếu chưa chuyển, giữ JSDoc/schema validation để tránh contract ngầm; không trộn `.js/.ts`
thiếu kế hoạch.

## Flutter Parent App

**Ứng dụng:** `myfschoolse1911`
**Kiến trúc:** MVC đơn giản.

`vn/edu/fpt` chỉ là namespace thư mục theo convention của dự án. Import Dart vẫn dùng package:

```dart
import 'package:myfschoolse1911/vn/edu/fpt/app.dart';
```

### Cây thư mục đích

```text
myfschoolse1911/
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── images/
├── lib/
│   ├── main.dart                         # Entry point duy nhất
│   └── vn/
│       └── edu/
│           └── fpt/
│               ├── app.dart              # MaterialApp, theme, router
│               ├── config/
│               │   ├── app_config.dart
│               │   └── environment.dart
│               ├── constant/
│               │   ├── api_constants.dart
│               │   ├── app_constants.dart
│               │   └── permission_constants.dart
│               ├── controller/
│               │   ├── auth_controller.dart
│               │   ├── dashboard_controller.dart
│               │   ├── timetable_controller.dart
│               │   ├── attendance_controller.dart
│               │   ├── grade_controller.dart
│               │   ├── notification_controller.dart
│               │   ├── leave_request_controller.dart
│               │   ├── club_controller.dart
│               │   └── profile_controller.dart
│               ├── model/
│               │   ├── account.dart
│               │   ├── student.dart
│               │   ├── timetable_entry.dart
│               │   ├── attendance_record.dart
│               │   ├── grade.dart
│               │   ├── notification.dart
│               │   ├── leave_request.dart
│               │   ├── club.dart
│               │   ├── request/          # API request DTO
│               │   └── response/         # API response DTO
│               ├── repository/
│               │   ├── auth_repository.dart
│               │   ├── student_repository.dart
│               │   ├── academic_repository.dart
│               │   ├── notification_repository.dart
│               │   └── club_repository.dart
│               ├── service/
│               │   ├── api_client.dart
│               │   ├── auth_service.dart
│               │   ├── academic_service.dart
│               │   ├── notification_service.dart
│               │   ├── secure_storage_service.dart
│               │   └── push_notification_service.dart
│               ├── route/
│               │   ├── app_routes.dart
│               │   └── route_generator.dart
│               ├── theme/
│               │   ├── app_colors.dart
│               │   ├── app_text_styles.dart
│               │   └── app_theme.dart
│               ├── util/
│               │   ├── date_time_util.dart
│               │   ├── format_util.dart
│               │   ├── phone_util.dart
│               │   ├── validation_util.dart
│               │   └── result.dart
│               └── view/
│                   ├── auth/
│                   ├── dashboard/
│                   ├── timetable/
│                   ├── attendance/
│                   ├── grades/
│                   ├── notifications/
│                   ├── leave_requests/
│                   ├── clubs/
│                   ├── profile/
│                   └── widget/           # Widget dùng chung nhiều màn hình
├── test/
│   ├── controller/
│   ├── repository/
│   ├── service/
│   ├── util/
│   ├── view/
│   └── fixtures/
├── integration_test/
└── pubspec.yaml
```

### Trách nhiệm từng tầng

| Thư mục | Trách nhiệm |
|---|---|
| `view/` | Screen, dialog và widget; chỉ render state và chuyển user action |
| `controller/` | Quản lý state màn hình, validation luồng và gọi repository/service |
| `model/` | Model ứng dụng và DTO request/response |
| `service/` | HTTP, secure storage, push và tích hợp platform/provider |
| `repository/` | Điều phối nguồn dữ liệu, cache, mapping DTO sang model |
| `route/` | Tên route và điều hướng |
| `theme/` | Token Flutter lấy từ `docs/04-design/design.md` |
| `config/` | Base URL và cấu hình theo môi trường, không chứa secret |
| `constant/` | Hằng số ổn định, không chứa mutable state |
| `util/` | Hàm thuần nhỏ như format/validation; không chứa business workflow |

### Quy tắc dependency

```text
View -> Controller -> Repository -> Service
                    -> Model
View -> Theme / Route / shared Widget
```

- View không gọi HTTP, secure storage hoặc repository trực tiếp.
- Controller không tự parse JSON hoặc biết chi tiết HTTP.
- Service không giữ UI state và không import View/Controller.
- Repository không phụ thuộc View; dùng để phối hợp API/cache và map dữ liệu.
- DTO response không đi thẳng lên View nếu cấu trúc API khác model hiển thị.
- Business rule chính thức vẫn ở backend; mobile chỉ validation và orchestration UX.
- `view/widget` chỉ chứa widget dùng ở ít nhất hai nhóm màn hình.
- Secure storage chứa token; không dùng preferences thường cho secret.
- Student context được quản lý qua controller/repository rõ ràng, không dùng biến global.

### Controller state

- Với scaffold đơn giản, ưu tiên `ChangeNotifier` hoặc `ValueNotifier`.
- Mỗi controller có state rõ: `initial`, `loading`, `success`, `empty`, `error`.
- Không tạo một `AppController` khổng lồ quản lý toàn bộ ứng dụng.
- Khi một controller vượt khoảng 300 dòng hoặc quản lý nhiều workflow độc lập, tách theo màn
  hình/use case thay vì đẩy logic sang `util`.

### Ví dụ luồng đăng ký CLB

```text
ClubView
  -> ClubController.register(studentId, clubId)
  -> ClubRepository.register(...)
  -> ClubService.postRegistration(...)
  -> API
```

Controller cập nhật loading/error/success. Kiểm tra quota và giới hạn ba CLB vẫn do backend
thực thi; mobile chỉ phản ánh lỗi `409`.

## Spring Boot backend

**Ứng dụng:** `myfschoolse1911backend`  
**Base package hiện tại:** `vn.edu.fpt.myfschoolse1911backend`

Không đổi base package chỉ để đẹp khi chưa có ADR/migration kế hoạch. Các module nằm bên dưới
base package hiện tại.

### Cây thư mục đích

```text
myfschoolse1911backend/
├── src/
│   ├── main/
│   │   ├── java/vn/edu/fpt/myfschoolse1911backend/
│   │   │   ├── Myfschoolse1911backendApplication.java
│   │   │   ├── common/
│   │   │   │   ├── api/
│   │   │   │   ├── error/
│   │   │   │   ├── persistence/
│   │   │   │   ├── time/
│   │   │   │   └── validation/
│   │   │   ├── security/
│   │   │   ├── identity/
│   │   │   ├── people/
│   │   │   ├── academic/
│   │   │   ├── timetable/
│   │   │   ├── attendance/
│   │   │   ├── assessment/
│   │   │   ├── conduct/
│   │   │   ├── leave/
│   │   │   ├── content/
│   │   │   ├── notification/
│   │   │   ├── club/
│   │   │   └── audit/
│   │   └── resources/
│   │       ├── db/migration/           # Flyway V*.sql
│   │       ├── application.yaml
│   │       ├── application-local.yaml
│   │       ├── application-test.yaml
│   │       └── application-prod.yaml
│   └── test/
│       ├── java/.../
│       │   ├── unit/
│       │   ├── integration/
│       │   ├── architecture/
│       │   └── support/
│       └── resources/
└── pom.xml
```

### Cấu trúc một module

```text
attendance/
├── api/
│   ├── AttendanceController.java
│   ├── AttendanceRequest.java
│   ├── AttendanceResponse.java
│   └── AttendanceExceptionHandler.java
├── application/
│   ├── AttendanceService.java
│   ├── command/
│   ├── query/
│   └── port/
├── domain/
│   ├── AttendanceRecord.java
│   ├── AttendanceStatus.java
│   ├── AttendancePolicy.java
│   └── event/
└── infrastructure/
    ├── persistence/
    │   ├── AttendanceJpaEntity.java
    │   ├── SpringDataAttendanceRepository.java
    │   └── AttendanceMapper.java
    └── notification/
```

Không cần tạo đủ mọi folder nếu module đơn giản. Giữ bốn ownership:

- `api`: HTTP boundary và validation cú pháp.
- `application`: use case, authorization scope, transaction.
- `domain`: invariant, state transition, value object.
- `infrastructure`: JPA, file, push và adapter ngoài.

### Quy tắc dependency

```text
api -> application -> domain
infrastructure -> application/domain
domain -X-> Spring Web, JPA, Security
module A -X-> infrastructure của module B
```

- Giao tiếp module qua application facade, domain event hoặc ID; không join object graph tùy tiện.
- Controller không gọi repository.
- JPA entity không được trả ra API.
- `@Transactional` đặt ở application use case, không đặt tùy tiện ở controller.
- Security annotation không thay data-scope check trong application service.
- Shared `common` chỉ chứa concern thực sự dùng chung, không trở thành “miscellaneous”.

### Migration và configuration

- Migration: `src/main/resources/db/migration/V001__baseline_identity.sql`.
- Không sửa migration đã chạy ở môi trường dùng chung.
- Secret lấy từ environment/secret manager.
- `application-prod.yaml` không chứa credential.
- Hibernate production dùng `ddl-auto=validate`.

## Vị trí test

| Loại | Web | Flutter | Backend |
|---|---|---|---|
| Unit | Gần feature hoặc `tests/` | `test/controller`, `repository`, `service`, `util` | `src/test/.../unit/` |
| Component/widget | Feature components | `test/view/` | Không áp dụng |
| Integration | `tests/integration/` | `integration_test/` | `src/test/.../integration/` |
| Authorization | Route UX | Student context UX | API/application bắt buộc |
| Architecture | ESLint/import rule | Analyzer/lint | ArchUnit đề xuất |
| Database | Không áp dụng | Không áp dụng | Testcontainers SQL Server |

## Naming

| Khu vực | Quy ước |
|---|---|
| React component | `PascalCase.jsx` |
| React hook | `useSomething.js` |
| React feature folder | `kebab-case` |
| Dart file/folder | `snake_case` |
| Dart class | `PascalCase` |
| Java package | lowercase |
| Java class | `PascalCase` |
| REST path | plural `kebab-case` |
| JSON field | `camelCase` |
| Database table/column | plural `snake_case` |
| Permission | `module.action` |

## Cách quyết định đặt file

1. Web/backend: file thuộc business capability cụ thể thì đặt trong feature/module đó.
2. Flutter: chọn tầng MVC trước, sau đó đặt tên file theo nghiệp vụ.
3. File dùng bởi ít nhất hai feature và không chứa business ownership: cân nhắc shared/common.
4. File tích hợp framework/provider: đặt trong infrastructure/service wrapper.
5. Business rule backend: không đặt trong controller, widget hoặc mapper.
6. Không biết đặt đâu không phải lý do đẩy file vào `util` hoặc `common`.

## Không làm

- Không tổ chức toàn bộ backend thành `controller/service/repository/entity` ở cấp root.
- Không tổ chức toàn bộ frontend thành một thư mục `components` khổng lồ.
- Không tạo abstraction chỉ vì “sau này có thể cần”.
- Không chia sẻ trực tiếp model persistence cho React/Flutter.
- Không tạo folder rỗng hàng loạt; cấu trúc phát triển cùng feature.

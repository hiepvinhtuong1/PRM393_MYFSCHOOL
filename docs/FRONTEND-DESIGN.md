# Frontend Design: MyFPTSchool Web Admin (React)

Stack: React 18 · TypeScript · Vite · TanStack Query · React Router v6 · Tailwind CSS · shadcn/ui

---

## 1. Kiến trúc tổng quan

Đây là **Web Admin** — nền tảng dành cho Giáo viên, GVCN, Admin. Mobile Flutter chỉ đọc; mọi dữ liệu học sinh thấy trên app đều được tạo ra từ đây.

```
Browser
  └── React App (SPA)
        ├── Auth Guard → kiểm tra JWT, redirect nếu chưa đăng nhập
        ├── Role Guard → ẩn/hiện tính năng theo role
        └── API Layer (TanStack Query + Axios) → /api/v1/admin/...
```

**Roles và phạm vi:**

| Role | Viết tắt | Tính năng |
|------|----------|-----------|
| `ADMIN` | A | Toàn quyền |
| `HOMEROOM_TEACHER` | HT | Điểm danh lớp mình, xem học sinh lớp mình, gửi thông báo |
| `TEACHER` | T | Điểm danh + nhập điểm môn mình dạy |

---

## 2. Cấu trúc project

```
src/
├── app/
│   ├── App.tsx                    # Route setup, providers
│   ├── router.tsx                 # React Router v6 route tree
│   └── providers.tsx              # QueryClient, AuthProvider, ThemeProvider
│
├── shared/                        # Dùng chung, không thuộc domain
│   ├── components/
│   │   ├── ui/                    # shadcn/ui re-exports + custom overrides
│   │   ├── layout/
│   │   │   ├── AppShell.tsx       # Sidebar + topbar wrapper
│   │   │   ├── Sidebar.tsx
│   │   │   └── Topbar.tsx
│   │   ├── DataTable.tsx          # Bảng chung có sort, filter, pagination
│   │   ├── PageHeader.tsx         # Title + breadcrumb + actions
│   │   ├── StatusBadge.tsx        # Pill badge dùng chung
│   │   ├── EmptyState.tsx
│   │   ├── ErrorState.tsx
│   │   └── ConfirmDialog.tsx
│   ├── hooks/
│   │   ├── useAuth.ts             # JWT context + role helpers
│   │   └── usePagination.ts
│   ├── lib/
│   │   ├── api.ts                 # Axios instance + interceptors
│   │   ├── queryKeys.ts           # Tất cả TanStack Query keys
│   │   └── utils.ts               # cn(), format helpers
│   └── types/
│       ├── api.ts                 # ApiResponse<T>, PageResponse<T>
│       └── models.ts              # Shared model types
│
├── features/
│   ├── auth/
│   │   ├── LoginPage.tsx
│   │   └── api.ts                 # POST /auth/login
│   │
│   ├── dashboard/
│   │   ├── DashboardPage.tsx      # Trang chủ admin
│   │   └── components/
│   │       ├── StatCard.tsx
│   │       └── QuickActions.tsx
│   │
│   ├── students/
│   │   ├── StudentListPage.tsx
│   │   ├── StudentDetailPage.tsx
│   │   ├── StudentFormPage.tsx    # Thêm/sửa học sinh
│   │   ├── components/
│   │   │   ├── StudentTable.tsx
│   │   │   └── StudentForm.tsx
│   │   └── api.ts                 # GET/POST/PUT /admin/students
│   │
│   ├── teachers/
│   │   ├── TeacherListPage.tsx
│   │   ├── TeacherFormPage.tsx
│   │   └── api.ts
│   │
│   ├── academic/
│   │   ├── ClassroomListPage.tsx  # Chỉ xem (30 lớp cố định)
│   │   ├── AssignmentPage.tsx     # Phân công GV ↔ môn ↔ lớp
│   │   └── api.ts
│   │
│   ├── timetable/
│   │   ├── TimetablePage.tsx      # Xem + tạo tiết học
│   │   ├── components/
│   │   │   └── TimetableGrid.tsx
│   │   └── api.ts
│   │
│   ├── attendance/
│   │   ├── AttendanceSessionPage.tsx   # Nhập điểm danh 1 tiết
│   │   ├── AttendanceReportPage.tsx    # Báo cáo toàn lớp
│   │   ├── components/
│   │   │   ├── AttendanceTable.tsx
│   │   │   └── AttendanceSummaryCard.tsx
│   │   └── api.ts
│   │
│   ├── grades/
│   │   ├── GradeEntryPage.tsx          # Nhập điểm môn × lớp
│   │   ├── components/
│   │   │   ├── GradeEntryTable.tsx     # Spreadsheet-style grid
│   │   │   └── GradeSummaryTable.tsx
│   │   └── api.ts
│   │
│   └── notifications/
│       ├── NotificationListPage.tsx
│       ├── NotificationComposePage.tsx
│       └── api.ts
│
└── main.tsx
```

---

## 3. Routing

```
/                         → redirect → /dashboard
/login                    → LoginPage (public)

/dashboard                → DashboardPage
/students                 → StudentListPage           [ADMIN, HT]
/students/new             → StudentFormPage           [ADMIN]
/students/:id             → StudentDetailPage         [ADMIN, HT]
/students/:id/edit        → StudentFormPage           [ADMIN]

/teachers                 → TeacherListPage           [ADMIN]
/teachers/new             → TeacherFormPage           [ADMIN]
/teachers/:id/edit        → TeacherFormPage           [ADMIN]

/classrooms               → ClassroomListPage         [ADMIN, HT]
/assignments              → AssignmentPage            [ADMIN]

/timetable                → TimetablePage             [ADMIN]

/attendance               → AttendanceSessionPage     [T, HT, ADMIN]
/attendance/report        → AttendanceReportPage      [HT, ADMIN]

/grades                   → GradeEntryPage            [T, ADMIN]

/notifications            → NotificationListPage      [HT, ADMIN]
/notifications/new        → NotificationComposePage   [HT, ADMIN]
```

Route tree dùng React Router v6 nested routes với một `ProtectedLayout` wrapper kiểm tra JWT và role.

---

## 4. Layout Shell

```
┌─────────────────────────────────────────────────┐
│ Topbar (64px)                                   │
│  Logo | Tên trường      [Bell] [Avatar ▾]       │
├──────────────┬──────────────────────────────────┤
│              │                                  │
│  Sidebar     │  Page Content                    │
│  (240px)     │  ┌────────────────────────────┐  │
│              │  │ PageHeader                 │  │
│  Dashboard   │  │  Title + Breadcrumb        │  │
│  ──────────  │  │  [Actions]                 │  │
│  Học vụ      │  └────────────────────────────┘  │
│   Học sinh   │                                  │
│   Giáo viên  │  Content Area                    │
│   Lớp học    │  (scrollable)                    │
│  ──────────  │                                  │
│  Giảng dạy   │                                  │
│   Phân công  │                                  │
│   TKB        │                                  │
│  ──────────  │                                  │
│  Nghiệp vụ   │                                  │
│   Điểm danh  │                                  │
│   Điểm số    │                                  │
│   Thông báo  │                                  │
│              │                                  │
└──────────────┴──────────────────────────────────┘
```

Sidebar collapse về 64px (icon only) trên màn hình nhỏ hơn 1280px.

---

## 5. Design Tokens

Dùng chung design system với DESIGN.md (mobile) — chuyển sang Tailwind CSS variables.

### Màu sắc

```css
/* tailwind.config.ts */
colors: {
  brand: {
    orange:    '#F37021',   /* Primary CTA, active nav */
    blue:      '#0078D7',   /* Links, info badges */
    green:     '#00A651',   /* Success */
  },
  status: {
    warning:   '#F59E0B',
    danger:    '#EF4444',
    info:      '#3B82F6',
  },
  surface: {
    bg:        '#F8FAFC',   /* Trang nền */
    card:      '#FFFFFF',   /* Card, modal */
    elevated:  '#F1F5F9',   /* Disabled, skeleton */
  },
  border: {
    light:     '#E2E8F0',
    medium:    '#CBD5E1',
  },
  text: {
    primary:   '#0F172A',
    secondary: '#64748B',
    tertiary:  '#94A3B8',
  },
}
```

### Typography

Font: **Inter** (Google Fonts)

| Token | Size | Weight | Dùng cho |
|-------|------|--------|---------|
| `text-2xl font-bold` | 24px/700 | Tiêu đề trang |
| `text-xl font-semibold` | 20px/600 | Tiêu đề section, card header |
| `text-base font-semibold` | 16px/600 | Tên cột bảng, label form |
| `text-sm` | 14px/400 | Body text, ô bảng |
| `text-xs font-medium` | 12px/500 | Badge, timestamp, caption |
| `text-sm font-semibold tabular-nums` | 14px/600 | Điểm số, GPA |

### Spacing (4px base)

```
xs  = 4px   gap nhỏ trong badge
sm  = 8px   padding nội card nhỏ
md  = 16px  padding card, khoảng cách row
lg  = 24px  padding trang, khoảng cách section
xl  = 32px  khoảng cách section lớn
```

---

## 6. Component Catalogue

### Buttons

| Variant | Class / Style | Dùng cho |
|---------|--------------|---------|
| Primary | `bg-brand-orange text-white h-10 px-4 rounded-lg` | Lưu, Xác nhận |
| Secondary | `border border-brand-orange text-brand-orange h-10 px-4 rounded-lg` | Hủy |
| Ghost | `text-brand-blue` | Link thứ cấp |
| Danger | `bg-status-danger text-white h-10 px-4 rounded-lg` | Xóa |
| Disabled | `bg-surface-elevated text-text-tertiary cursor-not-allowed` | |

### Cards

```
Standard Card:
  bg-white rounded-xl border border-border-light
  shadow-[0_1px_3px_rgba(0,0,0,0.06)] p-6

Alert Card (warning):
  bg-amber-50 border border-amber-200 rounded-xl p-4

Alert Card (danger):
  bg-red-50 border border-red-200 rounded-xl p-4
```

### Status Badges

```tsx
// Dùng cho trạng thái điểm danh, điểm số
<StatusBadge variant="present" />   // bg-green-100 text-green-800
<StatusBadge variant="absent" />    // bg-red-100 text-red-800
<StatusBadge variant="late" />      // bg-amber-100 text-amber-800
<StatusBadge variant="excused" />   // bg-blue-100 text-blue-800
```

### DataTable

Bảng chung dùng TanStack Table:
- Sort cột bằng click header
- Filter nhanh bằng search input
- Pagination: 20 rows/trang
- Row click → điều hướng tới detail
- Sticky header khi scroll dọc

### Form Fields

```
Input default:    h-10 border border-border-light rounded-lg px-3 text-sm
Input focused:    ring-2 ring-brand-blue/20 border-brand-blue
Input error:      border-status-danger + helper text đỏ bên dưới
Select:           dùng shadcn/ui Select
Date Picker:      dùng shadcn/ui Calendar + Popover
```

---

## 7. Màn hình chi tiết

### 7.1 Login Page

```
┌──────────────────────────────────────────┐
│           Logo MyFPTSchool               │
│         Cổng thông tin nhà trường        │
│                                          │
│  Tài khoản                               │
│  [________________________]              │
│                                          │
│  Mật khẩu               [👁]            │
│  [________________________]              │
│                                          │
│  [      Đăng nhập      ] ← brand orange │
│                                          │
│  ← Quên mật khẩu? (ghost link)          │
└──────────────────────────────────────────┘
```

States: default | loading | error (sai mật khẩu) | account locked

---

### 7.2 Dashboard

Nội dung thay đổi theo role:

**Admin Dashboard:**
```
┌──────┬──────┬──────┬──────┐
│ 1000 │  75  │  30  │  8   │  ← StatCard
│ HS   │  GV  │ Lớp  │ Môn  │
└──────┴──────┴──────┴──────┘

┌─────────────────┬──────────────────────┐
│ Tiết học hôm nay│ Thông báo gần đây    │
│ (list 5 tiết)   │ (list 5 thông báo)   │
└─────────────────┴──────────────────────┘

Quick Actions:
[ Thêm học sinh ] [ Nhập điểm danh ] [ Gửi thông báo ]
```

**Teacher Dashboard:** Chỉ hiện tiết học hôm nay của mình + nút "Nhập điểm danh".

**GVCN Dashboard:** Tiết học lớp mình + summary điểm danh lớp + nút "Gửi thông báo lớp".

---

### 7.3 Danh sách Học sinh

```
PageHeader: "Học sinh"  [+ Thêm học sinh] [Import Excel]

Filter bar:
  [Search tên/mã HS]  [Lọc lớp ▾]  [Lọc trạng thái ▾]

DataTable:
  Mã HS | Họ tên | Lớp | Ngày sinh | SĐT | Email | Trạng thái | Thao tác
  HS001   Nguyễn…  10A1   01/01/2009  …     …       Active        [Sửa]
  ...
  Pagination: < 1 2 3 ... >
```

Quyền: ADMIN xem tất cả, GVCN chỉ xem lớp mình.

---

### 7.4 Form Thêm/Sửa Học sinh

```
PageHeader: "Thêm học sinh" / "Sửa học sinh – Nguyễn Văn A"

┌──────────────────────────────────────────┐
│  Thông tin cơ bản                        │
│  Mã học sinh *    [__________]           │
│  Họ và tên *      [__________]           │
│  Ngày sinh *      [dd/MM/yyyy ▾]         │
│  Giới tính *      ● Nam  ○ Nữ            │
│  Lớp *            [Chọn lớp ▾]          │
├──────────────────────────────────────────┤
│  Thông tin liên hệ                       │
│  Số điện thoại    [__________]           │
│  Email            [__________]           │
├──────────────────────────────────────────┤
│  Tài khoản                               │
│  Mật khẩu         [__________]           │
│  (để trống = dùng mã HS làm mật khẩu)   │
└──────────────────────────────────────────┘

[Hủy]  [Lưu học sinh]
```

Validation real-time theo BACKEND-RULES.md:
- Mã HS: 3–20 ký tự, chữ hoa + số
- Tuổi: 14–20
- SĐT: `^0[3-9]\d{8}$`

---

### 7.5 Phân công Giảng dạy

```
PageHeader: "Phân công giảng dạy"

Filter: [Học kỳ ▾]  [Lớp ▾]

┌──────────────┬────────────┬──────────────────────────────┐
│ Lớp          │ Môn học    │ Giáo viên phụ trách           │
├──────────────┼────────────┼──────────────────────────────┤
│ 10A1         │ Toán       │ [Chọn giáo viên ▾]  [Lưu]   │
│              │ Ngữ Văn    │ Nguyễn Thị Mai Loan  [Sửa]  │
│              │ Tiếng Anh  │ [Chọn giáo viên ▾]  [Lưu]   │
│ 10A2         │ ...        │ ...                           │
└──────────────┴────────────┴──────────────────────────────┘
```

Chỉ ADMIN được chỉnh sửa. Unique constraint: cùng GV + môn + lớp + học kỳ.

---

### 7.6 Nhập Điểm danh

Entry point: từ danh sách tiết học → chọn tiết → mở trang điểm danh.

```
PageHeader: "Điểm danh – Toán – 10A1 – Thứ 2, 09/06/2026 – Tiết 1-2"

Summary: Có mặt: 35 | Vắng: 2 | Muộn: 1 | Chưa ghi: 0

[Lưu điểm danh] ← disabled cho đến khi có thay đổi

DataTable:
  STT | Mã HS | Họ tên        | Trạng thái              | Ghi chú
   1    HS001   Nguyễn Văn A   ● Có mặt ▾               [__________]
   2    HS002   Trần Thị B     ○ Đi muộn ▾              [__________]
   3    HS003   Lê Văn C       ○ Vắng có phép ▾         [Ốm, có đơn]
  ...

Dropdown trạng thái: Có mặt | Đi muộn | Vắng có phép | Vắng không phép

[Điểm danh hàng loạt: Tất cả có mặt]
```

Rules:
- Không cho điểm danh tiết tương lai
- Học sinh phải thuộc lớp của tiết học
- Chỉ GV dạy môn đó / GVCN lớp đó / ADMIN

---

### 7.7 Báo cáo Điểm danh

```
PageHeader: "Báo cáo điểm danh – 10A1"  [Xuất Excel]

Filter: [Học kỳ ▾]  [Môn học ▾]

Summary cards:
┌──────────┬──────────┬──────────┬──────────┐
│  401     │  356     │   30     │   15     │
│ Tổng tiết│ Có mặt   │ Vắng CP  │ Vắng KP  │
└──────────┴──────────┴──────────┴──────────┘

Bảng theo môn:
  Môn     | Tổng tiết | Có mặt | Vắng | % Vắng | Ngưỡng | Trạng thái
  Toán      70          65       5      7.1%     14      ✅ An toàn
  Ngữ Văn   70          62       8     11.4%     14      ⚠ Cần chú ý
  Tiếng Anh 52          48       4      7.7%     10.4    ✅ An toàn
```

Màu trạng thái:
- An toàn (`< 50% ngưỡng`): green badge
- Cần chú ý (`50–80%`): amber badge
- Nguy hiểm (`80–100%`): red badge
- Vượt ngưỡng (`≥ 100%`): dark red badge

---

### 7.8 Nhập Điểm số

```
PageHeader: "Nhập điểm – Toán – 10A1 – HK II 2025-2026"
           [Chốt điểm] ← ADMIN hoặc GV dạy môn đó

Spreadsheet-style grid:
  Mã HS | Họ tên | TX1 | TX2 | TX3 | ĐGKK | ĐCK | ĐTK  | XL
  HS001   Nguyễn…  8.5   7.0   9.0   7.5    8.0   8.1   Giỏi
  HS002   Trần…    6.0   [_]   7.5   6.0    [_]   …     …
  HS003   Lê…      5.0   5.5   6.0   5.5    5.0   5.4   TB

Hàng footer: Điểm TB lớp: 7.2 | % Giỏi: 35% | % Khá: 40% | % TB: 20% | % Yếu: 5%
```

Công thức ĐTK tính real-time: `(TX1+TX2+TX3+ĐGKK×2+ĐCK×3)/8`

Validation per cell:
- `0.0 ≤ score ≤ 10.0`, bội số `0.25`
- Tab → ô kế tiếp (UX bảng tính)
- Ô chưa nhập hiển thị `—`, không phải 0

Xếp loại: Giỏi (≥8.0) | Khá (≥6.5) | TB (≥5.0) | Yếu (<5.0)

---

### 7.9 Soạn Thông báo

```
PageHeader: "Soạn thông báo"

┌──────────────────────────────────────────┐
│ Gửi tới *                                │
│  ○ Một học sinh   [Chọn học sinh ▾]     │
│  ● Cả lớp         [Chọn lớp ▾]         │
│  ○ Toàn trường    (chỉ ADMIN)           │
├──────────────────────────────────────────┤
│ Danh mục *                               │
│  [homeroom ▾]  (homeroom|study|event)   │
├──────────────────────────────────────────┤
│ Tiêu đề * (tối đa 200 ký tự)            │
│ [________________________________________]│
├──────────────────────────────────────────┤
│ Nội dung * (tối đa 5000 ký tự)          │
│ [________________________________________]│
│ [________________________________________]│
│ [________________________________________]│
└──────────────────────────────────────────┘

[Hủy]  [Gửi thông báo]
```

Sau khi gửi: hiện toast "Đã gửi tới X người nhận" → redirect về danh sách.

---

## 8. API Layer

Dùng **TanStack Query** cho tất cả server state.

```typescript
// shared/lib/queryKeys.ts
export const queryKeys = {
  students: {
    all: ['students'] as const,
    list: (params: StudentListParams) => ['students', 'list', params] as const,
    detail: (id: number) => ['students', id] as const,
  },
  attendance: {
    session: (lessonId: number) => ['attendance', 'session', lessonId] as const,
    report: (classroomId: number, semesterId: number) =>
      ['attendance', 'report', classroomId, semesterId] as const,
  },
  grades: {
    byClassroomSubject: (csId: number) => ['grades', csId] as const,
  },
  // ...
}
```

```typescript
// features/students/api.ts
export const studentApi = {
  list: (params: StudentListParams) =>
    api.get<PageResponse<StudentResponse>>('/admin/students', { params }),
  detail: (id: number) =>
    api.get<StudentResponse>(`/admin/students/${id}`),
  create: (data: StudentRequest) =>
    api.post<StudentResponse>('/admin/students', data),
  update: (id: number, data: StudentRequest) =>
    api.put<StudentResponse>(`/admin/students/${id}`, data),
}

// Hook
export function useStudents(params: StudentListParams) {
  return useQuery({
    queryKey: queryKeys.students.list(params),
    queryFn: () => studentApi.list(params),
  })
}
```

**Error handling tập trung** trong Axios interceptor:
- `401` → clear token → redirect `/login`
- `403` → toast "Bạn không có quyền thực hiện thao tác này"
- `400` → trả về field errors để form hiển thị inline
- `500` → toast lỗi server generic

---

## 9. Auth & Role Guards

```typescript
// shared/hooks/useAuth.ts
interface AuthUser {
  id: number
  username: string
  role: 'ADMIN' | 'HOMEROOM_TEACHER' | 'TEACHER'
  fullName: string
}

function useAuth() {
  const { user } = useAuthContext()
  return {
    user,
    isAdmin: user?.role === 'ADMIN',
    isHomeroomTeacher: user?.role === 'HOMEROOM_TEACHER',
    isTeacher: user?.role === 'TEACHER',
    can: (roles: string[]) => roles.includes(user?.role ?? ''),
  }
}
```

```tsx
// app/router.tsx — Role Guard
function RequireRole({ roles, children }: { roles: string[], children: ReactNode }) {
  const { can } = useAuth()
  if (!can(roles)) return <Navigate to="/dashboard" replace />
  return <>{children}</>
}

// Usage
<Route path="/students/new" element={
  <RequireRole roles={['ADMIN']}>
    <StudentFormPage />
  </RequireRole>
} />
```

Sidebar cũng ẩn/hiện menu item dựa trên role — không chỉ dựa vào route guard.

---

## 10. State Management

| Loại state | Giải pháp |
|------------|-----------|
| Server state (API data) | TanStack Query |
| Auth token | React Context + localStorage |
| Form state | React Hook Form + Zod |
| UI state (modal, sidebar) | useState / Zustand nếu cần |
| URL state (filter, pagination) | React Router search params |

Không dùng Redux — không cần với quy mô này.

---

## 11. Form Validation

Dùng **Zod** schema + **React Hook Form** resolver:

```typescript
// features/students/components/StudentForm.tsx
const studentSchema = z.object({
  studentCode: z.string()
    .min(3).max(20)
    .regex(/^[A-Z0-9]+$/, 'Chỉ chữ hoa và số'),
  fullName: z.string().min(2).max(100),
  dateOfBirth: z.string().refine(isValidAge, 'Tuổi phải từ 14–20'),
  gender: z.enum(['Nam', 'Nữ']),
  phone: z.string().regex(/^0[3-9]\d{8}$/).optional().or(z.literal('')),
  email: z.string().email().optional().or(z.literal('')),
  classroomId: z.number({ required_error: 'Chọn lớp' }),
  password: z.string().min(6).max(100).optional().or(z.literal('')),
})
```

---

## 12. Notification UX

Hệ thống có 3 loại feedback:

| Loại | Khi nào | Vị trí |
|------|---------|--------|
| **Toast** | Thao tác thành công, lỗi nhỏ | Góc dưới phải, auto-dismiss 3s |
| **Inline error** | Validation form field | Dưới ô input |
| **Alert banner** | Lỗi API nghiêm trọng | Top of page |

---

## 13. Responsive

Web admin chủ yếu dùng trên desktop (1280px+), nhưng cần usable trên tablet.

| Breakpoint | Layout |
|------------|--------|
| `≥ 1280px` | Sidebar 240px + content |
| `1024–1279px` | Sidebar 64px (icon only) + content |
| `< 1024px` | Sidebar ẩn, hamburger menu |

DataTable trên tablet: horizontal scroll, sticky columns (mã HS, họ tên).

---

## 14. Phân chia phát triển theo Phase

### Phase 1 — MVP (ưu tiên)

- [ ] Login + JWT auth
- [ ] Dashboard cơ bản
- [ ] Danh sách + thêm/sửa Học sinh
- [ ] Danh sách Giáo viên
- [ ] Xem Lớp học (30 lớp cố định)
- [ ] Phân công giảng dạy
- [ ] Nhập điểm danh theo tiết
- [ ] Nhập điểm số theo môn × lớp
- [ ] Gửi thông báo lớp/toàn trường

### Phase 2

- [ ] Báo cáo điểm danh + export Excel
- [ ] Quản lý thời khóa biểu
- [ ] Import học sinh từ Excel

### Phase 3

- [ ] Dashboard báo cáo tổng hợp (chart)
- [ ] Quản lý năm học / học kỳ
- [ ] Phân quyền chi tiết
- [ ] Export PDF bảng điểm

---

## 15. Quyết định kỹ thuật đã chốt

| Quyết định | Lý do |
|------------|-------|
| Vite thay vì CRA | Nhanh hơn, HMR tốt hơn |
| TanStack Query thay vì Redux RTK Query | Ít boilerplate, cache tự động |
| shadcn/ui + Tailwind | Copy-paste component, không bị lock vendor |
| React Hook Form + Zod | Type-safe validation, hiệu năng tốt |
| Feature-based structure | Mirrors backend packages, mỗi dev sở hữu 1 feature |
| React Router v6 | Chuẩn, loader pattern nếu cần sau |
| Axios thay vì fetch | Interceptor dễ hơn cho auth/error handling |

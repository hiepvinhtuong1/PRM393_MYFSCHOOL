# Design System: MyFPTSchools Clone

## 1. Visual Theme & Atmosphere

**Mood:** Clean, trustworthy, and academically focused. The interface feels like a modern internal education portal — organized, scannable, and calm. It avoids playfulness; instead it conveys institutional reliability with warmth.

**Density:** Comfortable — generous whitespace between sections, but data-rich cards use compact internal spacing to maximize information without clutter.

**Aesthetic:** Modern Minimal with a subtle institutional warmth. Rounded corners and soft shadows create an approachable feel. FPT brand colors (Orange, Green, Blue) are used as accents — never as dominant backgrounds — to maintain scannability and reduce visual fatigue.

**Target users:** High school students and parents. The UI must be readable by both younger and older users, with clear tap targets (minimum 44px) and intuitive navigation.

## 2. Color Palette & Roles

### Primary Colors

| Color | Hex | Role |
|-------|-----|------|
| **FPT Orange** | `#F37021` | Primary brand accent — used for primary CTA buttons, active tab indicators, important badges, and brand logo areas. Never as full-screen background. |
| **FPT Deep Blue** | `#0078D7` | Secondary accent — links, info badges, timetable headers, and interactive elements needing distinction from orange. |
| **FPT Green** | `#00A651` | Success states — attendance "present", grade "pass", confirmation messages. |

### Semantic Colors

| Color | Hex | Role |
|-------|-----|------|
| **Warning Amber** | `#F59E0B` | Warning states — attendance near-threshold, pending grades, approaching deadlines. |
| **Danger Red** | `#EF4444` | Error/danger — login failures, attendance "absent", failed grades, error states, exceeded thresholds. |
| **Info Soft Blue** | `#3B82F6` | Informational badges, notification type indicators, secondary interactive elements. |

### Neutral Colors

| Color | Hex | Role |
|-------|-----|------|
| **Background** | `#F8FAFC` | Global app background — Slate-50, very light cool gray for reduced eye strain. |
| **Surface White** | `#FFFFFF` | Card backgrounds, input field backgrounds, modal surfaces. |
| **Surface Elevated** | `#F1F5F9` | Subtle section separators, skeleton loading backgrounds, disabled surfaces. |
| **Border Light** | `#E2E8F0` | Card borders, input field borders, dividers between list items. |
| **Border Medium** | `#CBD5E1` | Active/focus input borders, stronger dividers. |
| **Text Primary** | `#0F172A` | Headlines, primary body text, student names — Slate-900, near-black for maximum readability. |
| **Text Secondary** | `#64748B` | Labels, timestamps, helper text, metadata — Slate-500. |
| **Text Tertiary** | `#94A3B8` | Placeholder text, disabled text — Slate-400. |

### Status Badge Backgrounds (10% opacity tint)

| State | Background | Text |
|-------|-----------|------|
| Present / Pass | `#DCFCE7` | `#166534` (Green-800) |
| Warning / Pending | `#FEF3C7` | `#92400E` (Amber-800) |
| Absent / Fail | `#FEE2E2` | `#991B1B` (Red-800) |
| Info / Default | `#DBEAFE` | `#1E40AF` (Blue-800) |

## 3. Typography Rules

**Font Family:** Inter (all weights) — chosen for exceptional legibility at small sizes and robust Vietnamese diacritic support.

| Role | Size | Weight | Line Height | Usage |
|------|------|--------|-------------|-------|
| **Display** | 24px | 700 (Bold) | 32px | Screen titles, main headings |
| **Headline** | 20px | 600 (SemiBold) | 28px | Section titles, card headers |
| **Title** | 16px | 600 (SemiBold) | 24px | Subject names, list item titles |
| **Body** | 14px | 400 (Regular) | 20px | Primary body text, descriptions |
| **Body Small** | 13px | 400 (Regular) | 18px | Table data, secondary info |
| **Caption** | 12px | 500 (Medium) | 16px | Timestamps, badges, metadata |
| **Label Caps** | 11px | 700 (Bold) | 16px | Section labels, tab bar labels, letter-spacing 0.05em |
| **Numeric Data** | 14px | 600 (SemiBold) | 20px | Grades, percentages, GPA — uses tabular figures (`tnum`) |

## 4. Component Stylings

### Buttons

| Type | Style |
|------|-------|
| **Primary** | FPT Orange (#F37021) fill, white text, 8px radius, 48px height, full-width in forms |
| **Secondary** | White fill, 1px FPT Orange border, orange text, 8px radius, 48px height |
| **Ghost/Text** | No background/border, FPT Blue text, used for "Forgot Password", "See All" links |
| **Danger** | Danger Red (#EF4444) fill, white text, 8px radius — for destructive actions only |
| **Disabled** | Surface Elevated (#F1F5F9) fill, Text Tertiary color, no interaction |

### Cards / Containers

| Element | Style |
|---------|-------|
| **Standard Card** | White background, 1px Border Light, 12px radius, soft shadow `0 1px 3px rgba(0,0,0,0.06)` |
| **Alert Card** | Tinted background (semantic color at 10%), 12px radius, no shadow, 1px tinted border |
| **Menu Grid Item** | White background, 12px radius, centered icon (24px) + label below, subtle shadow |
| **List Item** | White background, 1px bottom border, 16px horizontal padding, 12px vertical padding |

### Input Fields

| State | Style |
|-------|-------|
| **Default** | White background, 1px Border Light, 8px radius, 48px height, 16px horizontal padding |
| **Focused** | 2px FPT Blue border, light blue glow `0 0 0 3px rgba(0,120,215,0.1)` |
| **Error** | 1px Danger Red border, error text below in 12px red |
| **Disabled** | Surface Elevated background, Text Tertiary color |

### Status Badges

| Shape | Style |
|-------|-------|
| **Pill Badge** | Full-rounded (999px), 10% tint background, colored text, 6px horizontal / 2px vertical padding |
| **Dot Indicator** | 8px circle, solid semantic color — used next to notification items |

### Bottom Navigation Bar

| Element | Style |
|---------|-------|
| **Container** | White background, top border 1px Border Light, safe area padding, 56px height |
| **Active Tab** | FPT Orange icon + label, weight 600 |
| **Inactive Tab** | Text Secondary color icon + label, weight 400 |
| **Badge** | 8px red dot or count badge on Notifications tab |

## 5. Layout Principles

### Spacing System (4px base)

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Icon-to-label gap, badge internal padding |
| `sm` | 8px | Between small related items |
| `md` | 16px | Card internal padding, list item padding, gutter |
| `lg` | 24px | Between sections, screen horizontal margin |
| `xl` | 32px | Large section separators |

### Screen Structure

```
Status Bar (system)
├── App Bar (56px) — Title + optional actions
├── Content Area (scrollable)
│   ├── Section 1
│   │   ├── Section Header (optional)
│   │   └── Content (cards, lists, etc.)
│   ├── Section Gap (24px)
│   └── Section 2 ...
└── Bottom Navigation (56px + safe area) — only on main tabs
```

### Grid

- **Full-width cards**: 24px horizontal margin from screen edge
- **Menu grid**: 2 columns with 12px gap (4 items per row on wide screens)
- **Minimum touch target**: 44px × 44px

## 6. Design System Notes for Stitch Generation

When prompting Stitch for new screens in this project, include:

```
DESIGN SYSTEM (REQUIRED):
- Platform: Mobile app, portrait, 390px width
- Theme: Light mode, clean and modern educational app
- Background: Cool Light Gray (#F8FAFC)
- Card Surface: Pure White (#FFFFFF) with 12px radius and subtle shadow
- Primary Accent: FPT Orange (#F37021) for buttons and active indicators
- Secondary Accent: Deep Blue (#0078D7) for links and info elements  
- Success: Green (#00A651) for positive states
- Warning: Amber (#F59E0B) for caution states
- Error: Red (#EF4444) for danger states
- Text Primary: Near Black (#0F172A)
- Text Secondary: Slate Gray (#64748B)
- Typography: Inter, headings 20-24px SemiBold/Bold, body 14px Regular
- Buttons: 8px radius, 48px height, full-width primary CTA
- Cards: 12px radius, 1px light border, whisper-soft shadow
- Input fields: 8px radius, 48px height, 1px border
- Bottom Navigation: 4 tabs with FPT Orange active state
- Status badges: Pill-shaped with tinted backgrounds
- Spacing: 24px screen margins, 16px card padding, 4px base unit
```

## 7. Navigation Rules

### Bottom Navigation Tabs
1. **Home** (🏠) — Dashboard with quick access to all features
2. **Timetable** (📅) — Daily/weekly class schedule
3. **Notifications** (🔔) — All push notifications with unread badge
4. **Profile** (👤) — User info and settings

### Stack Navigation
- Each tab maintains its own navigation stack
- Back button returns within the current tab stack
- Deep links open the correct tab and push to the target screen

### Transition Patterns
- **Push**: Slide from right for detail screens
- **Modal**: Slide from bottom for confirmations and filters
- **Tab switch**: Fade/instant transition

## 8. State Patterns

### Loading State
- Skeleton screens matching the expected layout
- Shimmer animation on skeleton blocks
- Used on: Dashboard, Timetable, Attendance, Grades, Notifications

### Empty State
- Centered illustration or icon (muted)
- Descriptive title (e.g., "Chưa có lịch học hôm nay")
- Subtitle with guidance
- Optional action button

### Error State
- Error icon (muted red)
- Title: "Không thể tải dữ liệu"
- Subtitle with reason
- "Thử lại" retry button (Secondary style)

### Offline State
- Banner at top: "Đang ngoại tuyến — dữ liệu có thể chưa mới nhất"
- Show cached data if available
- Disable refresh actions

---
name: FPT Education Digital Experience
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#584237'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f1f1'
  outline: '#8c7166'
  outline-variant: '#e0c0b2'
  surface-tint: '#a04100'
  primary: '#a04100'
  on-primary: '#ffffff'
  primary-container: '#f37021'
  on-primary-container: '#541f00'
  inverse-primary: '#ffb693'
  secondary: '#006d38'
  on-secondary: '#ffffff'
  secondary-container: '#74f9a0'
  on-secondary-container: '#00723a'
  tertiary: '#4d5d8b'
  on-tertiary: '#ffffff'
  tertiary-container: '#8595c7'
  on-tertiary-container: '#1c2d58'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbcb'
  primary-fixed-dim: '#ffb693'
  on-primary-fixed: '#341000'
  on-primary-fixed-variant: '#7a3000'
  secondary-fixed: '#77fca3'
  secondary-fixed-dim: '#59df89'
  on-secondary-fixed: '#00210d'
  on-secondary-fixed-variant: '#005228'
  tertiary-fixed: '#dae1ff'
  tertiary-fixed-dim: '#b5c5f9'
  on-tertiary-fixed: '#051944'
  on-tertiary-fixed-variant: '#354572'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 16px
  margin-tablet: 32px
  gutter: 16px
---

# FPT Education Digital Experience

**Trạng thái:** Accepted baseline  
**Phạm vi:** React Web Admin/Teacher và Flutter Parent App.

## Brand và phong cách

Design system dành cho MyFPTSchool với cá tính thương hiệu tiến bộ, giàu năng lượng và
nghiêm túc về học thuật. Phong cách Modern Corporate chịu ảnh hưởng của Material 3, ưu tiên
sự rõ ràng và hiệu quả khi trình bày điểm, lịch học và tác vụ hành chính.

Trải nghiệm cần tạo cảm giác có tổ chức và làm chủ thông tin, thay vì phô diễn hiệu ứng.

## Màu sắc

- **Primary Orange `#F37021`:** FAB, điểm nhấn thương hiệu và trạng thái tiến trình active.
- **Secondary Green `#00A859`:** trạng thái thành công, điểm danh và hành động xác nhận.
- **Deep Blue `#1A2B56`:** navigation, tiêu đề và vùng thông tin học thuật mật độ cao.
- **Background tiers:** card dùng trắng, canvas dùng xám rất nhạt để tạo phân tầng.

Các màu trong YAML frontmatter là semantic Material color scheme dùng khi triển khai theme.
Ba màu brand ở trên là màu nhận diện; không thay semantic token bằng màu brand tùy tiện.

## Typography

Sử dụng **Inter** vì khả năng hiển thị tiếng Việt và dữ liệu kỹ thuật rõ ràng.

- Heading đậm, dễ quét nhanh.
- Display size có letter spacing hơi âm.
- Label nhỏ có tracking lớn hơn.
- Nội dung tiếng Việt duy trì line-height khoảng `1.4-1.5` để tránh dấu bị chật.

## Layout và spacing

- Web/tablet: fluid grid 12 cột.
- Mobile: grid 4 cột.
- Base spacing: `8px`.
- Mobile margin: `16px`.
- Tablet margin: `32px`.
- Gutter giữa component: `16px`.
- Card có thể full-width hoặc bố cục hai cột cho dữ liệu ngắn như GPA và tỷ lệ chuyên cần.

## Elevation và chiều sâu

1. **Level 0:** nền xám nhạt.
2. **Level 1:** card trắng, shadow `0 4px 20px` với Deep Blue opacity 5%.
3. **Level 2:** modal/overlay trắng, shadow `0 8px 30px` với Deep Blue opacity 12%.

Ưu tiên tonal layering. Không lạm dụng shadow. FAB có thể dùng shadow cam nhẹ nhưng phải giữ
độ tương phản và không tạo hiệu ứng phát sáng quá mạnh.

## Shapes

- Button/input nhỏ: radius `8px`.
- Button/input lớn: radius `12px`.
- Card/container: radius `16px`.
- Search bar: pill/full radius.

## Components

### Buttons

- Primary: nền Orange, chữ trắng, radius `12px`.
- Secondary: outline hoặc ghost Green cho hành động tích cực.
- Tertiary: text Deep Blue cho navigation hoặc dismiss.

### Cards

Card dữ liệu trường học dùng nền trắng, radius `16px`, Level 1 shadow. Tiêu đề card dùng
Deep Blue.

### Inputs

Soft-filled: nền rất nhạt, border `1px`; focus chuyển Primary Orange. Label luôn hiển thị ở
phía trên trường nhập theo `label-md`.

### Chips và badges

Dùng cho môn học và trạng thái. Background sử dụng tint opacity thấp, text dùng màu semantic
đậm. Không chỉ dùng màu để truyền đạt trạng thái.

### Navigation

Bottom navigation nền trắng, shadow phía trên. Icon line khoảng `2px`; item active dùng Orange
và nền tròn cam nhạt. Web navigation phải hỗ trợ permission-driven menu.

## Accessibility

- Touch target tối thiểu `48x48`.
- Kiểm tra contrast cho text, icon và trạng thái disabled.
- Hỗ trợ text scale và tiếng Việt nhiều dòng.
- Focus indicator phải rõ trên web/tablet.
- Mọi trạng thái màu sắc phải có text hoặc icon đi kèm.


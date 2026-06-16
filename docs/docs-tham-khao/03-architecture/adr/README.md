# Architecture Decision Records

ADR ghi lại quyết định có ảnh hưởng lớn, khó đảo ngược hoặc có nhiều lựa chọn hợp lý.

## Trạng thái

- `Proposed`: đang chờ review.
- `Accepted`: đang có hiệu lực.
- `Rejected`: không chọn.
- `Superseded`: được ADR khác thay thế.

## Danh sách

| ADR | Quyết định | Trạng thái |
|---|---|---|
| [0001](0001-chon-stack-hien-tai.md) | React web + Flutter mobile + Spring Boot API | Accepted |
| [0002](0002-modular-monolith-va-mvc-don-gian.md) | Modular monolith, feature-first web và MVC mobile | Accepted |
| [0003](0003-co-so-du-lieu-quan-he-va-migration.md) | SQL Server relational schema và versioned migration | Proposed |

## Mẫu

```markdown
# ADR-NNNN: Tiêu đề

**Trạng thái:** Proposed
**Ngày:** YYYY-MM-DD

## Bối cảnh
## Các lựa chọn
## Quyết định
## Hệ quả tích cực
## Hệ quả/đánh đổi
## Điều kiện xem xét lại
```

# Chỉ mục tài liệu dự án

Thư mục này là nguồn sự thật được quản lý cùng source code. Không sao chép cùng một rule
vào nhiều file; tài liệu khác nên liên kết về nơi sở hữu thông tin.

## Bản đồ đọc nhanh

| Khi cần hiểu | Đọc |
|---|---|
| Mục tiêu, phạm vi, trạng thái dự án | [Tầm nhìn và phạm vi](00-project/tam-nhin-va-pham-vi.md) |
| Thuật ngữ | [Glossary](00-project/glossary.md) |
| Điều chưa rõ/cần xác nhận | [Giả định và câu hỏi mở](00-project/gia-dinh-va-cau-hoi-mo.md) |
| Actor, module, business rule sơ bộ | [Tổng quan nghiệp vụ](01-business/tong-quan-nghiep-vu.md) |
| Role, permission và phạm vi dữ liệu | [Phân quyền RBAC](01-business/phan-quyen-rbac.md) |
| State machine nghiệp vụ | [Quy trình nghiệp vụ](01-business/quy-trinh-nghiep-vu.md) |
| Các vấn đề cần sửa trong nghiệp vụ hiện tại | [Review vòng 1](01-business/review-nghiep-vu-vong-1.md) |
| Mỗi màn hình phải làm gì | [Danh mục màn hình](02-requirements/danh-muc-man-hinh.md) |
| Requirement và tiêu chí nghiệm thu F02-F04 | [Học vụ, TKB và điểm danh](02-requirements/f02-f04-hoc-vu-tkb-diem-danh.md) |
| Requirement và tiêu chí nghiệm thu F05 | [Điểm số và hạnh kiểm](02-requirements/f05-diem-so-va-hanh-kiem.md) |
| Kiến trúc mobile/backend/data | [Kiến trúc tổng quan](03-architecture/kien-truc-tong-quan.md) |
| Cây thư mục và dependency rules | [Cấu trúc dự án](03-architecture/cau-truc-du-an.md) |
| Contract REST dự kiến | [Quy ước API](03-architecture/quy-uoc-api.md) |
| ERD, table catalog và database constraints | [Thiết kế database](03-architecture/database/README.md) |
| Quyết định kỹ thuật và lý do | [ADR](03-architecture/adr/README.md) |
| Token màu, typography, spacing, elevation | [Design tokens](04-design/design.md) |
| Cách áp dụng design theo portal | [Design system](04-design/design-system.md) |
| Điều kiện hoàn tất | [Definition of Done](05-quality/definition-of-done.md) |
| Hiệu năng, bảo mật, độ tin cậy | [Yêu cầu phi chức năng](05-quality/yeu-cau-phi-chuc-nang.md) |
| Cách BA/SA/Dev/AI phối hợp | [Quy ước cộng tác](06-ai/quy-uoc-cong-tac.md) |

## Project skills

Skill nằm tại `.agents/skills/` và được Codex tự phát hiện ở repository scope:

| Skill | Khi sử dụng |
|---|---|
| `$analyze-myfptschool-requirement` | Requirement mới, review nghiệp vụ, use case, RBAC, workflow |
| `$implement-myfptschool-feature` | Triển khai code/test/docs từ đặc tả đã đủ rõ |
| `$review-myfptschool-change` | Review diff/PR/commit hoặc đánh giá sẵn sàng production |

Không tạo skill chỉ để chứa convention tĩnh; convention tiếp tục thuộc `AGENTS.md`.

## Quy tắc cập nhật

- Một thay đổi nghiệp vụ phải cập nhật business rule và tiêu chí chấp nhận liên quan.
- Một quyết định khó đảo ngược phải có ADR.
- Một endpoint thay đổi phải cập nhật API contract và consumer liên quan.
- Nội dung chưa được stakeholder xác nhận không được ghi như sự thật.
- Mỗi tài liệu nên có chủ đề duy nhất, ngắn và có liên kết tới tài liệu sở hữu chi tiết.

## Trạng thái tài liệu

- `Baseline`: đủ dùng để AI và thành viên mới định hướng.
- `Draft`: cần review nghiệp vụ.
- `Accepted`: đã được chủ dự án xác nhận.
- `Superseded`: đã được tài liệu/ADR mới thay thế.

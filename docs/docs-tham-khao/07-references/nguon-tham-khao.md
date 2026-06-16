# Nguồn tham khảo

**Ngày truy cập:** 2026-06-15

- [Codex best practices](https://developers.openai.com/codex/learn/best-practices)
- [Codex custom instructions với AGENTS.md](https://developers.openai.com/codex/guides/agents-md)
- [Google Antigravity Rules](https://antigravity.google/docs/rules-workflows)
- [Google Antigravity Workflows](https://antigravity.google/docs/ide-workflows)
- [Flutter - Guide to app architecture](https://docs.flutter.dev/app-architecture/guide)
- [Flutter - Architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations)
- [Spring Boot - Structuring your code](https://docs.spring.io/spring-boot/reference/using/structuring-your-code.html)
- [C4 model](https://c4model.com/)
- [Architecture Decision Records](https://github.com/architecture-decision-record/architecture-decision-record)

## Cách áp dụng

- `AGENTS.md` ngắn, thực dụng, chứa layout, lệnh kiểm tra và ràng buộc bền vững.
- Antigravity dùng workspace rules và workflow Markdown cho tác vụ lặp lại.
- Flutter tách View, Controller, Repository và Service; View không gọi HTTP/storage trực tiếp.
- Spring Boot tổ chức theo domain/module, tránh default package.
- C4 dùng để mô tả context/container trước khi đi sâu component.
- ADR giữ lại bối cảnh, lựa chọn, quyết định và hệ quả của lựa chọn kiến trúc.

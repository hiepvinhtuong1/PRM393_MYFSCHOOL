# ADR-0002: Modular monolith, feature-first web và MVC mobile

**Trạng thái:** Accepted
**Ngày:** 2026-06-15

## Bối cảnh

Dự án có nhiều module nghiệp vụ nhưng quy mô, tải và tổ chức vận hành chưa chứng minh nhu cầu
microservice. Web có nhiều module theo role; mobile cần cấu trúc đơn giản, phù hợp phạm vi môn
học và dễ nhận biết theo View/Controller/Model.

## Quyết định đề xuất

- Backend là modular monolith, package theo bounded context.
- Web React tổ chức feature-first, route/action theo permission.
- Mobile Flutter tổ chức MVC dưới `lib/vn/edu/fpt/`, bổ sung service/repository/util.
- View gọi Controller; Controller điều phối Repository/Service; Model chứa dữ liệu.
- Contract giữa các client và backend qua DTO REST versioned.

## Hệ quả tích cực

- Ranh giới module rõ mà vận hành vẫn đơn giản.
- Có thể kiểm thử Controller, Repository, Service và application service độc lập.
- Giảm coupling giữa màn hình, API và database.
- Cấu trúc mobile dễ học, ít tầng hơn feature-first Clean Architecture.

## Đánh đổi

- Cần kỷ luật dependency giữa module.
- Có thêm DTO/mapping so với CRUD trực tiếp.
- `lib/vn/edu/fpt` mang phong cách package Java, không phải convention Dart phổ biến.
- Cần tránh controller/util khổng lồ khi số màn hình tăng.

## Điều kiện xem xét lại

Xem lại khi có dữ liệu về tải, đội ngũ độc lập, yêu cầu triển khai riêng hoặc ranh giới module
không thể giữ trong cùng process.

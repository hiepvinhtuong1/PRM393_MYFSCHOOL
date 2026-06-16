# ADR-0001: Dùng React, Flutter và Spring Boot làm baseline

**Trạng thái:** Accepted  
**Ngày:** 2026-06-15

## Bối cảnh

Repository có React/Vite cho web, Flutter/Dart cho Parent App và Spring Boot/Java cho backend.
Prompt UI cũ yêu cầu React Native/Expo nhưng không khớp source mobile.

## Các lựa chọn

1. Xóa Flutter và khởi tạo lại React Native.
2. Dùng React cho web, giữ Flutter cho mobile và Spring Boot cho API.
3. Duy trì React Native song song với Flutter.

## Quyết định

Dùng React/Vite cho một web app Admin + Teacher, Flutter cho Parent App và Spring Boot cho API.

## Hệ quả

- Ba portal có ownership kỹ thuật rõ.
- Material Design, navigation, state management và styling sẽ dùng hệ sinh thái Flutter.
- Parent App không dùng NativeWind hoặc React Navigation; web React có thể chuyển sang TypeScript.
- Web React hiện là JavaScript scaffold; việc chuyển TypeScript cần quyết định trước feature lớn.

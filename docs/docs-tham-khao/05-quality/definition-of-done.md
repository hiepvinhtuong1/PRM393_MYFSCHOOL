# Definition of Done

Một thay đổi chỉ được xem là hoàn tất khi các mục áp dụng bên dưới đã đạt.

## Nghiệp vụ

- Yêu cầu, actor, business rule và tiêu chí chấp nhận rõ.
- Không còn giả định ảnh hưởng cao bị giấu trong code.
- Quyền xem/sửa dữ liệu đã được xác định.
- Nội dung tiếng Việt thống nhất glossary.

## Mobile

- Có loading, empty, error, success.
- Hoạt động với back navigation, bàn phím, safe area và text scale.
- Không chứa business rule chính thức chỉ trong widget.
- Không log token, password hoặc dữ liệu cá nhân.
- Có widget/unit test phù hợp rủi ro.

## Web

- Route/menu/action phản ánh permission nhưng không được xem là lớp bảo mật duy nhất.
- Responsive trên desktop/tablet cho các màn hình giáo viên.
- Có loading, empty, error, success và forbidden.
- Form có validation, chống submit lặp và xử lý xung đột state.
- Có component/unit/integration test phù hợp rủi ro.

## Backend

- Request được validate; business rule được test.
- Authorization kiểm tra ở backend.
- DTO tách khỏi entity persistence.
- Lỗi theo error contract và không lộ chi tiết nội bộ.
- Migration/config không chứa secret.

## Kiểm tra

```powershell
cd mysfchoolse1911webapp
npm run lint
npm run build
```

```powershell
cd myfschoolse1911
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

```powershell
cd myfschoolse1911backend
.\mvnw.cmd test
```

## Tài liệu và review

- Cập nhật tài liệu bị ảnh hưởng.
- Quyết định kiến trúc quan trọng có ADR.
- Diff được review về hồi quy, bảo mật, edge case và scope.
- Nêu rõ kiểm tra nào chưa chạy được và lý do.

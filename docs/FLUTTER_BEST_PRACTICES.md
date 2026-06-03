# Flutter Best Practices - MyFPTSchools

Tai lieu nay dinh nghia chuan code Flutter cho du an MyFPTSchools. Khi lam man hinh moi, refactor, review PR, hoac prompt AI code, hay dung file nay lam tieu chuan mac dinh.

## 1. Muc tieu

Base cua du an can dat 5 muc tieu:

- De doc: moi file co mot vai tro ro rang.
- De mo rong: them man hinh moi khong phai sua nhieu noi khong lien quan.
- De review: PR nho, diff gon, ten file va folder tu noi len y dinh.
- Dong nhat UI: tat ca man hinh dung theme, spacing, color, widget chung.
- San sang thay mock data bang backend: UI khong tron data tam vao qua sau trong layout.

## 2. Cau truc thu muc

Dung cau truc theo feature, moi feature nam trong `view/<feature>/`.

```text
lib/vn/edu/fpt/
  app.dart
  core/
    constants/
    theme/
    widgets/
  view/
    auth/
    login/
      login_screen.dart
      mock/
      widgets/
    home/
      home_screen.dart
      mock/
      widgets/
    main/
      main_shell.dart
```

Quy tac:

- `core/` chi chua thu dung chung cho toan app.
- `view/<feature>/` chua UI cua mot feature cu the.
- `mock/` chua data tam cua feature.
- `widgets/` chua widget con cua feature khi man hinh da du lon.
- Khong dua widget chi dung cho mot feature vao `core/widgets`.

## 3. Khi nao duoc de nhieu widget trong mot file?

Chap nhan de widget con private trong cung file screen khi:

- Man hinh dang o giai doan prototype hoac MVP som.
- File duoi khoang 250-300 dong.
- Widget con chi dung trong man hinh do.
- Chua co logic phuc tap, state phuc tap, hoac navigation rieng.
- Layout chua duoc chot, van dang can nhin tong the trong mot file.

Vi du hop le:

```text
home_screen.dart
  HomeScreen
  _HomeHeader
  _NextClassCard
  _MenuTile
```

## 4. Khi nao bat buoc tach widget?

Nen tach vao `widgets/` khi co it nhat mot dieu kien sau:

- File screen vuot khoang 300 dong.
- Mot widget con dai hon 60-80 dong.
- Widget con co state rieng.
- Widget con co callback/action rieng.
- Widget con duoc dung lai o nhieu man hinh.
- Widget can test rieng.
- Man hinh da chot layout va bat dau them logic/loading/error/navigation.

Cau truc de xuat:

```text
view/home/
  home_screen.dart
  mock/
    home_mock_data.dart
  widgets/
    home_header.dart
    next_class_card.dart
    quick_alerts_section.dart
    menu_grid_section.dart
    featured_news_section.dart
    section_header.dart
```

Sau khi tach, `home_screen.dart` chi nen dieu phoi layout cap cao:

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user});

  final MockUser user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HomeHeader(user: user),
        NextClassCard(),
        QuickAlertsSection(),
        MenuGridSection(),
        FeaturedNewsSection(),
      ],
    );
  }
}
```

## 5. Naming conventions

File va folder:

- Dung `snake_case`.
- Screen file: `<feature>_screen.dart`.
- Widget file: mo ta dung vai tro, vi du `next_class_card.dart`.
- Mock data file: `<feature>_mock_data.dart`.

Class:

- Public widget: `PascalCase`, vi du `HomeScreen`, `NextClassCard`.
- Widget private trong cung file: bat dau bang `_`, vi du `_HomeHeader`.
- Model/mock class: danh tu ro nghia, vi du `NextClass`, `QuickAlert`.

Bien va ham:

- Dung `lowerCamelCase`.
- Callback dat ten theo hanh dong: `onLogout`, `onLoginSuccess`, `onActionPressed`.
- Bien boolean co tien to ro: `isLoading`, `hasError`, `canSubmit`.

## 6. UI standards

Moi man hinh phai dung design token tu `core/theme`:

- Mau: `AppColors`.
- Spacing: `AppSpacing`.
- Radius: `AppRadius`.
- Text style: `Theme.of(context).textTheme`.
- Card co ban: `AppCard`.

Khong nen hardcode mau/spacing neu token da co san.

Chap nhan hardcode mau tint tam thoi khi token chua co, nhung neu dung lai nhieu hon 2 lan thi tach vao `AppColors` hoac helper chung.

Khong nen:

- Dung `Colors.orange`, `Colors.red` truc tiep trong feature UI.
- Dat padding tuy tien nhu `EdgeInsets.all(17)`.
- Tao style rieng le cho moi nut/card neu theme da cover.
- Lam card long nhau nhieu lop neu khong can.

## 7. Text va ngon ngu

Hien tai app uu tien tieng Viet.

Quy tac:

- Text hien thi cho user phai co dau tieng Viet day du.
- Khong hien thi text debug/mock nhu "Tai khoan demo" tren UI production-like.
- Mock data co the nam trong code, nhung chi hien thi neu man hinh thuc su can.
- Text lap lai nhieu noi nen dua vao constants/localization sau.

Neu file bi loi encoding, can sua ngay truoc khi tiep tuc build feature do.

## 8. Mock data

Trong giai doan chua co backend:

- Moi feature co mock rieng trong `view/<feature>/mock/`.
- Mock data khong dat truc tiep trong widget build.
- UI nhan object/model ro rang thay vi doc list raw map.

Tot:

```dart
class NextClass {
  const NextClass({
    required this.subject,
    required this.teacher,
  });
}
```

Tranh:

```dart
final data = {'subject': 'Toan', 'teacher': 'Co A'};
```

## 9. State va business logic

Giai doan hien tai co the dung `StatefulWidget` cho state UI nho.

Chap nhan:

- Toggle hien/an mat khau.
- Loading submit mock.
- Current selected tab.
- Simple form validation.

Can tach ra controller/provider/service khi:

- State duoc chia se giua nhieu screen.
- Co API/backend.
- Co caching/session/token.
- Co loading/error phuc tap.
- Co logic tinh toan nghiep vu nhu diem, ty le vang, dieu kien pass/fail.

## 10. Navigation

Giai doan dau co the dung callback truc tiep cho flow nho:

```text
Login -> onLoginSuccess -> MainShell
Profile -> onLogout -> Login
```

Khi bat dau co detail screens, deep link, hoac push/pop nhieu cap, can them routing layer rieng:

```text
core/routing/
  app_routes.dart
  app_router.dart
```

Khong de navigation logic rai rac trong qua nhieu widget con.

## 11. Man hinh moi can co nhung gi?

Moi man hinh moi nen co:

- Screen widget chinh.
- Mock data rieng neu chua co backend.
- Widget con private hoac folder `widgets/` tuy do lon.
- Loading/empty/error state neu man hinh doc data.
- Ten text/action khop voi `docs/myfptschools-clone-screen-map.md`.
- UI token khop voi `docs/DESIGN.md`.

## 12. Checklist truoc khi commit

Truoc khi commit mot feature, kiem tra:

- Khong con text mojibake/loi dau tieng Viet.
- Khong hien thi mock/debug data khong can thiet.
- Khong co file build/cache/local secret.
- Widget lon da duoc tach neu vuot nguong.
- File screen chinh van de doc.
- Ten branch dung feature dang lam.
- Commit message ro nghia.

Neu co the chay lenh:

```text
dart format lib test
flutter analyze
flutter test
```

Neu khong chay duoc do sandbox/moi truong, ghi ro trong final message.

## 13. Branch va commit

Moi feature nen tach branch rieng:

```text
feature/login-screen
feature/auth-flow
feature/home-dashboard
feature/timetable
feature/attendance
feature/grades
```

Commit message nen theo dang:

```text
feat: add home dashboard
fix: localize login screen copy
chore: keep base architecture only
refactor: split home widgets
```

Khong gom qua nhieu feature vao mot commit.

## 14. Tieu chuan review PR

Review PR theo thu tu:

- Dung yeu cau man hinh/tinh nang chua?
- UI co bam `DESIGN.md` khong?
- Flow co khop screen map khong?
- Data mock co tach khoi UI khong?
- File co qua dai hoac qua nhieu trach nhiem khong?
- Text tieng Viet co dung dau khong?
- Co chuan bi duong thay backend sau nay khong?

## 15. Nguyen tac thuc dung

Dung best practice de giu code de song lau, khong dung de lam cham prototype.

Quy tac can bang:

- Lan dau build man hinh: duoc gom widget private trong mot file de nhin tong the.
- Khi UI da chot hoac file bat dau dai: refactor tach widget.
- Khi co backend/state that: tach model, repository/service, state controller.
- Khi widget dung lai: dua vao feature `widgets/` truoc, chi dua len `core/widgets` neu dung chung toan app.


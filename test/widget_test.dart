import 'package:flutter_test/flutter_test.dart';

import 'package:myfschoolse1911/vn/edu/fpt/app.dart';

void main() {
  testWidgets('App starts from splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyFptSchoolsApp());

    expect(find.text('MyFPTSchools'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.text('Trang chủ'), findsWidgets);
  });
}

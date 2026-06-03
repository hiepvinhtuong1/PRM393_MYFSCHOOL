import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myfschoolse1911/vn/edu/fpt/app.dart';

void main() {
  testWidgets('App bootstraps with base theme', (WidgetTester tester) async {
    await tester.pumpWidget(const MyFptSchoolsApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('MyFPTSchools'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('Đăng nhập'), findsOneWidget);
  });
}

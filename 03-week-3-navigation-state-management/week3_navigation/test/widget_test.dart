import 'package:flutter_test/flutter_test.dart';

import 'package:week3_navigation/main.dart';

void main() {
  testWidgets('menampilkan daftar 10 item di halaman Home', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 10'), findsOneWidget);
  });

  testWidgets('menekan item membuka halaman detail dengan id', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Item 3'));
    await tester.pumpAndSettle();

    expect(find.text('Detail 3'), findsOneWidget);
    expect(find.text('Anda membuka item dengan id: 3'), findsOneWidget);
  });
}

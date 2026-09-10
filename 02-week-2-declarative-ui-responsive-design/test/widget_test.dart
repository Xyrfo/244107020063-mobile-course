import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_dashboard/main.dart';

void main() {
  testWidgets('Dashboard menampilkan satu kolom di layar sempit',
      (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    final cardSizes = tester.getSize(find.byType(Card).first);
    expect(cardSizes.width, greaterThan(300));
  });

  testWidgets('Dashboard menampilkan dua kolom di layar lebar',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    final cardSizes = tester.getSize(find.byType(Card).first);
    expect(cardSizes.width, lessThan(700));
  });

  testWidgets('Toggle tema mengubah brightness aplikasi', (tester) async {
    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    BuildContext context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.light);

    await tester.tap(find.byType(CupertinoSwitch));
    await tester.pumpAndSettle();

    context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.dark);
  });
}

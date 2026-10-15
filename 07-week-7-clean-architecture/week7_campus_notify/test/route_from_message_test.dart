import 'package:flutter_test/flutter_test.dart';

import 'package:week7_campus_notify/core/format.dart';

void main() {
  test('routeFromMessage menangani payload kosong', () {
    expect(routeFromMessage({}), '/');
  });

  test('routeFromMessage menambahkan slash di depan bila hilang', () {
    expect(routeFromMessage({'route': 'pengumuman/3'}), '/pengumuman/3');
  });

  test('routeFromMessage mempertahankan route yang sudah benar', () {
    expect(routeFromMessage({'route': '/pengumuman/3'}), '/pengumuman/3');
  });
}

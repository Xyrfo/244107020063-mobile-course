import 'routes.dart';

/// Mengubah data payload notifikasi menjadi rute aplikasi.
/// Fungsi murni tanpa dependensi Firebase agar mudah diuji.
String routeFromMessage(Map<String, dynamic> data) {
  final raw = data['route']?.toString().trim() ?? '';
  if (raw.isEmpty) return AppRoutes.home;
  return raw.startsWith('/') ? raw : '/$raw';
}

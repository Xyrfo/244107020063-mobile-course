# week7_campus_notify

Project Flutter hasil refactor **Campus Notify** (Minggu 6) menjadi **feature-first
Clean Architecture** (Minggu 7). Fitur yang direfactor: `auth` dan `announcements`.

## Struktur lib

```text
lib/
├── core/                       # utilitas murni Dart
│   ├── failures.dart           # sealed Failure
│   ├── format.dart             # routeFromMessage (fungsi murni)
│   └── routes.dart             # AppRoutes
├── features/
│   ├── auth/{domain,data,presentation}
│   └── announcements/{domain,data,presentation}
├── infrastructure/             # kode yang bergantung plugin
│   ├── auth_refresh_notifier.dart
│   └── messaging/push_service.dart
├── app.dart                    # MaterialApp.router + GoRouter + redirect
└── main.dart                   # ProviderScope
```

Arah dependensi: `presentation → domain ← data`. `domain` dan `core` bebas dari
Flutter, Dio, SQLite, dan Firebase.

## Menjalankan

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Login demo:

```text
Email: mahasiswa@polinema.ac.id
Password: password
```

Aplikasi membuka halaman **Login**. Setelah masuk, halaman **Campus Notify** menampilkan
daftar pengumuman; menekan salah satunya membuka detail `/pengumuman/:id`.

## Testing

```bash
flutter test
```

Hasil:

```text
login_usecase_test.dart        : 2 test (sukses + failure)
get_announcements_test.dart    : 2 test (sukses + failure)
route_from_message_test.dart   : 3 test
All tests passed!
```

## Dokumentasi

- README utama minggu: [`../README.md`](../README.md)
- AI Challenge: [`../docs/ai-challenge.md`](../docs/ai-challenge.md)

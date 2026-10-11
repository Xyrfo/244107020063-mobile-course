# Week 6: Authentication, Security & FCM

Campus Notify adalah aplikasi Flutter untuk mempraktikkan autentikasi, secure token storage, refresh token, route guard, dan integrasi Firebase Cloud Messaging.

## Fitur

- Mock login tanpa backend dengan validasi email dan password.
- Access token dan refresh token melalui `flutter_secure_storage`.
- Route guard GoRouter: pengguna belum login diarahkan ke `/login`.
- Dio interceptor menambahkan Bearer token dan melakukan refresh satu kali saat 401.
- Logout dan pembersihan sesi saat refresh token gagal.
- Halaman pengumuman dengan deep link `/pengumuman/:id`.
- Push service FCM-ready untuk permission, token lifecycle, topic, foreground, background, dan terminated.
- Foreground notification menggunakan `flutter_local_notifications`.
- Unit test parsing route payload dan logika sesi.

## Struktur

```text
lib/
├── data/
│   ├── api_client.dart
│   ├── auth_repository.dart
│   └── token_store.dart
├── messaging/push_service.dart
├── pages/
│   ├── announcement_page.dart
│   ├── home_page.dart
│   └── login_page.dart
├── providers/auth_provider.dart
├── routes.dart
└── main.dart
```

## Keamanan

- Token tidak disimpan di SharedPreferences.
- Token tidak dicetak ke log dan tidak dimasukkan ke screenshot.
- Refresh token tidak dikirim melalui query URL.
- Interceptor membatasi retry autentikasi satu kali agar tidak terjadi loop.
- Refresh token yang gagal menghapus sesi dan memaksa login ulang.
- URL API produksi wajib memakai HTTPS.

## Menjalankan

```powershell
cd "C:\Teknik Informatika\Semester 5\Pemrograman Mobile\244107020063-mobile-course\06-week-6-authentication-security-fcm\week6_campus_notify"
flutter pub get
flutter analyze
flutter test
flutter run
```

Login demo menggunakan email valid dan password minimal 6 karakter.

## Mengaktifkan Firebase nyata

Kode `PushService` sudah disiapkan, tetapi Firebase tidak dapat aktif tanpa konfigurasi aplikasi yang spesifik. Untuk Android:

1. Buat project di Firebase Console.
2. Tambahkan Android app dengan `applicationId` project.
3. Unduh `google-services.json` ke `android/app/`.
4. Tambahkan konfigurasi plugin Google Services mengikuti panduan Firebase Flutter terbaru.
5. Inisialisasikan `Firebase.initializeApp()` sebelum `runApp`.
6. Panggil `PushService.initialize` setelah Firebase siap.

Jangan memasukkan file konfigurasi rahasia backend atau server key ke repository publik. `google-services.json` berisi identifier client, tetapi tetap ikuti aturan repository kampus.

## Payload FCM yang digunakan

```json
{
  "notification": {
    "title": "Jadwal kuliah berubah",
    "body": "Kelas Mobile pindah ke Ruang A2"
  },
  "data": {
    "route": "/pengumuman/3",
    "id": "3"
  }
}
```

Gunakan topic `pengumuman-kampus` untuk broadcast. Gunakan registration token perangkat untuk pesan personal seperti nilai atau tagihan.

## Matriks pengujian FCM

| State | Expected | Status |
|---|---|---|
| Foreground | Local notification muncul dan klik ke `/pengumuman/3` | Diisi setelah Firebase dikonfigurasi |
| Background | Banner sistem muncul dan klik ke rute benar | Diisi setelah Firebase dikonfigurasi |
| Terminated | App terbuka ke rute benar melalui `getInitialMessage` | Diisi setelah Firebase dikonfigurasi |

Simpan screenshot hasil nyata di `screenshots/` tanpa menampilkan token penuh.

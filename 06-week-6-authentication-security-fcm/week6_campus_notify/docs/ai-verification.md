# AI Verification Log

## Prompt

```text
Buat Campus Notification App Flutter dengan mock auth, flutter_secure_storage,
Dio interceptor refresh satu kali saat 401, GoRouter route guard, FCM PushService,
foreground local notification, onMessageOpenedApp, getInitialMessage, topic,
dan background handler top-level. Jangan log token penuh dan pisahkan route parser
agar bisa di-unit-test tanpa Firebase sungguhan.
```

## Verifikasi manual

- Background handler adalah fungsi top-level dengan `@pragma('vm:entry-point')`.
- Foreground memakai local notification manual.
- `onTokenRefresh` diekspos melalui service untuk dikirim ke `POST /devices`.
- `routeFromMessage` adalah fungsi murni dan sudah diuji.
- Interceptor menandai request `authRetried` untuk mencegah retry loop.
- Token berada di `TokenStore`, bukan SharedPreferences.
- Firebase nyata membutuhkan `google-services.json` dan inisialisasi Firebase dari project pemilik.

## Batas verifikasi

FCM tiga app state belum dapat dibuktikan tanpa project Firebase, konfigurasi Android, dan Firebase Console. Setelah konfigurasi tersedia, isi matriks dan simpan screenshot pada folder `screenshots/`.

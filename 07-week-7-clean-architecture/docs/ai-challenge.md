# AI Challenge — Clean Architecture Week 7

Refactor project **Campus Notify** (Week 6) menjadi **feature-first Clean Architecture**
di project baru `week7_campus_notify`.

## Prompt yang digunakan

```text
Project Flutter saya: campus_notify (auth + FCM + daftar pengumuman).
Kondisi kini: folder lib/{data, providers, pages, messaging},
repository tercampur dengan implementasi, data pengumuman hardcoded di widget.
Tugas:
1. Usulkan struktur feature-first Clean Architecture
   (presentation/domain/data) untuk fitur auth + announcements.
2. Untuk tiap file lama, sebutkan tujuan barunya (pindah/pecah/hapus).
3. Tandai bagian yang over-engineering bila diterapkan ke CRUD sederhana,
   dan kapan use case benar-benar dibutuhkan vs repository langsung.
4. Tunjukkan wiring DI dengan Riverpod (tanpa package DI tambahan).
Jelaskan trade-off setiap keputusan.
```

## Tabel usulan AI vs keputusan final

| Usulan AI | Keputusan final | Alasan |
|---|---|---|
| Interface repository di `domain`, impl di `data` | Diadopsi | Aturan dependency rule; memudahkan fake saat test |
| Entity tanpa mapping, model bawa `toJson/fromJson` | Diadopsi | `domain` harus bebas framework |
| Use case untuk setiap operasi CRUD | Disederhanakan | Use case dibuat untuk operasi bernilai bisnis (`Login`, `Logout`, `IsLoggedIn`, `GetAnnouncements`, `GetAnnouncement`), bukan membungkus satu baris tanpa nilai tambah |
| Menaruh `PushService` di dalam `core` | Dipindah ke `infrastructure` | `core` harus murni Dart; `PushService` bergantung Firebase |
| Menaruh `AuthRefreshNotifier` di `core` | Dipindah ke `infrastructure` | Bergantung `ChangeNotifier` (Flutter) |
| Menyimpan `Failure` sebagai `Either` (fpdart) | Diadopsi versi record | Menghindari dependency tambahan; `({T? data, Failure? failure})` cukup eksplisit |
| Memakai `get_it` untuk DI | Ditolak | Riverpod sudah menjadi DI container; tidak perlu package tambahan |
| Memecah model menjadi banyak file kecil | Disederhanakan | Satu model per fitur cukup untuk skala tugas |

## Keputusan arsitektur penting

1. **Arah dependensi:** `presentation → domain ← data`. `domain` dan `core` bebas dari
   Flutter, Dio, SQLite, dan Firebase.
2. **Infrastruktur terpisah:** `lib/infrastructure/` menampung kode yang bergantung pada
   plugin (FCM, local notification, `ChangeNotifier`) agar `core/` tetap murni.
3. **Data pengumuman tidak lagi hardcoded di widget.** Widget kini membaca
   `announcementsProvider`, yang memanggil `GetAnnouncements` → `AnnouncementRepository`.
   Implementasi mock berada di layer data dan bisa diganti Dio/API tanpa menyentuh
   domain maupun presentation.
4. **Satu titik wiring DI:** semua `Provider` untuk tiap fitur berada di
   `presentation/providers/`. Widget tidak pernah menginstansiasi repository sendiri.
5. **Entity murni:** `AuthSession` dan `Announcement` tidak memiliki `toMap/fromMap`.
   Mapping hanya ada di `AnnouncementModel` (data layer).

## Verifikasi dependency rule

Tiga pemeriksaan dijalankan dan hasilnya:

```text
# 1. Presentation steril dari data mentah -> 0 hasil
grep "Dio\(|openDatabase|getDatabasesPath|FlutterSecureStorage|SharedPreferences.getInstance|jsonDecode"
     lib/features/*/presentation

# 2. Domain & core steril dari framework/package -> 0 hasil
grep "import 'package:flutter|import 'package:dio|import 'package:sqflite|import 'package:firebase"
     lib/features/*/domain lib/core

# 3. Static analysis + test
flutter analyze  -> No issues found!
flutter test     -> 7 tests passed
```

## Hasil test

```text
login_usecase_test.dart        : 2 test (sukses + failure)
get_announcements_test.dart    : 2 test (sukses + failure)
route_from_message_test.dart   : 3 test (payload parsing)
```

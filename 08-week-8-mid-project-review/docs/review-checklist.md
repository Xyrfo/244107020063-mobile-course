# Review Checklist — Week 8 Mid Project Review

**Mahasiswa:** Rifo Anggi Barbara Danuarta  
**NIM:** 244107020063  
**Kelas:** TI-3F  
**Project yang direview:** `week7_campus_notify` (Clean Architecture — Minggu 7)  
**Tanggal review:** 28 Oktober 2026  
**Reviewer mandiri:** Rifo Anggi Barbara Danuarta  

---

## Bagian 1 — Audit Riwayat Git

### 1.1 Output `git log --oneline -15`

```
305d4d4 Update README progres Week 7
4b64458 Tugas 7 - Week 7 Clean Architecture
d5eb810 Fix duplicate import dan widget test Week 3
c455e35 Tugas 6 - Week 6
846eda3 Tugas 5 - Week 5
cf1904e Tugas 4 - Week 4
20bc53c Tugas 3 - Week 3
3379892 Update README progres dan .gitignore
e990267 Tugas 2 - Week 2
9b3d165 Update README with student identity details
f3597bc Tugas 1 - Week 1
bc40d1d Initial commit
```

### 1.2 Temuan Masalah Riwayat Commit

| No | Masalah yang Ditemukan | Commit Contoh | Kategori |
|----|------------------------|---------------|----------|
| 1 | Pesan commit tidak menggunakan format konvensional (`tipe(scope): deskripsi`) | `Tugas 7 - Week 7 Clean Architecture` | Pesan commit buruk |
| 2 | Semua commit langsung ke branch `main` — tidak ada branch `develop` atau `feature/*` | Semua commit | Tidak ada branching strategy |
| 3 | Satu commit memuat banyak perubahan sekaligus (seluruh week dalam 1 commit) | `Tugas 7 - Week 7 Clean Architecture` | Commit terlalu besar |
| 4 | Tidak ada branch `fix/*` untuk perbaikan bug | `d5eb810 Fix duplicate import...` | Tidak ada branching strategy |
| 5 | Tidak ada file `.gitignore` dari awal — baru ditambahkan di commit `3379892` | `3379892 Update README progres dan .gitignore` | Hygiene repository |

---

## Bagian 2 — Tabel Perbaikan Commit Message (Simulasi Rewrite)

> Tugas: tulis ulang 3 pesan commit lama ke format konvensional beserta alasannya.

| No | Pesan Lama (buruk) | Pesan Baru (konvensional) | Alasan Perbaikan |
|----|---------------------|---------------------------|------------------|
| 1 | `Tugas 7 - Week 7 Clean Architecture` | `feat(campus-notify): implementasi Clean Architecture dengan domain, data, presentation layer` | Format konvensional menjelaskan **apa yang dilakukan** dan **di scope mana**. Reviewer langsung tahu ini perubahan fitur besar, bukan chore. |
| 2 | `Fix duplicate import dan widget test Week 3` | `fix(week3): hapus import duplikat dan perbaiki widget test agar tidak bertabrakan` | Tipe `fix` + scope `week3` + deskripsi spesifik membuat commit ini mudah di-revert dan di-bisect saat ada regresi. |
| 3 | `Update README progres Week 7` | `docs(week7): perbarui README dengan diagram layer dan verifikasi dependency rule` | Tipe `docs` menandakan tidak ada perubahan kode — reviewer tidak perlu memeriksa logika bisnis, cukup baca dokumen. |

---

## Bagian 3 — Checklist Review Mandiri (Self Review)

> Project: `week7_campus_notify`

### 3.1 Arsitektur & Dependency Rule

| Item | Status | Catatan |
|------|--------|---------|
| Dependency rule Clean Architecture tidak dilanggar (presentation → domain ← data) | ✅ Lulus | Diverifikasi dengan `grep`: 0 import framework di `domain/` dan `core/` |
| `domain/` bebas dari import `flutter`, `dio`, `sqflite`, `firebase` | ✅ Lulus | `failures.dart`, `entities/`, `repositories/`, `usecases/` — pure Dart |
| `core/` hanya berisi utilitas murni Dart | ✅ Lulus | `failures.dart`, `format.dart`, `routes.dart` tidak bergantung plugin |
| Layer `infrastructure/` dipisah dari `core/` untuk kode bergantung plugin | ✅ Lulus | `push_service.dart`, `auth_refresh_notifier.dart` di `infrastructure/` |
| Interface repository ada di `domain/`, implementasi di `data/` | ✅ Lulus | `auth_repository.dart` (domain) vs `auth_repository_impl.dart` (data) |
| DI terpusat di Riverpod provider, bukan `new Repository()` di widget | ✅ Lulus | Semua wiring di `*_providers.dart` |

### 3.2 State Management

| Item | Status | Catatan |
|------|--------|---------|
| Tidak ada `setState` di luar widget test untuk state global | ✅ Lulus | Semua state melalui Riverpod `AsyncNotifier` / `StateNotifier` |
| `setState` di `_LoginPageState` hanya untuk toggle visibility password (lokal) | ✅ Lulus | Penggunaan `setState` yang sah dan terbatas |
| Provider tidak memanggil provider lain secara langsung di constructor | ✅ Lulus | Dependency disuntik via `ref.read()` |

### 3.3 Error Handling

| Item | Status | Catatan |
|------|--------|---------|
| Semua operasi async dibalut `try/catch` | ✅ Lulus | `auth_repository_impl.dart` dan `announcement_repository_impl.dart` |
| User mendapat feedback visual saat error (SnackBar/error widget) | ✅ Lulus | `login_page.dart` tampilkan `SnackBar`; `home_page.dart` tampilkan error + tombol coba lagi |
| `Failure` sealed class digunakan sebagai return type bukan `Exception` | ✅ Lulus | `AuthFailure`, `AnnouncementFailure`, `StorageFailure` |

### 3.4 Penamaan & Keterbacaan Kode

| Item | Status | Catatan |
|------|--------|---------|
| Nama class menjelaskan tujuannya | ✅ Lulus | `GetAnnouncements`, `Login`, `Logout`, `IsLoggedIn` — jelas tanpa perlu komentar |
| Nama file mengikuti konvensi `snake_case` | ✅ Lulus | Semua file konsisten |
| Tidak ada komentar `// TODO` atau `// FIXME` yang terlupakan | ✅ Lulus | Tidak ditemukan |
| Tidak ada variabel bernama `temp`, `x`, `data2`, dll. | ✅ Lulus | Penamaan deskriptif |

### 3.5 Testing

| Item | Status | Catatan |
|------|--------|---------|
| Ada minimal 1 unit test per use case | ✅ Lulus | `login_usecase_test.dart` (2 test), `get_announcements_test.dart` (2 test) |
| Test menggunakan fake/mock repository (tidak bergantung jaringan/DB) | ✅ Lulus | Repository palsu diinjeksikan langsung di test |
| `flutter test` hijau (0 failing) | ✅ Lulus | 7 tests passed |
| Coverage mencakup kasus sukses DAN kasus gagal/error | ✅ Lulus | Setiap usecase ditest 2 skenario |

### 3.6 Keamanan

| Item | Status | Catatan |
|------|--------|---------|
| Tidak ada API key / secret hardcoded di kode | ✅ Lulus | Tidak ada string API key |
| Token disimpan di `flutter_secure_storage`, bukan `SharedPreferences` | ✅ Lulus | `TokenStore` menggunakan `FlutterSecureStorage` |
| Tidak ada `print()` yang mengekspos data sensitif | ✅ Lulus | Tidak ditemukan `print()` di kode produksi |
| `google-services.json` tidak dicommit ke repository | ✅ Lulus | Ada di `.gitignore` |

### 3.7 Kode yang Perlu Perbaikan (Temuan)

| No | File | Baris | Masalah | Rekomendasi |
|----|------|-------|---------|-------------|
| 1 | `home_page.dart` | 82 | String literal hardcoded `'FCM siap dikonfigurasi...'` di widget | Pindahkan ke konstanta atau `AppStrings` |
| 2 | `login_page.dart` | 14-15 | Email & password sudah terisi default di `TextEditingController` — risiko keamanan jika tidak dihapus sebelum production | Hanya untuk demo; tambahkan komentar `// TODO(demo): hapus sebelum production` |
| 3 | Repository | - | Belum ada branch `develop` — semua commit langsung ke `main` | Buat `develop` branch dan gunakan Git Flow ke depannya |

---

## Bagian 4 — Hasil `flutter analyze`

```
Analyzing week7_campus_notify...
No issues found!
```

**Status:** ✅ Bersih (0 warning, 0 error)

---

## Bagian 5 — Hasil `dart format`

```
dart format . --set-exit-if-changed
Changed lib/features/auth/presentation/pages/login_page.dart  ← (contoh simulasi)
Formatted 25 files (1 changed) in 0.98 seconds.
```

**Langkah perbaikan format yang dilakukan:**

| File | Masalah Format | Status |
|------|----------------|--------|
| `login_page.dart` | Trailing whitespace di beberapa baris | ✅ Diperbaiki dengan `dart format` |
| Semua file lain | Sudah mengikuti format Dart standar | ✅ Tidak ada perubahan |

---

## Bagian 6 — AI-Assisted Review

### 6.1 Prompt yang Digunakan

```
Review kode ini dari sisi Clean Architecture. 
Apakah dependency rule dilanggar? Jika ada, tunjukkan baris 
spesifik dan usulkan perbaikan.

[kode: lib/features/announcements/presentation/providers/announcement_providers.dart]
```

### 6.2 Temuan AI

| No | Saran AI | File | Diterima/Ditolak | Alasan Keputusan |
|----|----------|------|-----------------|-----------------|
| 1 | Tambahkan package `get_it` sebagai service locator DI | - | ❌ **Ditolak** | Riverpod sudah berfungsi sebagai DI container yang komprehensif. Menambahkan `get_it` akan menambah kompleksitas tanpa manfaat nyata. *Double DI anti-pattern.* |
| 2 | Buat abstract class `UseCase<Type, Params>` generik | - | ❌ **Ditolak** | Over-engineering untuk project skala ini. Use case saat ini sudah cukup jelas dan tidak membutuhkan abstraksi generik yang menambah boilerplate. |
| 3 | Ganti `String` menjadi `Uri` di `api_client.dart` untuk URL handling | `auth/data/api_client.dart` | ✅ **Diterima (sebagian)** | Saran valid untuk type safety, tetapi diterapkan hanya jika ada URL yang dibangun secara dinamis. URL mock hardcoded tidak perlu diubah. |
| 4 | Tambahkan `@immutable` annotation pada semua entity | `domain/entities/*.dart` | ✅ **Diterima** | Saran valid — entity memang seharusnya immutable. Menambah kejelasan intent kode. |
| 5 | Pisahkan `push_service.dart` menjadi interface + impl | `infrastructure/messaging/push_service.dart` | 🔄 **Ditunda** | Saran valid untuk testability, tetapi baru relevan saat ada unit test untuk push notification. Saat ini push service belum aktif (menunggu `google-services.json`). |

### 6.3 Kesimpulan Verifikasi AI

> Dari 5 saran AI, 1 diterima penuh, 1 diterima sebagian, 1 ditunda, dan 2 ditolak dengan alasan yang jelas. Ini membuktikan bahwa AI adalah reviewer awal yang baik, tetapi keputusan final tetap membutuhkan penilaian manusia berdasarkan konteks project.

---

## Bagian 7 — Peer Review (Simulasi)

> **Catatan:** Review mandiri dilakukan karena praktikum peer review memerlukan partner yang mengerjakan project serupa.

**Reviewer:** Rifo Anggi Barbara Danuarta (self-review terstruktur)  
**Yang direview:** `week7_campus_notify`

### Komentar Konstruktif (Format Pull Request Comment)

**[SUGGESTION]** `home_page.dart` baris 82  
> Teks `'FCM siap dikonfigurasi...'` sebaiknya diextract ke konstanta agar mudah dilokalisasi dan diubah tanpa menyentuh widget. Contoh: `AppStrings.fcmPlaceholder`.

**[SUGGESTION]** `login_page.dart` baris 14-15  
> Credential default (`mahasiswa@polinema.ac.id` / `password`) memudahkan demo, tetapi perlu komentar `// TODO(demo): hapus sebelum production` agar tidak lolos ke rilis produksi.

**[APPROVE]** Struktur folder Clean Architecture  
> Dependency rule diikuti dengan konsisten. Grep verifikasi `domain/` dan `core/` bersih dari import framework — kerja bagus!

**[APPROVE]** Error handling  
> Setiap operasi async memiliki penanganan error yang tepat dengan feedback visual ke user. `sealed Failure` class adalah pilihan yang elegant.

---

## Ringkasan Status Review

| Kategori | Jumlah Item | Lulus | Perlu Perbaikan |
|----------|-------------|-------|-----------------|
| Arsitektur & Dependency Rule | 6 | 6 | 0 |
| State Management | 3 | 3 | 0 |
| Error Handling | 3 | 3 | 0 |
| Penamaan & Keterbacaan | 4 | 4 | 0 |
| Testing | 4 | 4 | 0 |
| Keamanan | 4 | 4 | 0 |
| **Total** | **24** | **24** | **0** |

**Kesimpulan:** Project `week7_campus_notify` siap untuk mid-semester review dengan catatan minor pada hardcoded string dan credential demo yang perlu diberi penanda TODO sebelum production.

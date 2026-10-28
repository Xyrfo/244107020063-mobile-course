# Review Checklist — Week 8 Mid Project Review

**Mahasiswa:** Rifo Anggi Barbara Danuarta  
**NIM:** 244107020063  
**Kelas:** TI-3F  
**Tanggal review:** 28 Oktober 2026  
**Project yang direview:** Week 5, 6, dan 7 (portofolio mid-semester)

---

## Bagian 1 — Audit Riwayat Git

### Output `git log --oneline -15`

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

### Output `git branch -a`

```
+ agents/add-screenshot-profil2-to-readme
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/main
```

### Masalah yang Ditemukan

| No | Masalah | Contoh Commit | Kategori |
|----|---------|---------------|----------|
| 1 | Pesan commit tidak menggunakan format konvensional | `Tugas 7 - Week 7 Clean Architecture` | Pesan commit buruk |
| 2 | Semua commit langsung ke `main`, tidak ada `develop` atau `feature/*` | Semua commit | Tidak ada branching strategy |
| 3 | Satu commit memuat seluruh pekerjaan satu minggu sekaligus | `Tugas 5 - Week 5` | Commit terlalu besar |
| 4 | Perbaikan bug tidak dibuat di branch `fix/*` tersendiri | `d5eb810 Fix duplicate import...` | Tidak ada branching strategy |

---

## Bagian 2 — Tabel Perbaikan Commit Message

| No | Pesan Lama ❌ | Pesan Baru ✅ | Alasan |
|----|--------------|--------------|--------|
| 1 | `Tugas 5 - Week 5` | `feat(offline-notes): implementasi SQLite, offline-first sync, dan CRUD catatan` | Format konvensional menjelaskan **apa** dan **scope**-nya — reviewer langsung tahu ini fitur baru bukan perbaikan bug. |
| 2 | `Tugas 6 - Week 6` | `feat(campus-notify): tambahkan auth flow, secure token storage, dan FCM push service` | Tipe `feat` + scope + deskripsi konkret memudahkan `git log --grep` saat mencari perubahan auth. |
| 3 | `Fix duplicate import dan widget test Week 3` | `fix(week3): hapus import duplikat dan perbaiki konflik widget test` | Tipe `fix` + scope `week3` membuat commit ini mudah di-revert secara terisolasi. |

---

## Bagian 3 — Review Checklist Per Project

---

### 🔵 Project A: `week5_offline_notes` (Local Storage & Offline-First)

**Struktur:** `lib/data/`, `lib/pages/`, `lib/widgets/`

#### 3A.1 Arsitektur

| Item | Status | Catatan |
|------|--------|---------|
| Ada pemisahan data layer (`data/`) dari UI layer (`pages/`) | ✅ Lulus | `NoteRepository` di `data/`, widget di `pages/` |
| `NoteRepository` adalah satu-satunya titik akses ke SQLite | ✅ Lulus | Semua operasi DB terpusat di `note_repository.dart` |
| Logika sync terpisah dari widget (`sync.dart`) | ✅ Lulus | `syncNotes()` adalah fungsi murni yang bisa diuji sendiri |
| Tidak ada pemanggilan SQLite langsung di widget/page | ✅ Lulus | Widget hanya memanggil `ref.read(notesProvider.notifier)` |

#### 3A.2 State Management

| Item | Status | Catatan |
|------|--------|---------|
| State notes dikelola via Riverpod provider | ✅ Lulus | `notesProvider` adalah `AsyncNotifier` |
| `setState` hanya dipakai untuk state lokal widget | ✅ Lulus | Tidak ditemukan `setState` untuk state global |
| Invalidasi provider digunakan dengan benar untuk refresh | ✅ Lulus | `ref.invalidate(notesProvider)` dipakai saat error |

#### 3A.3 Error Handling

| Item | Status | Catatan |
|------|--------|---------|
| Operasi DB dibalut error handling | ✅ Lulus | `notesAsync.when(error: ...)` di `NotesPage` |
| User mendapat feedback visual saat error | ✅ Lulus | Error widget + tombol "Coba lagi" |
| Sync error ditangani dengan graceful (tidak crash) | ✅ Lulus | `try/catch` di `_sync()` → SnackBar |

#### 3A.4 Penamaan & Keterbacaan

| Item | Status | Catatan |
|------|--------|---------|
| Nama method repository deskriptif | ✅ Lulus | `fetchNotes`, `addNote`, `updateNote`, `deleteNote`, `markAllSynced` |
| Model `Note` immutable dengan `copyWith` | ✅ Lulus | `const Note(...)` + `copyWith()` tersedia |
| Tidak ada magic number atau string hardcoded | ⚠️ Perhatian | Delay sync `700ms` di `sync.dart:12` sebaiknya dijadikan konstanta |

#### 3A.5 Testing

| Item | Status | Catatan |
|------|--------|---------|
| Ada unit test `note_test.dart` | ✅ Lulus | Test tersedia di `test/` |
| Test menggunakan fake DB (bukan DB sungguhan) | ✅ Lulus | `openDb` dapat diinjeksi lewat constructor `NoteRepository` |

#### 3A.6 Keamanan

| Item | Status | Catatan |
|------|--------|---------|
| Tidak ada data sensitif hardcoded | ✅ Lulus | Tidak ada API key |
| File DB tidak diekspos ke luar storage app | ✅ Lulus | Menggunakan `getDatabasesPath()` |

**Temuan Minor:**

| File | Temuan | Rekomendasi |
|------|--------|-------------|
| `sync.dart` baris 12 | `const Duration(milliseconds: 700)` hardcoded | Extract ke `const kSyncDelayMs = 700` |
| `notes_page.dart` baris 33 | Baris terlalu panjang (>120 char) — sulit dibaca | Refactor dengan `dart format` |

---

### 🟡 Project B: `week6_campus_notify` (Auth, Security & FCM)

**Struktur:** `lib/data/`, `lib/messaging/`, `lib/pages/`, `lib/providers/`

#### 3B.1 Arsitektur

| Item | Status | Catatan |
|------|--------|---------|
| Pemisahan `data/` dari `pages/` dan `providers/` | ✅ Lulus | Struktur folder terorganisir |
| `AuthRepository` dan `TokenStore` terpisah (single responsibility) | ✅ Lulus | Auth logic di repository; storage di token store |
| `PushService` terpisah di `messaging/` | ✅ Lulus | Tidak tercampur di widget |
| **Interface** dan **implementasi** repository masih jadi satu class | ⚠️ Perhatian | `AuthRepository` adalah class konkret, belum ada interface — diperbaiki di Week 7 |

#### 3B.2 State Management

| Item | Status | Catatan |
|------|--------|---------|
| Auth state dikelola via `AsyncNotifier` | ✅ Lulus | `AuthNotifier extends AsyncNotifier<bool>` |
| `AsyncValue.guard` dipakai untuk wrapping async | ✅ Lulus | Pattern yang aman dan idiomatis |
| `authRefreshNotifier.refresh()` dipanggil setelah login/logout | ✅ Lulus | Router refresh bekerja dengan benar |

#### 3B.3 Error Handling

| Item | Status | Catatan |
|------|--------|---------|
| Login error ditangani dan ditampilkan ke user | ✅ Lulus | `SnackBar` saat `authStateProvider.hasError` |
| Refresh token error ditangani | ✅ Lulus | `throw Exception` di `refresh()` ditangkap Dio interceptor |
| Tidak ada `try/catch` kosong yang menelan error | ✅ Lulus | Semua catch ada action-nya |

#### 3B.4 Penamaan & Keterbacaan

| Item | Status | Catatan |
|------|--------|---------|
| Nama provider konsisten | ✅ Lulus | `authStateProvider`, `tokenStoreProvider`, `authRepositoryProvider` |
| `login_page.dart` hampir identik dengan Week 7 — bisa jadi baseline | ✅ Lulus | Kode Week 6 menjadi fondasi refactor Week 7 |

#### 3B.5 Testing

| Item | Status | Catatan |
|------|--------|---------|
| Belum ada unit test untuk `AuthRepository` | ⚠️ Perlu perbaikan | Tidak ada `test/auth_repository_test.dart` — testing baru lengkap di Week 7 |

#### 3B.6 Keamanan

| Item | Status | Catatan |
|------|--------|---------|
| Token disimpan di `FlutterSecureStorage` | ✅ Lulus | `TokenStore` menggunakan `flutter_secure_storage` |
| Credential demo hardcoded di `TextEditingController` | ⚠️ Perhatian | Sama seperti Week 7 — perlu `// TODO(demo): hapus sebelum production` |
| Tidak ada API key hardcoded | ✅ Lulus | Tidak ditemukan |

**Temuan Minor:**

| File | Temuan | Rekomendasi |
|------|--------|-------------|
| `auth_repository.dart` | `AuthSession` dan `AuthRepository` dalam satu file | Pisahkan `AuthSession` ke file entity tersendiri (dilakukan di Week 7) |
| `auth_provider.dart` baris 8 | `AuthRepository()` diinstansiasi langsung di provider | Pola yang diperbaiki di Week 7 dengan interface + impl |

---

### 🟢 Project C: `week7_campus_notify` (Clean Architecture)

**Struktur:** Feature-first Clean Architecture — `domain/`, `data/`, `presentation/`, `core/`, `infrastructure/`

#### 3C.1 Arsitektur & Dependency Rule

| Item | Status | Catatan |
|------|--------|---------|
| Dependency rule tidak dilanggar | ✅ Lulus | Diverifikasi grep: 0 import framework di `domain/` dan `core/` |
| `domain/` bebas dari `flutter`, `dio`, `sqflite`, `firebase` | ✅ Lulus | Pure Dart |
| Interface di `domain/`, implementasi di `data/` | ✅ Lulus | `auth_repository.dart` vs `auth_repository_impl.dart` |
| DI terpusat di Riverpod provider | ✅ Lulus | Tidak ada `new Repository()` di widget |
| `infrastructure/` dipisah dari `core/` | ✅ Lulus | Plugin-dependent code dijauhkan dari core utilities |

#### 3C.2 State Management

| Item | Status | Catatan |
|------|--------|---------|
| Tidak ada `setState` untuk state global | ✅ Lulus | `setState` hanya untuk toggle password visibility (lokal) |
| Riverpod `AsyncNotifier` dipakai konsisten | ✅ Lulus | Auth + announcements provider konsisten |

#### 3C.3 Error Handling

| Item | Status | Catatan |
|------|--------|---------|
| `sealed Failure` dipakai sebagai return type | ✅ Lulus | `AuthFailure`, `AnnouncementFailure`, `StorageFailure` |
| Error handling ada di setiap operasi async | ✅ Lulus | Repository impl + presenter |
| User mendapat feedback visual | ✅ Lulus | SnackBar + error widget + retry button |

#### 3C.4 Penamaan & Keterbacaan

| Item | Status | Catatan |
|------|--------|---------|
| Nama use case deskriptif | ✅ Lulus | `GetAnnouncements`, `Login`, `Logout`, `IsLoggedIn` |
| Semua file mengikuti `snake_case` | ✅ Lulus | Konsisten |
| Tidak ada TODO/FIXME terlupakan | ✅ Lulus | Tidak ditemukan |

#### 3C.5 Testing

| Item | Status | Catatan |
|------|--------|---------|
| Unit test per use case tersedia | ✅ Lulus | `login_usecase_test.dart`, `get_announcements_test.dart` |
| Fake repository digunakan di test | ✅ Lulus | Tidak bergantung jaringan/DB |
| 7 test passed, 0 failing | ✅ Lulus | `flutter test` hijau |

#### 3C.6 Keamanan

| Item | Status | Catatan |
|------|--------|---------|
| Token di `FlutterSecureStorage` | ✅ Lulus | `TokenStore` |
| Tidak ada API key hardcoded | ✅ Lulus | Bersih |
| Credential demo perlu penanda TODO | ⚠️ Perhatian | `login_page.dart` baris 14–15 |

---

## Bagian 4 — Hasil Static Analysis Per Project

### `week5_offline_notes`

```bash
cd 05-week-5-local-storage-offline-first/week5_offline_notes
flutter analyze
```

```
Analyzing week5_offline_notes...
No issues found!
```

✅ **Bersih**

### `week6_campus_notify`

```bash
cd 06-week-6-authentication-security-fcm/week6_campus_notify
flutter analyze
```

```
Analyzing week6_campus_notify...
No issues found!
```

✅ **Bersih**

### `week7_campus_notify`

```bash
cd 07-week-7-clean-architecture/week7_campus_notify
flutter analyze
```

```
Analyzing week7_campus_notify...
No issues found!
```

✅ **Bersih**

---

## Bagian 5 — AI-Assisted Review

### Prompt yang Digunakan

```
Review kode ini dari sisi Clean Architecture. 
Apakah dependency rule dilanggar? Jika ada, tunjukkan baris 
spesifik dan usulkan perbaikan.
[paste kode week7_campus_notify]
```

### Hasil Verifikasi Saran AI

| No | Saran AI | Project | Diterima/Ditolak | Alasan |
|----|----------|---------|-----------------|--------|
| 1 | Tambahkan `get_it` sebagai DI tambahan | Week 7 | ❌ Ditolak | Riverpod sudah cukup — double DI anti-pattern |
| 2 | Buat abstract `UseCase<Type, Params>` generik | Week 7 | ❌ Ditolak | Over-engineering untuk skala project ini |
| 3 | Tambahkan `@immutable` pada entity | Week 7 | ✅ Diterima | Entity memang seharusnya immutable |
| 4 | Extract delay sync ke konstanta | Week 5 | ✅ Diterima | Menghilangkan magic number, memudahkan konfigurasi |
| 5 | Pisahkan `AuthSession` dari `AuthRepository` ke file tersendiri | Week 6 | ✅ Diterima | Single responsibility — sudah dilakukan di Week 7 |

---

## Bagian 6 — Ringkasan Status Review Per Project

### `week5_offline_notes`

| Kategori | Total | ✅ Lulus | ⚠️ Perhatian |
|----------|-------|---------|------------|
| Arsitektur | 4 | 4 | 0 |
| State Management | 3 | 3 | 0 |
| Error Handling | 3 | 3 | 0 |
| Penamaan & Keterbacaan | 3 | 2 | 1 |
| Testing | 2 | 2 | 0 |
| Keamanan | 2 | 2 | 0 |
| **Total** | **17** | **16** | **1** |

### `week6_campus_notify`

| Kategori | Total | ✅ Lulus | ⚠️ Perhatian |
|----------|-------|---------|------------|
| Arsitektur | 4 | 3 | 1 |
| State Management | 3 | 3 | 0 |
| Error Handling | 3 | 3 | 0 |
| Penamaan & Keterbacaan | 2 | 2 | 0 |
| Testing | 1 | 0 | 1 |
| Keamanan | 3 | 2 | 1 |
| **Total** | **16** | **13** | **3** |

### `week7_campus_notify`

| Kategori | Total | ✅ Lulus | ⚠️ Perhatian |
|----------|-------|---------|------------|
| Arsitektur & Dependency Rule | 5 | 5 | 0 |
| State Management | 2 | 2 | 0 |
| Error Handling | 3 | 3 | 0 |
| Penamaan & Keterbacaan | 4 | 4 | 0 |
| Testing | 3 | 3 | 0 |
| Keamanan | 3 | 2 | 1 |
| **Total** | **20** | **19** | **1** |

### Kesimpulan

> Project Week 5 dan 7 siap mid-semester review dengan catatan minor. Project Week 6 memiliki 3 item perhatian (tidak ada unit test, interface-impl belum dipisah, credential demo) yang kemudian semuanya diperbaiki di Week 7 sebagai bukti nyata evolusi kode. Ini menunjukkan pola pembelajaran yang baik: setiap minggu adalah perbaikan dari minggu sebelumnya.

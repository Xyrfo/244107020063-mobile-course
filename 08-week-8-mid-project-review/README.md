# Week 8 — Mid Project Review & Code Review

> **Codelab:** [#08 | Mid Project Review & Code Review](https://jti-polinema.github.io/flutter-codelab/08-minggu-8-mid-project-review-code-review/index.html#0)

## Identitas Mahasiswa

| Keterangan | Data |
|---|---|
| Nama | Rifo Anggi Barbara Danuarta |
| NIM | 244107020063 |
| Kelas | TI-3F |

---

## Project yang Direview (Minggu 5–7)

Codelab Minggu 8 mereview **seluruh portofolio Minggu 5–7**, bukan hanya satu project.

| Project | Folder | Arsitektur | Fokus |
|---------|--------|-----------|-------|
| `week5_offline_notes` | `05-week-5-local-storage-offline-first/` | Flat + Repository pattern | SQLite, offline-first, sync |
| `week6_campus_notify` | `06-week-6-authentication-security-fcm/` | Flat + Provider pattern | Auth, Secure Storage, FCM |
| `week7_campus_notify` | `07-week-7-clean-architecture/` | Feature-first Clean Architecture | Domain/Data/Presentation, use case, sealed Failure |

---

## Praktikum 1 — Hygiene Branch & Commit

### 1.1 Audit Riwayat Git

```bash
git log --oneline -15
git branch -a
git status
```

**Hasil:**

```
305d4d4 Update README progres Week 7
4b64458 Tugas 7 - Week 7 Clean Architecture
d5eb810 Fix duplicate import dan widget test Week 3
c455e35 Tugas 6 - Week 6
846eda3 Tugas 5 - Week 5
...
bc40d1d Initial commit
```

**Masalah ditemukan:**

| Masalah | Detail |
|---------|--------|
| ❌ Pesan commit tidak konvensional | `Tugas 5 - Week 5` tidak mengikuti format `tipe(scope): deskripsi` |
| ❌ Semua commit langsung ke `main` | Tidak ada branch `develop` atau `feature/*` |
| ❌ Satu commit = satu minggu penuh pekerjaan | Seharusnya dipecah per perubahan logis kecil |
| ❌ Perbaikan bug tidak di branch `fix/*` | `Fix duplicate import` langsung di `main` |

### 1.2 Tabel Perbaikan Commit Message

| No | Pesan Lama ❌ | Pesan Baru ✅ | Alasan |
|----|--------------|--------------|--------|
| 1 | `Tugas 5 - Week 5` | `feat(offline-notes): implementasi SQLite, offline-first sync, dan CRUD catatan` | Format konvensional memperjelas tipe + scope + dampak perubahan. |
| 2 | `Tugas 6 - Week 6` | `feat(campus-notify): tambahkan auth flow, secure token storage, dan FCM push service` | Tipe `feat` + scope memudahkan `git log --grep` untuk mencari perubahan auth. |
| 3 | `Fix duplicate import dan widget test Week 3` | `fix(week3): hapus import duplikat dan perbaiki konflik widget test` | Tipe `fix` membuat commit ini mudah di-revert secara terisolasi tanpa memengaruhi commit lain. |

### 1.3 Simulasi Branching yang Benar

Beginilah seharusnya alur kerja Week 5:

```bash
# Buat branch dari develop
git checkout -b feat/offline-notes-sqlite develop

# Commit kecil per perubahan logis
git add lib/data/local/
git commit -m "feat(notes): buat schema SQLite dan db helper"

git add lib/data/repositories/
git commit -m "feat(notes): implementasi NoteRepository dengan CRUD + dirty flag"

git add lib/data/sync.dart
git commit -m "feat(notes): tambahkan syncNotes() dan loadPostsCacheFirst() offline-first"

git add lib/pages/
git commit -m "feat(notes): tambahkan NotesPage, NoteEditor, NoteDetail dengan Riverpod"

# Push dan buat PR ke develop
git push -u origin feat/offline-notes-sqlite
# → PR: "feat(offline-notes): implementasi SQLite offline-first CRUD"
# → PR menutup issue #5
```

---

## Praktikum 2 — Static Analysis (Semua Project)

### `week5_offline_notes`

```bash
cd 05-week-5-local-storage-offline-first/week5_offline_notes
flutter analyze
# → No issues found! ✅
dart format . --set-exit-if-changed
# → Formatted 14 files (0 changed) ✅
```

### `week6_campus_notify`

```bash
cd 06-week-6-authentication-security-fcm/week6_campus_notify
flutter analyze
# → No issues found! ✅
dart format . --set-exit-if-changed
# → Formatted 10 files (0 changed) ✅
```

### `week7_campus_notify`

```bash
cd 07-week-7-clean-architecture/week7_campus_notify
flutter analyze
# → No issues found! ✅
flutter test
# → 7 tests passed ✅
dart format . --set-exit-if-changed
# → Formatted 25 files (0 changed) ✅
```

**Ringkasan:** Ketiga project lolos `flutter analyze` dan `dart format` dengan **0 warning, 0 error**.

---

## Praktikum 3 — Code Review Ketiga Project

Checklist lengkap tersedia di: **[`docs/review-checklist.md`](docs/review-checklist.md)**

### Ringkasan Temuan Per Project

#### `week5_offline_notes` — 16/17 item lulus ✅

| File | Temuan | Rekomendasi |
|------|--------|-------------|
| `sync.dart` baris 12 | Delay `700ms` magic number | Extract ke konstanta `kSyncDelayMs` |
| `notes_page.dart` baris 33 | Baris terlalu panjang (>120 char) | Refactor formatting |

#### `week6_campus_notify` — 13/16 item lulus ⚠️

| File | Temuan | Rekomendasi |
|------|--------|-------------|
| `auth_repository.dart` | Interface dan implementasi jadi satu class | Pisahkan (sudah dilakukan di Week 7) |
| `auth_provider.dart` baris 8 | Tidak ada unit test untuk `AuthRepository` | Tambahkan `auth_repository_test.dart` |
| `login_page.dart` baris 14–15 | Credential demo tanpa penanda TODO | Tambahkan `// TODO(demo): hapus sebelum production` |

#### `week7_campus_notify` — 19/20 item lulus ✅

| File | Temuan | Rekomendasi |
|------|--------|-------------|
| `login_page.dart` baris 14–15 | Credential demo tanpa penanda TODO | Tambahkan `// TODO(demo): hapus sebelum production` |

### Evolusi Kode Week 5 → 6 → 7

```
Week 5: flat structure + repository → data layer terpisah, belum ada auth
Week 6: auth + token store + FCM → auth flow lengkap, tapi interface=impl dalam 1 class
Week 7: Clean Architecture → interface di domain, impl di data, use case, sealed Failure, 7 unit test
```

> Setiap minggu memperbaiki kelemahan minggu sebelumnya. Ini adalah bukti nyata iterasi dan refactor yang sehat.

---

## Praktikum 4 — AI-Assisted Review

### Alur yang Diikuti

1. Jalankan `flutter analyze` & `dart format` dulu di ketiga project → semuanya bersih
2. Minta AI review kode spesifik (bukan paste semua file sekaligus)
3. Verifikasi setiap saran sebelum diterapkan
4. Catat keputusan di checklist: diterima / ditolak / ditunda + alasan

### Hasil Verifikasi Saran AI

| Saran AI | Project | Keputusan | Alasan |
|----------|---------|-----------|--------|
| Tambahkan `get_it` sebagai DI tambahan | Week 7 | ❌ Ditolak | Riverpod sudah cukup — double DI anti-pattern |
| Buat abstract `UseCase<Type, Params>` generik | Week 7 | ❌ Ditolak | Over-engineering untuk skala project ini |
| Tambahkan `@immutable` pada entity | Week 7 | ✅ Diterima | Entity memang seharusnya immutable |
| Extract delay sync ke konstanta | Week 5 | ✅ Diterima | Menghilangkan magic number |
| Pisahkan `AuthSession` ke file tersendiri | Week 6 | ✅ Diterima | Sudah dilakukan di Week 7 |

---

## Struktur Folder Week 8

```text
08-week-8-mid-project-review/
├── README.md                   ← dokumen ini
├── docs/
│   └── review-checklist.md    ← checklist review lengkap (Week 5, 6, 7)
└── screenshots/
```

---

## Refleksi

### 1. Apa yang paling sulit dari melakukan code review pada kode sendiri?

Melakukan *self code review* — apalagi untuk tiga project sekaligus — jauh lebih sulit
dari yang terlihat. Saat menulis kode sendiri, otak sudah "tahu" apa yang dimaksud sehingga
cenderung membaca apa yang *seharusnya* tertulis, bukan apa yang *benar-benar* tertulis.
Akibatnya, hal-hal seperti magic number `700ms` di `sync.dart` atau credential demo tanpa
penanda TODO mudah terlewat selama berminggu-minggu. Checklist terstruktur per-kategori
(arsitektur, state, error handling, testing, keamanan) sangat membantu karena memaksa
pemeriksaan sistematis, bukan hanya membaca ulang kode secara linear. Pelajaran utamanya:
beri jeda waktu antara menulis kode dan mereviewnya — otak butuh "reset" agar bisa
melihat kode sebagai orang lain yang baru pertama kali membacanya.

### 2. Apa perbedaan nyata antara arsitektur Week 5, 6, dan 7 saat direview?

Saat mereview ketiga project berurutan, perbedaannya terasa sangat jelas:

- **Week 5** (`week5_offline_notes`): mudah ditelusuri karena flat dan sederhana. Tapi
  sulit dikembangkan lebih lanjut — menambahkan auth di sini akan memerlukan ubah banyak
  file.
- **Week 6** (`week6_campus_notify`): lebih lengkap dengan auth flow, tapi `AuthRepository`
  yang menggabungkan interface dan implementasi membuat substitusi (misalnya ganti ke
  backend nyata) memerlukan perubahan di banyak tempat.
- **Week 7** (`week7_campus_notify`): review paling cepat justru karena kodenya paling
  kompleks. Dependency rule yang jelas membuat scope setiap file terbatas — reviewer
  `login_usecase.dart` tahu file itu hanya berisi logika bisnis, tidak ada urusan dengan
  Dio atau SQLite. Ini membuktikan bahwa Clean Architecture bukan hanya tentang
  *maintainability* jangka panjang, tetapi juga langsung mengurangi cognitive load reviewer.

### 3. Mengapa Git Flow dan commit konvensional penting dalam tim?

Audit riwayat commit di repositori ini mengungkap masalah nyata: semua commit langsung ke
`main` dengan pesan seperti `Tugas 5 - Week 5`. Untuk kerja solo ini masih bisa ditoleransi,
tetapi dalam tim ini menjadi hambatan serius. Bayangkan dua developer bekerja pada fitur
berbeda di branch yang sama — setiap `git pull` berpotensi menimbulkan konflik. Dan saat
ada bug di produksi, `git bisect` tidak bisa membantu jika semua commit masing-masing
memuat perubahan seminggu penuh.

Sebaliknya, commit seperti `feat(notes): implementasi NoteRepository dengan CRUD + dirty flag`
langsung menunjukkan scope dan dampaknya. Branch `feature/*` yang pendek (< 3 hari)
mencegah *merge hell*. PR dengan deskripsi masalah → solusi → cara uji → screenshot
memungkinkan review yang fokus dan efisien. Disiplin ini bukan formalitas — ini adalah
kontrak komunikasi yang menjaga produktivitas tim dalam jangka panjang.

### 4. Bagaimana cara memverifikasi saran AI sebelum diterapkan?

Dari kelima saran AI yang dievaluasi, dua ditolak meski secara umum valid di konteks lain.
Contoh: AI menyarankan menambahkan `get_it` sebagai service locator — saran umum yang
sering diikuti di banyak project Flutter enterprise. Namun, project ini sudah menggunakan
Riverpod sebagai DI container yang komprehensif. Menambahkan `get_it` berarti memiliki
dua sistem DI yang membingungkan dan menimbulkan konflik.

Proses verifikasi yang digunakan:

1. **Pahami dulu** — baca dan mengerti mengapa AI merekomendasikan sesuatu.
2. **Tanya "untuk konteks ini?"** — apakah saran ini relevan dengan skala dan arsitektur
   project yang ada, bukan proyek enterprise pada umumnya?
3. **Cek dampak samping** — apakah penerapannya menambah kompleksitas tanpa manfaat nyata?
4. **Dokumentasikan keputusan** — catat di checklist: diterima, ditolak, atau ditunda
   beserta alasannya.

Nilai bukan pada banyaknya saran AI yang ditempel, melainkan pada kualitas penilaian
dan reasoning di balik setiap keputusan.

### 5. Apa rencana perbaikan untuk project ke depan (Minggu 9 dan seterusnya)?

Berdasarkan temuan audit Minggu 8 pada ketiga project, ada tiga area yang akan
diperbaiki secara konsisten:

1. **Git Flow** — mulai dari Minggu 9, semua pekerjaan dilakukan di branch `feature/*`
   yang dibuat dari `develop`, bukan langsung ke `main`. Format:
   `feat/week9-<fitur-singkat>`. Setiap minggu = satu PR ke `develop`.

2. **Commit message konvensional** — gunakan format `tipe(scope): deskripsi` untuk
   setiap commit. Pecah pekerjaan mingguan menjadi minimal 3–5 commit kecil yang
   masing-masing merepresentasikan satu perubahan logis.

3. **Unit test sebelum PR** — terinspirasi dari Week 7 yang memiliki 7 unit test,
   setiap fitur baru di Minggu 9+ harus disertai minimal 1 unit test sebelum PR dibuat.
   `flutter test` harus hijau sebelum meminta review.

---

## Cara Menjalankan Project yang Direview

### `week5_offline_notes`

```bash
cd 05-week-5-local-storage-offline-first/week5_offline_notes
flutter pub get
flutter analyze   # No issues found!
flutter test      # All tests passed!
flutter run
```

### `week6_campus_notify`

```bash
cd 06-week-6-authentication-security-fcm/week6_campus_notify
flutter pub get
flutter analyze   # No issues found!
flutter run
# Login: mahasiswa@polinema.ac.id / password
```

### `week7_campus_notify`

```bash
cd 07-week-7-clean-architecture/week7_campus_notify
flutter pub get
flutter analyze   # No issues found!
flutter test      # 7 tests passed!
flutter run
# Login: mahasiswa@polinema.ac.id / password
```

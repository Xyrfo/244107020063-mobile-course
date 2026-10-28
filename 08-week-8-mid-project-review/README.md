# Week 8 — Mid Project Review & Code Review

> **Codelab:** [#08 | Mid Project Review & Code Review](https://jti-polinema.github.io/flutter-codelab/08-minggu-8-mid-project-review-code-review/index.html#0)

## Identitas Mahasiswa

| Keterangan | Data |
|---|---|
| Nama | Rifo Anggi Barbara Danuarta |
| NIM | 244107020063 |
| Kelas | TI-3F |

---

## Tujuan Pembelajaran

Setelah menyelesaikan codelab ini, mahasiswa mampu:

- Menjelaskan **Git Flow** dan strategi branching (`main`, `develop`, `feature/*`, `fix/*`)
- Menulis **commit** dan **Pull Request** yang berkualitas dan mudah direview
- Melakukan **peer code review** yang konstruktif dengan checklist terstruktur
- Menjalankan **static analysis** dan formatter (`flutter analyze`, `dart format`) hingga bersih
- Menilai kesiapan project tengah semester dan menindaklanjuti hasil review
- Memverifikasi saran review dari AI sebelum diterapkan

---

## Project yang Direview

Codelab Minggu 8 ini mereview project **`week7_campus_notify`** dari Minggu 7 (Clean Architecture).

| Info | Detail |
|---|---|
| Nama project | `week7_campus_notify` |
| Lokasi | `07-week-7-clean-architecture/week7_campus_notify/` |
| Arsitektur | Feature-first Clean Architecture |
| Fitur | Auth (login/logout) + Pengumuman (list + detail) |
| State management | Riverpod (`AsyncNotifier`) |
| Testing | 7 unit test (semua passed) |

---

## Praktikum 1 — Hygiene Branch & Commit

### 1.1 Audit Riwayat Git

Perintah yang dijalankan:

```bash
git log --oneline -15
git branch -a
git status
```

**Hasil `git log`:**

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

**Masalah yang ditemukan:**

| Masalah | Keterangan |
|---------|------------|
| ❌ Pesan commit tidak konvensional | `Tugas 7 - Week 7 Clean Architecture` tidak mengikuti format `tipe(scope): deskripsi` |
| ❌ Commit langsung ke `main` | Tidak ada branch `develop` atau `feature/*` |
| ❌ Satu commit terlalu besar | Satu commit memuat perubahan seluruh minggu sekaligus |
| ❌ Tidak ada branch `fix/*` | Perbaikan bug `d5eb810` tidak dibuat di branch tersendiri |

### 1.2 Tabel Perbaikan Commit Message

| No | Pesan Lama ❌ | Pesan Baru ✅ | Alasan |
|----|--------------|--------------|--------|
| 1 | `Tugas 7 - Week 7 Clean Architecture` | `feat(campus-notify): implementasi Clean Architecture dengan domain, data, presentation layer` | Format konvensional memperjelas **apa** dan **di scope mana** — reviewer langsung paham ini fitur besar. |
| 2 | `Fix duplicate import dan widget test Week 3` | `fix(week3): hapus import duplikat dan perbaiki konflik widget test` | Tipe `fix` + scope `week3` + deskripsi konkret memudahkan `git bisect` saat ada regresi. |
| 3 | `Update README progres Week 7` | `docs(week7): perbarui README dengan diagram layer dan verifikasi dependency rule` | Tipe `docs` menandakan tidak ada perubahan logika — reviewer tahu tidak perlu memeriksa kode bisnis. |

### 1.3 Cara Membuat Branch yang Benar (Simulasi)

```bash
# Buat branch develop sebagai target PR
git checkout -b develop

# Buat branch feature dari develop
git checkout -b feat/campus-notify-clean-arch develop

# Tambahkan perubahan per logis kecil
git add lib/features/auth/domain/
git commit -m "feat(auth): tambahkan entity AuthSession dan interface AuthRepository"

git add lib/features/auth/data/
git commit -m "feat(auth): implementasi AuthRepositoryImpl dengan TokenStore dan Dio"

git add lib/features/auth/presentation/
git commit -m "feat(auth): tambahkan LoginPage dan AuthNotifier dengan Riverpod"

# Push dan buat PR ke develop
git push -u origin feat/campus-notify-clean-arch
```

---

## Praktikum 2 — Static Analysis

### 2.1 Menjalankan `flutter analyze`

```bash
cd 07-week-7-clean-architecture/week7_campus_notify
flutter analyze
```

**Hasil:**

```
Analyzing week7_campus_notify...
No issues found!
```

✅ **Status: Bersih — 0 warning, 0 error**

### 2.2 Menjalankan `dart format`

```bash
dart format . --set-exit-if-changed
```

**Hasil:** Semua file sudah mengikuti format Dart standar.

---

## Praktikum 3 — Code Review

Checklist review lengkap tersedia di: **[`docs/review-checklist.md`](docs/review-checklist.md)**

### Ringkasan Hasil Review

| Kategori | Total Item | ✅ Lulus | ⚠️ Perlu Perbaikan |
|----------|-----------|---------|-----------------|
| Arsitektur & Dependency Rule | 6 | 6 | 0 |
| State Management | 3 | 3 | 0 |
| Error Handling | 3 | 3 | 0 |
| Penamaan & Keterbacaan | 4 | 4 | 0 |
| Testing | 4 | 4 | 0 |
| Keamanan | 4 | 4 | 0 |
| **Total** | **24** | **24** | **0** |

### Temuan Minor (Non-blocking)

| File | Temuan | Rekomendasi |
|------|--------|-------------|
| `home_page.dart` baris 82 | String FCM hardcoded di widget | Extract ke `AppStrings.fcmPlaceholder` |
| `login_page.dart` baris 14–15 | Credential demo terisi default | Tambahkan komentar `// TODO(demo): hapus sebelum production` |

---

## Praktikum 4 — AI-Assisted Review

### Hasil Verifikasi Saran AI

| Saran AI | Diterima? | Alasan |
|----------|-----------|--------|
| Tambahkan `get_it` sebagai DI tambahan | ❌ Ditolak | Riverpod sudah cukup sebagai DI container — double DI anti-pattern |
| Buat abstract `UseCase<Type, Params>` generik | ❌ Ditolak | Over-engineering untuk skala project ini |
| Gunakan `Uri` untuk URL handling di `api_client.dart` | ✅ Diterima sebagian | Valid untuk URL dinamis; URL mock hardcoded tidak perlu |
| Tambahkan `@immutable` pada entity | ✅ Diterima | Entity memang seharusnya immutable |
| Pisahkan `push_service.dart` jadi interface + impl | 🔄 Ditunda | Relevan saat push service aktif; saat ini masih placeholder |

> **Pelajaran:** AI adalah reviewer awal yang baik — memberikan temuan dan usulan kode. Tetapi keputusan final tetap di tangan developer berdasarkan konteks dan kebutuhan nyata project.

---

## Struktur Folder Week 8

```text
08-week-8-mid-project-review/
├── README.md              ← dokumen ini
├── docs/
│   └── review-checklist.md  ← checklist review lengkap
└── screenshots/
```

---

## Refleksi

### 1. Apa yang paling sulit dari melakukan code review pada kode sendiri?

Melakukan _self code review_ jauh lebih sulit dari yang terlihat. Saat menulis kode sendiri,
otak sudah "tahu" apa yang dimaksud sehingga cenderung membaca apa yang _seharusnya_ tertulis,
bukan apa yang _benar-benar_ tertulis. Akibatnya, masalah seperti hardcoded string atau
credential demo yang perlu penanda TODO mudah terlewat. Checklist terstruktur membantu karena
memaksa pemeriksaan per kategori secara sistematis, bukan hanya membaca ulang kode secara linear.
Pelajaran utamanya: beri jeda waktu antara menulis kode dan mereviewnya — otak butuh "reset"
agar bisa melihat kode sebagai orang lain.

### 2. Mengapa Git Flow dan commit konvensional penting dalam tim?

Riwayat commit seperti `Tugas 7 - Week 7 Clean Architecture` mungkin cukup untuk kerja
sendiri, tetapi dalam tim ini menjadi hambatan nyata. Saat ada bug di produksi dan tim
perlu `git bisect` untuk menemukan commit penyebabnya, pesan seperti itu tidak memberi
petunjuk sama sekali. Sebaliknya, `fix(auth): refresh token sebelum retry 1x` langsung
menunjukkan scope, jenis perubahan, dan dampaknya. Branch `feature/*` yang pendek (\< 3 hari)
juga mencegah _merge hell_ — situasi di mana dua developer bekerja terlalu lama di branch
terpisah hingga divergensinya sangat besar dan menyulitkan merge. Disiplin ini bukan soal
formalitas, melainkan kontrak komunikasi yang menjaga produktivitas tim dalam jangka panjang.

### 3. Bagaimana cara memverifikasi saran AI sebelum diterapkan?

Pengalaman dari praktikum ini menunjukkan bahwa AI memberikan saran yang valid secara
umum, tetapi tidak selalu tepat untuk konteks spesifik project. Contoh konkret:
AI menyarankan menambahkan `get_it` sebagai service locator — saran yang umum diikuti
di banyak project Flutter. Namun, project ini sudah menggunakan Riverpod sebagai DI
container yang komprehensif. Menambahkan `get_it` berarti memiliki dua sistem DI yang
bisa membingungkan dan menimbulkan konflik. Proses verifikasi yang dilakukan:

1. **Pahami dulu** — baca dan mengerti mengapa AI merekomendasikan sesuatu.
2. **Tanya "untuk konteks ini?"** — apakah saran ini relevan dengan skala dan arsitektur
   project yang ada?
3. **Cek dampak samping** — apakah penerapannya menambah kompleksitas tanpa manfaat
   setimpal?
4. **Dokumentasikan keputusan** — catat di checklist apakah diterima, ditolak, atau
   ditunda beserta alasannya.

Nilai akademis bukan pada banyaknya saran AI yang ditempel, melainkan pada kualitas
penilaian dan reasoning di balik setiap keputusan.

### 4. Apa hubungan antara Clean Architecture (Minggu 7) dan kemudahan code review (Minggu 8)?

Setelah menjalankan checklist review pada `week7_campus_notify`, satu hal menjadi jelas:
kode yang berstruktur baik jauh lebih mudah direview. Dependency rule yang ketat
(presentation → domain ← data) membuat scope review per file sangat terbatas — seorang
reviewer yang memeriksa `login_usecase.dart` tahu bahwa file itu hanya berisi logika
bisnis murni, tidak ada urusan dengan Dio, SQLite, atau Firebase. Ini mengurangi cognitive
load reviewer secara signifikan. Sebaliknya, kode tanpa arsitektur yang jelas memaksa
reviewer membaca seluruh file untuk memahami satu fungsi. Clean Architecture bukan hanya
tentang _maintainability_ jangka panjang — manfaatnya sudah terasa langsung saat proses
review pertama kali dilakukan.

### 5. Apa rencana perbaikan untuk project ke depan (Minggu 9 dan seterusnya)?

Berdasarkan audit Minggu 8, ada tiga area yang akan diperbaiki secara konsisten ke depan:

1. **Git Flow** — mulai dari Minggu 9, semua pekerjaan dilakukan di branch `feature/*`
   yang dibuat dari `develop`, bukan langsung ke `main`. Setiap fitur kecil = satu branch
   = satu PR.
2. **Commit message konvensional** — gunakan format `tipe(scope): deskripsi` untuk
   setiap commit. Pasang `git commit-msg` hook jika perlu untuk memvalidasi format.
3. **PR kecil** — maksimal 300 baris per PR, maksimal 3 hari kerja per branch. Jika
   fitur terlalu besar, pecah menjadi beberapa PR yang saling berhubungan via issue.

---

## Screenshot

_Screenshots dari hasil `flutter analyze` dan tampilan aplikasi tersedia di folder
`07-week-7-clean-architecture/screenshots/`._

---

## Cara Menjalankan Project yang Direview

```bash
cd 07-week-7-clean-architecture/week7_campus_notify
flutter pub get
flutter analyze        # harus: No issues found!
flutter test           # harus: All tests passed!
flutter run
```

**Login demo:**

```
Email    : mahasiswa@polinema.ac.id
Password : password
```

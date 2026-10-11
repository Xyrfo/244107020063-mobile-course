# Week 5: Local Storage & Offline First

Aplikasi Flutter Offline Notes dengan SharedPreferences untuk preferensi dan SQLite untuk data catatan terstruktur.

## Fitur

- CRUD catatan yang tetap berjalan tanpa internet.
- Penyimpanan catatan persisten menggunakan SQLite melalui `NoteRepository`.
- Toggle tema gelap/terang menggunakan SharedPreferences.
- Penyimpanan waktu terakhir dibuka dan mode offline paksa.
- Badge jumlah catatan `dirty` yang belum tersinkron.
- Sinkronisasi terkontrol dengan aturan `last-write-wins` berdasarkan `updated_at`.
- Cache-first helper untuk data posts dari API Minggu 4.
- Detail catatan melalui GoRouter.
- Test model dan provider tanpa database SQLite sungguhan.

## Struktur

```text
lib/
├── data/
│   ├── api_client.dart
│   ├── local/
│   │   ├── db.dart
│   │   ├── note.dart
│   │   └── post.dart
│   ├── prefs.dart
│   ├── providers.dart
│   ├── sync.dart
│   └── repositories/note_repository.dart
├── pages/
│   ├── note_detail_page.dart
│   ├── note_editor_page.dart
│   ├── notes_page.dart
│   └── settings_page.dart
├── widgets/note_tile.dart
└── main.dart
```

## Pemilihan storage

| Kebutuhan | SharedPreferences | Hive | SQLite/sqflite | Drift |
|---|---|---|---|---|
| Preferensi kecil | Sangat sesuai | Bisa | Berlebihan | Berlebihan |
| Query/filter/relasi | Tidak sesuai | Terbatas | Sangat baik | Sangat baik |
| Type-safety | Primitif | Model manual | Map/manual | Tinggi |
| Reaktivitas | Tidak | Terbatas | Manual | Stream bawaan |
| Boilerplate | Rendah | Rendah-sedang | Sedang | Tinggi awal |
| Testing | Mudah | Mudah | Perlu injection | Baik setelah setup |

Keputusan final: SharedPreferences dipakai hanya untuk `dark_mode`, `last_opened_at`, dan `force_offline`. SQLite dipakai untuk catatan karena mendukung query, update parsial, sorting, dirty flag, dan skala ribuan data. Daftar catatan tidak disimpan sebagai JSON besar di SharedPreferences karena akan menyulitkan query dan sinkronisasi.

## Offline-first

```text
UI -> Riverpod -> NoteRepository -> SQLite
                       |
                       +-> remote sync ketika online
```

Catatan baru/ubah diberi `dirty = 1`. Tombol Sync mensimulasikan upload berurutan. Setelah proses dianggap berhasil, semua dirty note ditandai `dirty = 0`. Jika mode offline paksa aktif, proses sync gagal dengan aman dan data lokal tetap tersedia.

Untuk konflik dua arah, aturan yang dipakai adalah **last-write-wins berdasarkan `updated_at`**. Server/klien dengan waktu update paling baru menjadi sumber final.

## Menjalankan

```powershell
cd "C:\Teknik Informatika\Semester 5\Pemrograman Mobile\244107020063-mobile-course\05-week-5-local-storage-offline-first\week5_offline_notes"
flutter pub get
flutter analyze
flutter test
flutter run
```

Jika folder platform belum ada, jalankan sekali:

```powershell
flutter create .
```

Setelah menambah plugin native seperti `sqflite` atau `shared_preferences`, lakukan full stop dan `flutter run`, bukan hanya hot reload.

## Demo offline

1. Buka Settings dan aktifkan `Paksa mode offline`.
2. Tambahkan atau edit catatan.
3. Pastikan catatan tetap tampil dan badge `belum sync` bertambah.
4. Tekan Sync. Proses ditolak karena offline, data tidak hilang.
5. Matikan `Paksa mode offline` dan tekan Sync lagi.
6. Badge berubah menjadi 0 setelah sinkronisasi berhasil.

Simpan screenshot sebelum dan sesudah sync pada folder `screenshots/`.

## Verifikasi

- UI tidak mengakses SQLite/SharedPreferences langsung.
- Catatan dapat dibaca, ditambah, diedit, dan dihapus secara offline.
- Dirty flag terlihat dan kembali 0 setelah sync sukses.
- Test tidak memakai database sungguhan.
- Prompt dan keputusan AI terdokumentasi di `docs/ai-verification.md`.

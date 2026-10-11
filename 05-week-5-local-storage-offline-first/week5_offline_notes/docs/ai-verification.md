# AI Verification Log

## Prompt

```text
Aplikasi Flutter Offline Notes: CRUD catatan + preferensi tema.
Bandingkan SharedPreferences, Hive, sqflite, dan Drift untuk kebutuhan
preferensi kecil dan 1000+ catatan. Jelaskan query, relasi, reaktivitas,
type-safety, boilerplate, testing, dirty flag, dan rekomendasi final.
```

## Keputusan teknis

- SharedPreferences hanya untuk nilai key-value kecil.
- SQLite/sqflite untuk notes karena query dan dirty flag lebih tepat.
- Hive tidak dipilih untuk codelab ini karena query relasional lebih terbatas.
- Drift menjadi alternatif project besar jika membutuhkan generated type-safe query dan stream reaktif.

## Verifikasi hasil AI

- Daftar catatan tidak ditempatkan di SharedPreferences.
- Skema notes memiliki `updated_at` dan `dirty`.
- Sinkronisasi hanya menandai data bersih setelah proses sukses.
- Repository menerima dependency `openDb` sehingga provider test tidak membuka database asli.
- Aturan konflik didokumentasikan: last-write-wins berdasarkan `updated_at`.

## Perintah verifikasi

```bash
flutter analyze
flutter test
```

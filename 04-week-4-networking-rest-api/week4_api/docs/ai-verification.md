# AI Verification Log

## Prompt yang digunakan

```text
Buatkan repository layer Flutter untuk endpoint GET /posts dari JSONPlaceholder
menggunakan Dio + flutter_riverpod. Terapkan model fromJson aman null,
timeout, friendly error, AsyncNotifier, pagination, infinite scroll, detail
post dengan GoRouter, serta test provider menggunakan fake repository tanpa HTTP.
Pisahkan UI dari repository dan jelaskan keputusan arsitekturnya.
```

## Perbaikan dan verifikasi

- Parsing numeric field menggunakan `num?` lalu dikonversi ke integer.
- Error Dio dipetakan ke pesan pengguna, bukan menampilkan exception mentah.
- `baseUrl` dan timeout disimpan hanya di `api_client.dart`.
- Pagination menggunakan guard `isLoadingMore` dan `hasMore`.
- Request provider pada test dioverride dengan `FakePostRepository`, sehingga tidak ada HTTP sungguhan.
- Ditambahkan test untuk field JSON yang hilang sebagai edge case.

## Perintah verifikasi

```bash
flutter analyze
flutter test
```

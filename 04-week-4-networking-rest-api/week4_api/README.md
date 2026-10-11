# Week 4: Networking & REST API

Aplikasi Flutter untuk mengambil data posts dari JSONPlaceholder menggunakan Dio, Riverpod, repository pattern, pagination, dan GoRouter.

## Fitur

- REST API `GET /posts` dari JSONPlaceholder.
- Model `Post` dengan parsing JSON defensif terhadap field null/hilang.
- Dio terpusat dengan base URL, timeout 10 detik, dan interceptor logging.
- Repository sebagai satu-satunya lapisan yang memanggil API.
- State loading, error, empty, success, retry, dan pull-to-refresh.
- Infinite scroll 10 item per halaman dengan guard request ganda.
- Detail post melalui route `/post/:id`.
- Test model, pemetaan error, provider sukses, dan provider error tanpa internet.

## Arsitektur

```text
PagedPostPage/PostDetailPage
        |
        v
Riverpod Provider/Notifier
        |
        v
PostRepository
        |
        v
Dio -> JSONPlaceholder REST API
```

UI tidak memanggil Dio secara langsung. Error teknis dari Dio dipetakan oleh `network_errors.dart` menjadi pesan yang dapat dipahami pengguna.

## Struktur

```text
lib/
├── data/
│   ├── api_client.dart
│   ├── models/post.dart
│   ├── network_errors.dart
│   ├── paged_posts.dart
│   ├── providers.dart
│   └── repositories/post_repository.dart
├── pages/
│   ├── paged_post_page.dart
│   ├── post_detail_page.dart
│   └── post_list_page.dart
├── widgets/post_tile.dart
└── main.dart
test/post_test.dart
```

## Menjalankan

Pastikan Flutter SDK sudah terpasang dan tersedia di PATH:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Jika folder ini belum memiliki file platform hasil `flutter create`, jalankan sekali:

```bash
flutter create .
```

Perintah tersebut mempertahankan folder `lib/`, `test/`, dan konfigurasi project yang sudah dibuat.

## Skenario verifikasi manual

1. Jalankan aplikasi dengan internet normal. Halaman menampilkan posts per 10 item.
2. Scroll mendekati bagian bawah. Halaman berikutnya dimuat tanpa menghapus data lama.
3. Tekan salah satu post. Detail dibuka melalui GoRouter.
4. Matikan internet lalu refresh atau jalankan ulang aplikasi. Error menampilkan pesan ramah dan tombol coba lagi.
5. Ubah sementara `baseUrl` pada `api_client.dart` ke URL yang salah untuk menguji connection error.
6. Kembalikan `baseUrl` setelah pengujian.

## Verifikasi AI

- UI tidak memanggil Dio langsung: terpenuhi.
- Parsing model aman terhadap field hilang: terpenuhi.
- Timeout, connection error, 404, 401/403, dan server error dipetakan: terpenuhi.
- Base URL dan timeout terpusat: terpenuhi.
- Test menggunakan fake repository: terpenuhi.
- Edge case field JSON hilang diuji di `test/post_test.dart`.

## Catatan teknis

Data halaman lama dipertahankan ketika request halaman berikutnya gagal. Guard `isLoadingMore` mencegah listener scroll membuat request duplikat. Detail post memakai data list yang sudah tersedia; jika post tidak ada di cache, repository mengambilnya melalui endpoint `/posts/:id`.

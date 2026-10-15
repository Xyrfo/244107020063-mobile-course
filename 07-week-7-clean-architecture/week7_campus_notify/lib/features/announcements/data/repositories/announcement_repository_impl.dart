import '../../../../core/failures.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../models/announcement_model.dart';

/// Implementasi repository pengumuman.
/// Saat ini memakai data mock; ganti sumbernya dengan Dio/API kapan saja
/// tanpa mengubah domain atau presentation.
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl();

  static const _mockPayload = <Map<String, dynamic>>[
    {
      'id': '1',
      'title': 'Jadwal kuliah Minggu 7',
      'body': 'Praktikum clean architecture dimulai minggu ini.',
    },
    {
      'id': '2',
      'title': 'Pemeliharaan sistem akademik',
      'body': 'Layanan akademik akan dipelihara malam ini.',
    },
  ];

  @override
  Future<({List<Announcement> announcements, Failure? failure})>
      fetchAnnouncements() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      final announcements = _mockPayload
          .map((json) => AnnouncementModel.fromJson(json).toEntity())
          .toList();
      return (announcements: announcements, failure: null);
    } catch (e) {
      return (
        announcements: const <Announcement>[],
        failure: AnnouncementFailure('Gagal memuat pengumuman: $e'),
      );
    }
  }

  @override
  Future<({Announcement? announcement, Failure? failure})> fetchAnnouncement(
    String id,
  ) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final match = _mockPayload.firstWhere(
        (json) => json['id'] == id,
        orElse: () => const <String, dynamic>{},
      );
      if (match.isEmpty) {
        return (
          announcement: null,
          failure: const AnnouncementFailure('Pengumuman tidak ditemukan (404).'),
        );
      }
      return (
        announcement: AnnouncementModel.fromJson(match).toEntity(),
        failure: null,
      );
    } catch (e) {
      return (
        announcement: null,
        failure: AnnouncementFailure('Gagal memuat detail: $e'),
      );
    }
  }
}

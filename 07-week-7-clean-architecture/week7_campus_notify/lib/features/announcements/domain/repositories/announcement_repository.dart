import '../../../../core/failures.dart';
import '../entities/announcement.dart';

/// Kontrak data pengumuman yang dibutuhkan domain.
abstract class AnnouncementRepository {
  Future<({List<Announcement> announcements, Failure? failure})>
      fetchAnnouncements();

  Future<({Announcement? announcement, Failure? failure})> fetchAnnouncement(
    String id,
  );
}

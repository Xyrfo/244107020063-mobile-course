import 'package:flutter_test/flutter_test.dart';

import 'package:week7_campus_notify/core/failures.dart';
import 'package:week7_campus_notify/features/announcements/domain/entities/announcement.dart';
import 'package:week7_campus_notify/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:week7_campus_notify/features/announcements/domain/usecases/get_announcements.dart';

class FakeAnnouncementRepository implements AnnouncementRepository {
  FakeAnnouncementRepository({this.items = const [], this.fail = false});

  final List<Announcement> items;
  final bool fail;

  @override
  Future<({List<Announcement> announcements, Failure? failure})>
      fetchAnnouncements() async {
    if (fail) {
      return (
        announcements: const <Announcement>[],
        failure: const AnnouncementFailure('server offline'),
      );
    }
    return (announcements: items, failure: null);
  }

  @override
  Future<({Announcement? announcement, Failure? failure})> fetchAnnouncement(
    String id,
  ) async {
    return (announcement: null, failure: null);
  }
}

void main() {
  test('GetAnnouncements meneruskan daftar dari repository', () async {
    final repo = FakeAnnouncementRepository(items: [
      const Announcement(id: '1', title: 'A', body: 'isi'),
    ]);
    final result = await GetAnnouncements(repo).call();
    expect(result.failure, isNull);
    expect(result.announcements.length, 1);
    expect(result.announcements.first.title, 'A');
  });

  test('GetAnnouncements meneruskan failure tanpa melempar', () async {
    final repo = FakeAnnouncementRepository(fail: true);
    final result = await GetAnnouncements(repo).call();
    expect(result.failure, isA<AnnouncementFailure>());
    expect(result.announcements, isEmpty);
  });
}

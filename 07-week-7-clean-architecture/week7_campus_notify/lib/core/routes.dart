abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const announcement = '/pengumuman';

  static String announcementDetail(String id) => '$announcement/$id';
}

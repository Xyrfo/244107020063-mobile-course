import 'package:flutter/foundation.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const announcement = '/pengumuman';

  static String announcementDetail(String id) => '$announcement/$id';
}

String routeFromMessage(Map<String, dynamic> data) {
  final raw = data['route']?.toString().trim() ?? '';
  if (raw.isEmpty) return AppRoutes.home;
  return raw.startsWith('/') ? raw : '/$raw';
}

class AuthRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final authRefreshNotifier = AuthRefreshNotifier();

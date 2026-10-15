import 'package:flutter/foundation.dart';

/// Jembatan agar GoRouter me-refresh saat status auth berubah.
/// Berada di infrastructure karena bergantung pada Flutter (ChangeNotifier).
class AuthRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final authRefreshNotifier = AuthRefreshNotifier();

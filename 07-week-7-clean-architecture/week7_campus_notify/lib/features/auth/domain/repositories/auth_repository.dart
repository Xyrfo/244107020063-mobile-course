import '../../../../core/failures.dart';
import '../entities/auth_session.dart';

/// Kontrak autentikasi yang dibutuhkan domain.
/// Implementasi konkret (mock/Firebase) berada di layer data.
abstract class AuthRepository {
  Future<({AuthSession? session, Failure? failure})> login({
    required String email,
    required String password,
  });

  Future<({String? access, Failure? failure})> refresh(String refreshToken);

  Future<String?> readAccessToken();

  Future<void> saveSession(AuthSession session);

  Future<void> clearSession();
}

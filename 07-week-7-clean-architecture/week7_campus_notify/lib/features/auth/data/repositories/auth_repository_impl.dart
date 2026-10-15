import '../../../../core/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/token_store.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._store);

  final TokenStore _store;

  @override
  Future<({AuthSession? session, Failure? failure})> login({
    required String email,
    required String password,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!email.contains('@') || password.length < 6) {
        return (
          session: null,
          failure: const AuthFailure('Email atau kata sandi tidak valid.'),
        );
      }
      // GANTI titik ini dengan FirebaseAuth.instance.signInWithEmailAndPassword
      // atau GoogleSignIn saat backend Firebase sudah siap.
      return (
        session: AuthSession(
          access: 'mock-access-for-$email',
          refresh: 'mock-refresh-for-$email',
        ),
        failure: null,
      );
    } catch (e) {
      return (session: null, failure: AuthFailure('Login gagal: $e'));
    }
  }

  @override
  Future<({String? access, Failure? failure})> refresh(String refreshToken) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (refreshToken.isEmpty) {
        return (
          access: null,
          failure: const AuthFailure('Refresh token hilang.'),
        );
      }
      return (
        access: 'mock-access-renewed-${DateTime.now().millisecondsSinceEpoch}',
        failure: null,
      );
    } catch (e) {
      return (access: null, failure: AuthFailure('Refresh gagal: $e'));
    }
  }

  @override
  Future<String?> readAccessToken() => _store.readAccess();

  @override
  Future<void> saveSession(AuthSession session) =>
      _store.save(access: session.access, refresh: session.refresh);

  @override
  Future<void> clearSession() => _store.clear();
}

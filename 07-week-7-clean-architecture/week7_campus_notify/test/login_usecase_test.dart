import 'package:flutter_test/flutter_test.dart';

import 'package:week7_campus_notify/core/failures.dart';
import 'package:week7_campus_notify/features/auth/domain/entities/auth_session.dart';
import 'package:week7_campus_notify/features/auth/domain/repositories/auth_repository.dart';
import 'package:week7_campus_notify/features/auth/domain/usecases/login.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.fail = false, this.token});

  final bool fail;
  String? token;
  AuthSession? saved;

  @override
  Future<({AuthSession? session, Failure? failure})> login({
    required String email,
    required String password,
  }) async {
    if (fail) {
      return (session: null, failure: const AuthFailure('kredensial salah'));
    }
    return (
      session: const AuthSession(access: 'access', refresh: 'refresh'),
      failure: null,
    );
  }

  @override
  Future<({String? access, Failure? failure})> refresh(String refreshToken) async {
    return (access: 'renewed', failure: null);
  }

  @override
  Future<String?> readAccessToken() async => token;

  @override
  Future<void> saveSession(AuthSession session) async => saved = session;

  @override
  Future<void> clearSession() async => token = null;
}

void main() {
  test('Login meneruskan session saat berhasil', () async {
    final repo = FakeAuthRepository();
    final result = await Login(repo).call(
      email: 'mahasiswa@polinema.ac.id',
      password: 'password',
    );
    expect(result.failure, isNull);
    expect(result.session, isNotNull);
    expect(result.session!.access, 'access');
  });

  test('Login meneruskan failure tanpa melempar', () async {
    final repo = FakeAuthRepository(fail: true);
    final result = await Login(repo).call(email: 'x', password: 'y');
    expect(result.failure, isA<AuthFailure>());
    expect(result.session, isNull);
  });
}

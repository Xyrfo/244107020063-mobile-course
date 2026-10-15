import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/auth_refresh_notifier.dart';
import '../../data/datasources/token_store.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/is_logged_in.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';

/// Satu-satunya tempat wiring dependency untuk fitur auth.

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(tokenStoreProvider)),
);

final loginUseCaseProvider = Provider<Login>(
  (ref) => Login(ref.watch(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<Logout>(
  (ref) => Logout(ref.watch(authRepositoryProvider)),
);

final isLoggedInUseCaseProvider = Provider<IsLoggedIn>(
  (ref) => IsLoggedIn(ref.watch(authRepositoryProvider)),
);

final authStateProvider = AsyncNotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
  retry: (retryCount, error) => null,
);

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() {
    return ref.watch(isLoggedInUseCaseProvider).call();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(loginUseCaseProvider).call(
            email: email,
            password: password,
          );
      if (result.failure != null || result.session == null) {
        throw Exception(result.failure?.message ?? 'Login gagal.');
      }
      await ref.read(authRepositoryProvider).saveSession(result.session!);
      authRefreshNotifier.refresh();
      return true;
    });
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).call();
    state = const AsyncData(false);
    authRefreshNotifier.refresh();
  }
}

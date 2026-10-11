import 'package:dio/dio.dart';

import 'auth_repository.dart';
import 'token_store.dart';

Dio buildApiClient(TokenStore store, AuthRepository auth) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example-campus-api.test'));
  var refreshing = false;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await store.readAccess();
        if (access != null) options.headers['Authorization'] = 'Bearer $access';
        handler.next(options);
      },
      onError: (error, handler) async {
        final refreshToken = await store.readRefresh();
        final alreadyRetried = error.requestOptions.extra['authRetried'] == true;
        if (error.response?.statusCode != 401 || refreshToken == null || alreadyRetried || refreshing) {
          handler.next(error);
          return;
        }

        refreshing = true;
        try {
          final renewed = await auth.refresh(refreshToken);
          await store.save(access: renewed, refresh: refreshToken);
          final request = error.requestOptions;
          request.extra['authRetried'] = true;
          request.headers['Authorization'] = 'Bearer $renewed';
          handler.resolve(await dio.fetch(request));
        } catch (_) {
          await store.clear();
          handler.next(error);
        } finally {
          refreshing = false;
        }
      },
    ),
  );
  return dio;
}

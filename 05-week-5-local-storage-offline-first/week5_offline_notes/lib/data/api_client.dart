import 'package:dio/dio.dart';

import 'local/post.dart';

class PostsRemoteSource {
  PostsRemoteSource({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://jsonplaceholder.typicode.com',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ));

  final Dio _dio;

  Future<List<CachedPost>> fetchPosts() async {
    final response = await _dio.get<List<dynamic>>('/posts');
    return (response.data ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(CachedPost.fromJson)
        .toList();
  }
}

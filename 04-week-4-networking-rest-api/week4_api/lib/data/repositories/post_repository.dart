import 'package:dio/dio.dart';

import '../models/post.dart';

class PostRepository {
  PostRepository(this._dio);

  final Dio _dio;

  Future<List<Post>> fetchPostsPage({
    required int page,
    int limit = 10,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/posts',
      queryParameters: {'_page': page, '_limit': limit},
    );
    return _parsePosts(response.data);
  }

  Future<Post> fetchPost(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/posts/$id');
    final data = response.data;
    if (data == null) {
      throw StateError('Respons post kosong.');
    }
    return Post.fromJson(data);
  }

  List<Post> _parsePosts(List<dynamic>? data) {
    return (data ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(Post.fromJson)
        .toList();
  }
}

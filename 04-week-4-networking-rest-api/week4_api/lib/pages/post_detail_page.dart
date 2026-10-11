import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/post.dart';
import '../data/providers.dart';
import '../data/network_errors.dart';

class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cached = ref.watch(postListProvider).asData?.value;
    Post? cachedPost;
    if (cached != null) {
      for (final post in cached) {
        if (post.id == id) {
          cachedPost = post;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Post')),
      body: cachedPost != null
          ? _PostContent(post: cachedPost)
          : FutureBuilder<Post>(
              future: ref.read(postRepositoryProvider).fetchPost(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        friendlyErrorMessage(snapshot.error!),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return _PostContent(post: snapshot.data!);
              },
            ),
    );
  }
}

class _PostContent extends StatelessWidget {
  const _PostContent({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('POST #${post.id}', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 28),
          Chip(label: Text('User ID: ${post.userId}')),
        ],
      ),
    );
  }
}

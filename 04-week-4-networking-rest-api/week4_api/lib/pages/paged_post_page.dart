import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/network_errors.dart';
import '../data/paged_posts.dart';
import '../widgets/post_tile.dart';

class PagedPostPage extends ConsumerStatefulWidget {
  const PagedPostPage({super.key});

  @override
  ConsumerState<PagedPostPage> createState() => _PagedPostPageState();
}

class _PagedPostPageState extends ConsumerState<PagedPostPage> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 240) {
      ref.read(pagedPostsProvider.notifier).loadNextPage();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pagedPostsProvider);
    if (state.isInitialLoading && state.items.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.error != null && state.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Posts Paged')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(friendlyErrorMessage(state.error!), textAlign: TextAlign.center),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () => ref.read(pagedPostsProvider.notifier).loadFirstPage(),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Posts Paged')),
      body: ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: state.items.length + 1,
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            if (state.error != null) {
              return TextButton(
                onPressed: () => ref.read(pagedPostsProvider.notifier).loadNextPage(),
                child: Text('Gagal memuat. ${friendlyErrorMessage(state.error!)}'),
              );
            }
            if (!state.hasMore) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: Text('Semua data telah termuat.')),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final post = state.items[index];
          return PostTile(
            post: post,
            onTap: () => context.push('/post/${post.id}'),
          );
        },
      ),
    );
  }
}

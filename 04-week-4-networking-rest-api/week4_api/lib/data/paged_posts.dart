import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/post.dart';
import 'providers.dart';

class PagedPostsState {
  const PagedPostsState({
    this.items = const [],
    this.page = 0,
    this.isLoadingMore = false,
    this.isInitialLoading = true,
    this.hasMore = true,
    this.error,
  });

  final List<Post> items;
  final int page;
  final bool isLoadingMore;
  final bool isInitialLoading;
  final bool hasMore;
  final Object? error;
}

class PagedPostsNotifier extends Notifier<PagedPostsState> {
  @override
  PagedPostsState build() {
    Future.microtask(loadFirstPage);
    return const PagedPostsState();
  }

  Future<void> loadFirstPage() async {
    state = const PagedPostsState();
    try {
      final items = await ref.read(postRepositoryProvider).fetchPostsPage(
            page: 1,
            limit: 10,
          );
      state = PagedPostsState(
        items: items,
        page: 1,
        isInitialLoading: false,
        hasMore: items.length == 10,
      );
    } catch (error) {
      state = PagedPostsState(isInitialLoading: false, error: error);
    }
  }

  Future<void> loadNextPage() async {
    if (state.isInitialLoading || state.isLoadingMore || !state.hasMore) return;

    final currentItems = state.items;
    final currentPage = state.page;
    state = PagedPostsState(
      items: currentItems,
      page: currentPage,
      isLoadingMore: true,
      isInitialLoading: false,
      hasMore: state.hasMore,
    );

    try {
      final items = await ref.read(postRepositoryProvider).fetchPostsPage(
            page: currentPage + 1,
            limit: 10,
          );
      state = PagedPostsState(
        items: [...currentItems, ...items],
        page: currentPage + 1,
        isInitialLoading: false,
        hasMore: items.length == 10,
      );
    } catch (error) {
      state = PagedPostsState(
        items: currentItems,
        page: currentPage,
        isInitialLoading: false,
        hasMore: state.hasMore,
        error: error,
      );
    }
  }
}

final pagedPostsProvider =
    NotifierProvider<PagedPostsNotifier, PagedPostsState>(
  PagedPostsNotifier.new,
);

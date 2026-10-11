import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/paged_post_page.dart';
import 'pages/post_detail_page.dart';

void main() => runApp(const ProviderScope(child: Week4App()));

final _router = GoRouter(
  initialLocation: '/posts',
  routes: [
    GoRoute(path: '/posts', builder: (context, state) => const PagedPostPage()),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) => PostDetailPage(
        id: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);

class Week4App extends StatelessWidget {
  const Week4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Week 4 - REST API',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF285943)),
        useMaterial3: true,
      ),
    );
  }
}

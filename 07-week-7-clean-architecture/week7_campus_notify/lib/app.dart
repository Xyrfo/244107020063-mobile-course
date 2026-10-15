import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/routes.dart';
import 'features/announcements/presentation/pages/announcement_detail_page.dart';
import 'features/announcements/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'infrastructure/auth_refresh_notifier.dart';

final _router = GoRouter(
  initialLocation: AppRoutes.home,
  refreshListenable: authRefreshNotifier,
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context, listen: false);
    final loggedIn = container.read(authStateProvider).asData?.value ?? false;
    final goingLogin = state.matchedLocation == AppRoutes.login;
    if (!loggedIn && !goingLogin) return AppRoutes.login;
    if (loggedIn && goingLogin) return AppRoutes.home;
    return null;
  },
  routes: [
    GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
    GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
    GoRoute(
      path: '${AppRoutes.announcement}/:id',
      builder: (_, state) =>
          AnnouncementDetailPage(id: state.pathParameters['id'] ?? ''),
    ),
  ],
);

class CampusNotifyApp extends ConsumerWidget {
  const CampusNotifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (previous, next) {
      authRefreshNotifier.refresh();
    });
    return MaterialApp.router(
      title: 'Week 7 - Clean Architecture',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF165D4A)),
        useMaterial3: true,
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'data/providers.dart';
import 'pages/note_detail_page.dart';
import 'pages/notes_page.dart';
import 'pages/settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // sqflite memakai factory native di mobile dan FFI di desktop.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const ProviderScope(child: Week5App()));
}

final _router = GoRouter(
  initialLocation: '/notes',
  routes: [
    GoRoute(path: '/notes', builder: (context, state) => const NotesPage()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
    GoRoute(path: '/note/:id', builder: (context, state) => NoteDetailPage(id: int.parse(state.pathParameters['id']!))),
  ],
);

class Week5App extends ConsumerWidget {
  const Week5App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(darkModeProvider).asData?.value ?? false;
    return MaterialApp.router(
      title: 'Week 5 - Offline Notes',
      routerConfig: _router,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315C72)), useMaterial3: true),
      darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8DC7D9), brightness: Brightness.dark), useMaterial3: true),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

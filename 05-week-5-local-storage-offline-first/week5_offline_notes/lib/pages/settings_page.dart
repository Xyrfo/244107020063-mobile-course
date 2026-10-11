import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider).asData?.value ?? false;
    final offline = ref.watch(forceOfflineProvider).asData?.value ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Mode gelap'),
            subtitle: const Text('Disimpan di SharedPreferences'),
            value: darkMode,
            onChanged: (_) => ref.read(darkModeProvider.notifier).toggle(),
          ),
          SwitchListTile(
            title: const Text('Paksa mode offline'),
            subtitle: const Text('Simulasi offline deterministik untuk demo'),
            value: offline,
            onChanged: (_) => ref.read(forceOfflineProvider.notifier).toggle(),
          ),
          const ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Penyimpanan'),
            subtitle: Text('Preferensi: SharedPreferences • Catatan: SQLite'),
          ),
        ],
      ),
    );
  }
}

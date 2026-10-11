import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Notify'), actions: [IconButton(onPressed: () => ref.read(authStateProvider.notifier).logout(), icon: const Icon(Icons.logout), tooltip: 'Keluar')]),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: const Text('Mahasiswa Polinema'), subtitle: const Text('Sesi login aman dengan secure storage'))),
        const SizedBox(height: 18),
        Text('Pengumuman terbaru', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        _AnnouncementCard(id: '1', title: 'Jadwal kuliah Minggu 6', body: 'Praktikum authentication dan FCM dimulai minggu ini.'),
        _AnnouncementCard(id: '2', title: 'Pemeliharaan sistem akademik', body: 'Layanan akademik akan dipelihara malam ini.'),
        const SizedBox(height: 18),
        Card(color: Theme.of(context).colorScheme.secondaryContainer, child: const Padding(padding: EdgeInsets.all(16), child: Text('FCM siap dikonfigurasi. Tambahkan google-services.json untuk mengaktifkan notifikasi Firebase nyata.'))),
      ]),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.id, required this.title, required this.body});

  final String id;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(onTap: () => context.push('/pengumuman/$id'), leading: const Icon(Icons.notifications_active_outlined), title: Text(title), subtitle: Text(body, maxLines: 2, overflow: TextOverflow.ellipsis), trailing: const Icon(Icons.chevron_right)));
  }
}

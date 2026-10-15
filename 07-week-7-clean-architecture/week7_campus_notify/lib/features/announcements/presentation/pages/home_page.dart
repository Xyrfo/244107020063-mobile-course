import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/announcement_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Notify'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Mahasiswa Polinema'),
              subtitle: Text('Sesi login aman dengan secure storage'),
            ),
          ),
          const SizedBox(height: 18),
          Text('Pengumuman terbaru',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          announcementsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Gagal memuat: $error', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => ref.invalidate(announcementsProvider),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
            data: (announcements) {
              if (announcements.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('Belum ada pengumuman.')),
                );
              }
              return Column(
                children: [
                  for (final announcement in announcements)
                    _AnnouncementCard(
                      id: announcement.id,
                      title: announcement.title,
                      body: announcement.body,
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                  'FCM siap dikonfigurasi. Tambahkan google-services.json untuk mengaktifkan notifikasi Firebase nyata.'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.id,
    required this.title,
    required this.body,
  });

  final String id;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => context.push('/pengumuman/$id'),
        leading: const Icon(Icons.notifications_active_outlined),
        title: Text(title),
        subtitle: Text(body, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

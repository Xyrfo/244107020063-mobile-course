import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/announcement_providers.dart';

class AnnouncementDetailPage extends ConsumerWidget {
  const AnnouncementDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(announcementDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text('Pengumuman #$id')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      ref.invalidate(announcementDetailProvider(id)),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
        data: (announcement) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pengumuman kampus',
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              Text(announcement.title,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              Text(announcement.body,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              const Chip(
                avatar: Icon(Icons.verified_outlined, size: 18),
                label: Text('Dibuka dari deep link notifikasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

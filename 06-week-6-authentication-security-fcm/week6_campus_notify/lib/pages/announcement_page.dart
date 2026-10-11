import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengumuman #$id')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Pengumuman kampus', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          Text(id == '1' ? 'Jadwal kuliah Minggu 6' : 'Pemeliharaan sistem akademik', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Text(id == '1' ? 'Praktikum authentication dan FCM dimulai minggu ini.' : 'Layanan akademik akan dipelihara malam ini.', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          const Chip(avatar: Icon(Icons.verified_outlined, size: 18), label: Text('Dibuka dari deep link notifikasi')),
        ]),
      ),
    );
  }
}

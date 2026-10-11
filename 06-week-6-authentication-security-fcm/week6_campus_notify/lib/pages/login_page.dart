import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController(text: 'mahasiswa@polinema.ac.id');
  final _password = TextEditingController(text: 'password');
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await ref.read(authStateProvider.notifier).login(_email.text.trim(), _password.text);
    if (mounted && ref.read(authStateProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${ref.read(authStateProvider).error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authStateProvider).isLoading;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Icon(Icons.campaign_rounded, size: 72, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text('Campus Notify', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Login untuk menerima pengumuman kampus secara aman.', textAlign: TextAlign.center),
              const SizedBox(height: 36),
              TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _password, obscureText: _obscure, decoration: InputDecoration(labelText: 'Kata sandi', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(), suffixIcon: IconButton(onPressed: () => setState(() => _obscure = !_obscure), icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off)))),
              const SizedBox(height: 24),
              FilledButton.icon(onPressed: loading ? null : _login, icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.login), label: Text(loading ? 'Memproses...' : 'Masuk')),
              const SizedBox(height: 14),
              const Text('Demo: email harus valid dan password minimal 6 karakter.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
            ]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';
import 'login_screen.dart';
import 'user_list_screen.dart';
import 'post_list_screen.dart';
import '../widgets/section_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = SecureStorageService();
  final _tokenController = TextEditingController();
  String? _token;
  bool _hasToken = false, _loading = true, _showToken = false;

  @override
  void initState() {
    super.initState();
    _refreshToken();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _refreshToken() async {
    final token = await _storage.getToken();
    if (!mounted) return;
    setState(() {
      _token = token;
      _hasToken = token != null;
      _loading = false;
    });
  }

  Future<void> _saveToken() async {
    final value = _tokenController.text.trim();
    if (value.isEmpty) {
      _message('Token tidak boleh kosong');
      return;
    }
    await _storage.saveToken(value);
    _tokenController.clear();
    await _refreshToken();
    if (mounted) _message('Token tersimpan secara aman');
  }

  void _message(String value) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(value)));
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.logout_rounded, size: 34),
        title: const Text('Keluar dari SecureHub?'),
        content: const Text('Token login akan dihapus dari secure storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _storage.deleteToken();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'SecureHub',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      actions: [
        IconButton(
          tooltip: 'Logout',
          onPressed: _logout,
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    ),
    body: RefreshIndicator(
      onRefresh: _refreshToken,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4D397E), Color(0xFF8D72C5)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KEAMANAN DATA & HTTP DASAR',
                  style: TextStyle(
                    color: Color(0xFFDCD2F3),
                    fontSize: 11,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Data aman,\nakses lebih nyaman.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Praktikum Pemrograman Mobile • Pertemuan 5',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  icon: Icons.lock_rounded,
                  title: 'Secure Storage',
                  subtitle: 'Penyimpanan token terenkripsi',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _tokenController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Token / nilai sensitif',
                    hintText: 'Masukkan token dummy',
                    prefixIcon: Icon(Icons.key_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _saveToken,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Simpan'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _hasToken
                            ? () async {
                                await _storage.deleteToken();
                                await _refreshToken();
                              }
                            : null,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: _hasToken
                        ? const Color(0xFFE8F5EC)
                        : const Color(0xFFF1EFF5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _hasToken
                            ? Icons.verified_user_rounded
                            : Icons.info_outline,
                        color: _hasToken
                            ? Colors.green.shade700
                            : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _loading
                              ? 'Memeriksa status...'
                              : _hasToken
                              ? 'Token tersimpan • ${_showToken ? _token : '••••••••••'}'
                              : 'Belum ada token tersimpan',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (_hasToken)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () =>
                              setState(() => _showToken = !_showToken),
                          icon: Icon(
                            _showToken
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nilai token tidak pernah ditampilkan di log aplikasi.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  icon: Icons.cloud_done_rounded,
                  title: 'REST API Explorer',
                  subtitle: 'GET request • JSONPlaceholder',
                ),
                const SizedBox(height: 16),
                _FeatureTile(
                  icon: Icons.people_alt_rounded,
                  color: const Color(0xFF4267B2),
                  title: 'Daftar Pengguna',
                  subtitle: 'GET /users • detail, pencarian, refresh',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserListScreen()),
                  ),
                ),
                const Divider(height: 20),
                _FeatureTile(
                  icon: Icons.article_rounded,
                  color: const Color(0xFF168A83),
                  title: 'Artikel & Posts',
                  subtitle: 'GET /posts • 100 data artikel',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PostListScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  icon: Icons.security_rounded,
                  title: 'Pusat Keamanan',
                  subtitle: 'Praktik baik selama pengembangan',
                ),
                const SizedBox(height: 12),
                const _SecurityLine(
                  'Token dan PIN disimpan melalui secure storage.',
                ),
                const _SecurityLine(
                  'Gunakan HTTPS untuk komunikasi dengan API.',
                ),
                const _SecurityLine(
                  'Jangan mencatat token, password, atau data pribadi.',
                ),
                const _SecurityLine(
                  'Tangani timeout, koneksi, HTTP, dan parsing error.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'SECUREHUB  •  MOBILE PROGRAMMING',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE7F8),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: const Color(0xFF6750A4)),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
  );
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final VoidCallback onTap;
  const _FeatureTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    onTap: onTap,
    leading: CircleAvatar(
      backgroundColor: color.withOpacity(.12),
      child: Icon(icon, color: color),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
  );
}

class _SecurityLine extends StatelessWidget {
  final String text;
  const _SecurityLine(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF27966F),
          size: 18,
        ),
        const SizedBox(width: 9),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    ),
  );
}

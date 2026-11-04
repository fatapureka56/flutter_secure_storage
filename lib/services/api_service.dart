import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration defaultTimeout = Duration(seconds: 10);
  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<User>> getUsers({Duration timeout = defaultTimeout}) async {
    try {
      _safeLog('GET /users');
      final response = await _client
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(timeout);
      _safeLog('HTTP status ${response.statusCode}');
      if (response.statusCode != 200)
        throw ApiException(
          'Gagal memuat pengguna (HTTP ${response.statusCode}).',
        );
      final decoded = jsonDecode(response.body);
      if (decoded is! List) throw const FormatException();
      return decoded
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw ApiException('Permintaan melewati batas waktu. Coba lagi.');
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw ApiException('Format data dari server tidak valid.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Terjadi kesalahan saat menghubungi server.');
    }
  }

  Future<User> getUserById(int id) async {
    try {
      _safeLog('GET /users/$id');
      final response = await _client
          .get(Uri.parse('$_baseUrl/users/$id'))
          .timeout(defaultTimeout);
      _safeLog('HTTP status ${response.statusCode}');
      if (response.statusCode != 200)
        throw ApiException('Detail pengguna tidak ditemukan.');
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } on TimeoutException {
      throw ApiException('Permintaan melewati batas waktu.');
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet.');
    } on FormatException {
      throw ApiException('Format data dari server tidak valid.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Terjadi kesalahan saat memuat detail.');
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      _safeLog('GET /posts');
      final response = await _client
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(defaultTimeout);
      _safeLog('HTTP status ${response.statusCode}');
      if (response.statusCode != 200)
        throw ApiException(
          'Gagal memuat artikel (HTTP ${response.statusCode}).',
        );
      final decoded = jsonDecode(response.body);
      if (decoded is! List) throw const FormatException();
      return decoded
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw ApiException('Permintaan melewati batas waktu.');
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet.');
    } on FormatException {
      throw ApiException('Format data dari server tidak valid.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Terjadi kesalahan saat memuat artikel.');
    }
  }

  Future<String> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (email.trim().isEmpty || password.isEmpty) {
      throw ApiException('Email dan password wajib diisi.');
    }
    // Simulasi sesuai instruksi modul; token ini bukan token server sungguhan.
    _safeLog('Simulasi login berhasil');
    return 'demo_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _safeLog(String message) {
    // ignore: avoid_print
    print(
      '[API] $message',
    ); // Tidak pernah mencatat password/token/data pribadi.
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

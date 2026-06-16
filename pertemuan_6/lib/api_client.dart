import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'main.dart' show Catatan;

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  static const String _baseUrl = 'https://besab-production.up.railway.app/api';
  static const String _apiKey =
      '8f38b5fbf0bc437285f2c62ed6e447eab56f78c8f95239a7';
  static const Duration _timeout = Duration(seconds: 10);

  Map<String, String> get _headers => const {
        'X-API-Key': _apiKey,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<List<Catatan>> getAll() async {
    final res = await _send(
      () => http.get(
        Uri.parse('$_baseUrl/catatan'),
        headers: _headers,
      ),
    );
    final body = _decodeBody(res);
    final data = body['data'] as List<dynamic>? ?? const [];

    return data
        .map((item) => Catatan.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<Catatan> getById(int id) async {
    final res = await _send(
      () => http.get(
        Uri.parse('$_baseUrl/catatan/$id'),
        headers: _headers,
      ),
    );
    final body = _decodeBody(res);
    return Catatan.fromJson(Map<String, dynamic>.from(body['data'] as Map));
  }

  Future<Catatan> insert(Catatan c) async {
    final res = await _send(
      () => http.post(
        Uri.parse('$_baseUrl/catatan'),
        headers: _headers,
        body: jsonEncode(c.toJson()),
      ),
    );
    final body = _decodeBody(res);
    return Catatan.fromJson(Map<String, dynamic>.from(body['data'] as Map));
  }

  Future<Catatan> update(Catatan c) async {
    assert(c.id != null, 'update() membutuhkan Catatan dengan id non-null');

    final payload = Map<String, dynamic>.from(c.toJson())..remove('dibuat_pada');
    final res = await _send(
      () => http.put(
        Uri.parse('$_baseUrl/catatan/${c.id}'),
        headers: _headers,
        body: jsonEncode(payload),
      ),
    );
    final body = _decodeBody(res);
    return Catatan.fromJson(Map<String, dynamic>.from(body['data'] as Map));
  }

  Future<void> delete(int id) async {
    await _send(
      () => http.delete(
        Uri.parse('$_baseUrl/catatan/$id'),
        headers: _headers,
      ),
    );
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      final res = await request().timeout(_timeout);
      if (res.statusCode >= 200 && res.statusCode < 300) return res;
      throw ApiException(res.statusCode, _extractMessage(res));
    } on SocketException {
      throw ApiException(0, 'Tidak ada koneksi internet.');
    } on TimeoutException {
      throw ApiException(0, 'Server tidak merespons (timeout).');
    }
  }

  Map<String, dynamic> _decodeBody(http.Response res) {
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw ApiException(res.statusCode, 'Format respons server tidak valid.');
  }

  String _extractMessage(http.Response res) {
    if (res.statusCode == 422) {
      return 'HTTP 422';
    }
    try {
      final body = _decodeBody(res);
      return body['message'] as String? ?? 'HTTP ${res.statusCode}';
    } catch (_) {
      return 'HTTP ${res.statusCode}';
    }
  }
}

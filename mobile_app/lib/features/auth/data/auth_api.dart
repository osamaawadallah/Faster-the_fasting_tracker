import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthAPI {
  static const _baseUrl =
      'http://localhost:8000'; // Change to deployed URL later
  final _storage = const FlutterSecureStorage();

  Future<String?> register(String email, String password) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim(), 'password': password.trim()}),
    );
    if (res.statusCode == 200) {
      final token = jsonDecode(res.body)['access_token'];
      await _storage.write(key: 'token', value: token);
      return token;
    }
    return null;
  }

  Future<String?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim(), 'password': password.trim()}),
    );

    if (res.statusCode == 200) {
      final token = jsonDecode(res.body)['access_token'];
      await _storage.write(key: 'token', value: token);
      return token;
    }
    return null;
  }

  Future<void> logout() async => await _storage.delete(key: 'token');
  Future<String?> getToken() async => await _storage.read(key: 'token');
}

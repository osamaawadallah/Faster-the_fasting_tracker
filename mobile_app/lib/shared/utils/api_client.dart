import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/auth/data/auth_storage.dart';

class ApiClient {
  static const _baseUrl = 'http://localhost:8000';

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return await http.get(Uri.parse('$_baseUrl$endpoint'), headers: headers);
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final headers = await _getHeaders();
    return await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    return await http.delete(Uri.parse('$_baseUrl$endpoint'), headers: headers);
  }

  // Token utilities for AuthAPI
  Future<void> saveToken(String token) => AuthStorage.saveToken(token);
  Future<String?> getToken() => AuthStorage.getToken();
  Future<void> clearToken() => AuthStorage.clearToken();
}

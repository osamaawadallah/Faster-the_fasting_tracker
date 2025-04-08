import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static const baseUrl = 'http://localhost:8000'; // or your backend service URL
  final storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<http.Response> get(String path) async {
    final token = await _getToken();
    return http.get(Uri.parse('$baseUrl$path'), headers: _headers(token));
  }

  Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
    final token = await _getToken();
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String path, {Map<String, dynamic>? body}) async {
    final token = await _getToken();
    return http.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
  }

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}

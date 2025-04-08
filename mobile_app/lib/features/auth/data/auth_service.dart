import 'dart:convert';
import 'package:mobile_app/shared/utils/api_client.dart';

class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await _client.post(
      '/auth/register',
      body: {'email': email.trim(), 'password': password.trim()},
      withAuth: false,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.post(
      '/auth/login',
      body: {'email': email.trim(), 'password': password.trim()},
      withAuth: false,
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(response) {
    final Map<String, dynamic> body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(body['detail'] ?? 'Auth failed');
    }
  }
}

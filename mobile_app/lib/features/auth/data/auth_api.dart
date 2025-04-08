import 'dart:convert';
import 'package:mobile_app/shared/utils/api_client.dart';

class AuthAPI {
  final ApiClient _client = ApiClient();

  Future<String?> register(String email, String password) async {
    final response = await _client.post(
      '/auth/register',
      body: {'email': email.trim(), 'password': password.trim()},
      withAuth: false,
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['access_token'];
      return token;
    }

    return null;
  }

  Future<String?> login(String email, String password) async {
    final response = await _client.post(
      '/auth/login',
      body: {'email': email.trim(), 'password': password.trim()},
      withAuth: false,
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['access_token'];
      return token;
    }

    return null;
  }

  Future<void> logout() async => await _client.clearToken();
  Future<String?> getToken() async => await _client.getToken();
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_api.dart';
import 'package:mobile_app/shared/utils/api_client.dart';

final authProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(AuthAPI(), ApiClient());
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI api;
  final ApiClient client;

  AuthController(this.api, this.client) : super(false);

  Future<bool> login(String email, String password) async {
    final token = await api.login(email, password);
    if (token != null) {
      await client.saveToken(token); // Use api_client for storage
      state = true;
    }
    return state;
  }

  Future<bool> register(String email, String password) async {
    final token = await api.register(email, password);
    if (token != null) {
      await client.saveToken(token);
      state = true;
    }
    return state;
  }

  Future<void> logout() async {
    await api.logout();
    await client.clearToken();
    state = false;
  }

  Future<void> checkAuth() async {
    final token = await client.getToken();
    state = token != null;
  }
}

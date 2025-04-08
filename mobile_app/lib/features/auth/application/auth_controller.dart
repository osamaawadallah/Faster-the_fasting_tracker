import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_api.dart';

final authProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(AuthAPI());
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI api;
  AuthController(this.api) : super(false);

  Future<bool> login(String email, String password) async {
    final token = await api.login(email, password);
    state = token != null;
    return state;
  }

  Future<bool> register(String email, String password) async {
    final token = await api.register(email, password);
    state = token != null;
    return state;
  }

  Future<void> logout() async {
    await api.logout();
    state = false;
  }

  Future<void> checkAuth() async {
    final token = await api.getToken();
    state = token != null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/presentation/register_screen.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: emailCtrl,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: passCtrl,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await auth.login(emailCtrl.text, passCtrl.text);
              if (success) context.go('/calendar');
            },
            child: Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterScreen()),
              );
            },
            child: const Text("Create Account"),
          ),
        ],
      ),
    );
  }
}

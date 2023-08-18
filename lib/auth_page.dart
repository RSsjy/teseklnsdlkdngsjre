import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Logout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final BuildContext currentContext = context; // Capture context
                _authService
                    .signIn(
                  _emailController.text,
                  _passwordController.text,
                )
                    .then((user) {
                  if (user != null) {
                    Navigator.pop(currentContext); // Use captured context
                  } else {
                    // Handle login error (e.g., show a dialog or toast)
                  }
                });
              },
              child: const Text('Login'),
            ),
            // const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     final BuildContext currentContext =
            //         context; // Capture context before the async operation
            //     _authService
            //         .signUp(
            //       _emailController.text,
            //       _passwordController.text,
            //     )
            //         .then((user) {
            //       if (user != null) {
            //         Navigator.pop(currentContext); // Use the captured context
            //       } else {
            //         // Handle signup error (e.g., show a dialog or toast)
            //       }
            //     });
            //   },
            //   child: const Text('Signup'),
            // ),
            // const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final BuildContext currentContext =
                    context; // Capture context before the async operation
                _authService.signOut().then((_) {
                  Navigator.pop(currentContext); // Use the captured context
                });
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

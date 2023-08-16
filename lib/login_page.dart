// import 'package:flutter/material.dart';

// import 'auth_service.dart';

// class LoginPage extends StatelessWidget {
//   final AuthService _authService = AuthService();

//   LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             // Example: Logging in with hardcoded credentials
//             await _authService.signIn("test@example.com", "password123");
//             // ignore: use_build_context_synchronously
//             Navigator.pushReplacementNamed(context, '/');
//           },
//           child: const Text("Login"),
//         ),
//       ),
//     );
//   }
// }

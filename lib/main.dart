// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'firebase_options.dart';
// import 'my_app.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'home_page.dart'; // Assuming you've created this as per the previous instructions

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginPage(authService: _authService);
          } else {
            return const HomePage();
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  final AuthService authService;

  LoginPage({super.key, required this.authService});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                await authService.signIn(
                  emailController.text,
                  passwordController.text,
                );
              },
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () async {
                await authService.signUp(
                  emailController.text,
                  passwordController.text,
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   final AuthService authService;

//   HomePage({required this.authService});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Page'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await authService.signOut();
//             },
//           ),
//         ],
//       ),
//       body: Center(child: Text('Welcome to the Home Page!')),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'constants.dart';
import 'auth_service.dart'; // Import the AuthService class

class HomePage extends StatelessWidget {
  final AuthService authService; // Declare an instance of AuthService

  // Updated constructor to accept an instance of AuthService
  const HomePage({Key? key, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inv App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final currentContext = context; // Capture the current context
              authService.signOut().then((_) {
                Navigator.of(currentContext).pushReplacementNamed('/login');
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/collection',
                    arguments: itemsCollection);
              },
              child: const Text('Open Medication List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/collection',
                    arguments: otherCollection);
              },
              child: const Text('Open Equipment List'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'constants.dart';
import 'auth_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Tracking'),
        centerTitle: false, // Set centerTitle to false
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AuthPage()));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // Set text color to white
            ),
            child: const Text('Login/Out'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/collection',
                      arguments: itemsCollection);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 36.0), // Extend horizontally
                ),
                child: const Text('Medication List'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/collection',
                      arguments: otherCollection);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36.0),
                ),
                child: const Text('Equipment List'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inv App Comment'),
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

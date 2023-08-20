import 'package:flutter/material.dart';
import 'Authentication/auth_page.dart';

//! Create then move into a folder named: Home Page

//! Store in home_page.dart
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

//! Store in home_page_state.dart
class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Tracking'),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AuthPage())),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Login/Out'),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: fetchCollections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No collections found.'));
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: snapshot.data!
                    .map((collection) =>
                        CollectionButton(collectionName: collection))
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

//! Store in collection_button.dart
class CollectionButton extends StatelessWidget {
  final String collectionName;

  const CollectionButton({Key? key, required this.collectionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/collection',
            arguments: collectionName),
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 36.0)),
        child: Text(collectionName),
      ),
    );
  }
}

//! Store in collection_list.dart
Future<List<String>> fetchCollections() async {
  return [
    'Stock Room - Medications',
    'Stock Room - Shelf 1',
    'Stock Room - Shelf 2',
    'Stock Room - Shelf 3',
    'Stock Room - Shelf 4',
  ];
}

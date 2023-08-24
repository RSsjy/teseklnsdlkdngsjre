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
        title: const Text('Inventory Tracking',
            style: TextStyle(color: Colors.white)),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AuthPage())),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Login/Out'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MedicationsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36.0),
                ),
                child: const Text('Stock Room - Medications'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EquipmentPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36.0),
                ),
                child: const Text('Stock Room - Equipment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//! MedicationsPage.dart
class MedicationsPage extends StatelessWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<CollectionItem> medicationsCollections = [
      CollectionItem('Stock Room - Critical Care Medications',
          'Critical Care Medications'),
      CollectionItem('Stock Room - System Medications', 'System Medications'),
      CollectionItem('Stock Room - IV Fluids', 'IV Fluids'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Room Medications'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: medicationsCollections
                .map((collectionItem) => CollectionButton(
                    collectionName: collectionItem.reference,
                    buttonText: collectionItem.buttonText))
                .toList(),
          ),
        ),
      ),
    );
  }
}

//! EquipmentPage.dart
class EquipmentPage extends StatelessWidget {
  const EquipmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<CollectionItem> equipmentCollections = [
      CollectionItem('Stock Room - Shelf 1', 'Stock Room - Shelf 1'),
      CollectionItem('Stock Room - Shelf 2', 'Stock Room - Shelf 2'),
      CollectionItem('Stock Room - Shelf 3', 'Stock Room - Shelf 3'),
      CollectionItem('Stock Room - Shelf 4', 'Stock Room - Shelf 4'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Equipment')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: equipmentCollections
                .map((collectionItem) => CollectionButton(
                    collectionName: collectionItem.reference,
                    buttonText: collectionItem.buttonText))
                .toList(),
          ),
        ),
      ),
    );
  }
}

//! Store in collection_button.dart
class CollectionButton extends StatelessWidget {
  final String collectionName;
  final String buttonText;

  const CollectionButton(
      {Key? key, required this.collectionName, required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/collection',
            arguments: collectionName),
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 36.0)),
        child: Text(buttonText),
      ),
    );
  }
}

//! Store in collection_list.dart
class CollectionItem {
  final String reference;
  final String buttonText;

  CollectionItem(this.reference, this.buttonText);
}

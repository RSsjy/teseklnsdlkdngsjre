import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_screen.dart';
import 'dialog_handlers.dart';

//! Create then move into a folder named: Collection Folder

//! Store in collection_page.dart
class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  CollectionPageState createState() => CollectionPageState();
}

//! Store in collection_page_state.dart
class CollectionPageState extends State<CollectionPage> {
  late String collectionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _dropdownItems = ['name', 'exp', 'location', 'updated'];
  String sortBy = 'location'; // Default sorting attribute
  bool isAscending = true; // Default sorting order

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    collectionName = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildStreamBuilder()),
          //! Admin Only
          ElevatedButton(
            onPressed: () {
              addItemToCollectionDialog(context, _firestore, collectionName);
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Inventory'),
      actions: [
        DropdownButton<String>(
          value: sortBy,
          items: _dropdownItems.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              sortBy = newValue!;
            });
          },
        ),
        Switch(
          value: isAscending,
          onChanged: (value) {
            setState(() {
              isAscending = value;
            });
          },
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
          activeTrackColor: Colors.lightGreenAccent,
          inactiveTrackColor: Colors.redAccent,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrderScreen(collectionName: collectionName)));
          },
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: const Text('Order', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  StreamBuilder<QuerySnapshot> _buildStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(collectionName)
          .orderBy(sortBy, descending: !isAscending)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (BuildContext context, int index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final itemName = data['name'] ?? '';
            final count = data['count'] ?? 0;
            final par = data['par'] ?? 0;
            final amountExpiring = data['amount expiring'] ?? 0;
            final exp = data['exp'] ?? '';
            final location = data['location'] ?? '';
            final updated = data['updated'] ?? '';
            final isGrayBackground = index % 2 == 1;
            final backgroundColor =
                isGrayBackground ? Colors.grey[200] : Colors.white;

            return Container(
              color: backgroundColor,
              child: ListTile(
                title: Text(itemName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location),
                    Text('Stock: $count / $par'),
                    Text('Exp Date: $exp ($amountExpiring / $count)'),
                    Text('Updated: $updated'),
                  ],
                ),
                onTap: () {
                  itemOptionsDialog(context, doc, _firestore, collectionName);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        updateCount(
                            doc.id, count + 1, _firestore, collectionName);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (count > 0) {
                          updateCount(
                              doc.id, count - 1, _firestore, collectionName);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

//! Store in item_options_dialog.dart
void itemOptionsDialog(BuildContext context, DocumentSnapshot itemData,
    FirebaseFirestore firestore, String collectionName) {
  // Use itemData directly instead of making a 'read' call
  String itemName = itemData['name'] ?? 'Unknown Item';
  String itemLocation = itemData['location'] ?? '';
  String itemExp = itemData['exp'] ?? '';
  int itemPar = itemData['par'] as int? ?? 0;
  int itemAmountExpiring = itemData['amount expiring'] as int? ??
      0; // Extract the 'amount expiring' value
  int itemCount = itemData['count'] as int? ?? 0; // Extract the 'count' value

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(itemName),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            //! Admin Only
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                deleteItemDialog(
                    context, itemData.id, firestore, collectionName);
              },
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                editItemDialog(
                  context,
                  itemData.id,
                  firestore,
                  collectionName,
                  itemName,
                  itemLocation,
                  itemExp,
                  itemPar,
                  itemAmountExpiring,
                  itemCount, // Pass the 'count' value
                );
              },
              child: const Text('Update'),
            ),
          ],
        ),
      );
    },
  );
}

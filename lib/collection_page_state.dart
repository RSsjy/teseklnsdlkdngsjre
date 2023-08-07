import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'collection_page.dart';
import 'dialog_handlers.dart';
import 'order_screen.dart';

class CollectionPageState extends State<CollectionPage> {
  late String collectionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    collectionName = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrderScreen(collectionName: collectionName)));
            },
            child: const Text('Order'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection(collectionName).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    final itemName = data['name'] ?? '';
                    final count = data['count'] ?? 0;
                    final par = data['par'] ?? 0;
                    final amountExpiring = data['amount expiring'] ?? 0;
                    final exp = data['exp'] ?? '';
                    final isGrayBackground =
                        index % 2 == 1; // Check if index is odd
                    final backgroundColor =
                        isGrayBackground ? Colors.grey[200] : Colors.white;
                    return Container(
                      color: backgroundColor,
                      child: ListTile(
                        title: Text(itemName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Count: $count'),
                            Text('Par: $par'),
                            Text('Amount Expiring: $amountExpiring'),
                            Text('Expiration: $exp'),
                          ],
                        ),
                        onTap: () {
                          itemOptionsDialog(
                              context,
                              snapshot.data!.docs[index].id,
                              _firestore,
                              collectionName);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                updateCount(snapshot.data!.docs[index].id,
                                    count + 1, _firestore, collectionName);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (count > 0) {
                                  updateCount(snapshot.data!.docs[index].id,
                                      count - 1, _firestore, collectionName);
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
            ),
          ),
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

  void itemOptionsDialog(BuildContext context, String documentId,
      FirebaseFirestore firestore, String collectionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Item Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the options dialog
                  editItemDialog(
                      context, documentId, firestore, collectionName);
                },
                child: const Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the options dialog
                  deleteItemDialog(
                      context, documentId, firestore, collectionName);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }
}

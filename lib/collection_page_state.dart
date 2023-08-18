import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'collection_page.dart';
import 'dialog_handlers.dart';
import 'order_screen.dart';

class CollectionPageState extends State<CollectionPage> {
  late String collectionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String sortBy = 'name'; // Default sorting attribute
  bool isAscending = true; // Default sorting order

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    collectionName = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          DropdownButton<String>(
            value: sortBy,
            items: ['name', 'exp', 'location', 'updated'].map((String value) {
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
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection(collectionName)
                  .orderBy(sortBy,
                      descending:
                          !isAscending) // Sorting based on user's choice
                  .snapshots(),
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
                    final location =
                        data['location'] ?? ''; // Added location retrieval
                    final isGrayBackground =
                        index % 2 == 1; // Check if index is odd
                    final backgroundColor =
                        isGrayBackground ? Colors.grey[200] : Colors.white;
                    final updated =
                        data['updated'] ?? ''; // Retrieve the updated
                    return Container(
                      color: backgroundColor,
                      child: ListTile(
                        title: Text(itemName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$location'),
                            // Text('Location: $location'),
                            Text('Stock: $count / $par'),
                            // Text('Par: $par'),
                            // Text('Amount Expiring: $amountExpiring'),
                            Text('Exp Date: $exp ($amountExpiring / $count)'),
                            Text('Updated: $updated'),
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

  void itemOptionsDialog(BuildContext context, String documentId,
      FirebaseFirestore firestore, String collectionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<DocumentSnapshot>(
          future: firestore.collection(collectionName).doc(documentId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return AlertDialog(
                  title: const Text('Error'),
                  content:
                      Text('Error fetching item details: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const AlertDialog(
                  title: Text('Error'),
                  content: Text('Item not found'),
                );
              }
              String itemName =
                  (snapshot.data!.data() as Map<String, dynamic>)['name'] ??
                      'Unknown Item';
              String itemLocation =
                  (snapshot.data!.data() as Map<String, dynamic>)['location'] ??
                      ''; // Retrieve the location
              String itemExp =
                  (snapshot.data!.data() as Map<String, dynamic>)['exp'] ?? '';
              int itemPar = (snapshot.data!.data()
                      as Map<String, dynamic>)['par'] as int? ??
                  0;
              return AlertDialog(
                title: Text(itemName), // Set the title to the item name
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        editItemDialog(
                            context,
                            documentId,
                            firestore,
                            collectionName,
                            itemName,
                            itemLocation,
                            itemExp, // This is the additional argument you need to add
                            itemPar);
                      },
                      child: const Text('Update'),
                    ),
                    //! Admin Only
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        deleteItemDialog(
                            context, documentId, firestore, collectionName);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            } else {
              // While the item details are being fetched, show a loading indicator
              return const AlertDialog(
                title: Text('Loading...'),
                content: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

const String itemsCollection = 'items';
const String otherCollection = 'other';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/collection': (context) => const CollectionPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
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
              child: const Text('Open Items Collection'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/collection',
                    arguments: otherCollection);
              },
              child: const Text('Open Other Collection'),
            ),
          ],
        ),
      ),
    );
  }
}

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);
  @override
  CollectionPageState createState() => CollectionPageState();
}

class CollectionPageState extends State<CollectionPage> {
  late String collectionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    collectionName = ModalRoute.of(context)!.settings.arguments as String;
  }

  void _addItemToCollection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String itemName = '';
        int count = 0;
        int par = 0;
        int amountExpiring = 0;
        String exp = '';
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  itemName = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  count = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Count',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) {
                  par = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Par',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) {
                  amountExpiring = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Amount Expiring',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) {
                  exp = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Expiration',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _firestore.collection(collectionName).add({
                  'name': itemName,
                  'count': count,
                  'par': par,
                  'amount expiring': amountExpiring,
                  'exp': exp,
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editItem(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String itemName = '';
        int count = 0;
        int par = 0;
        int amountExpiring = 0;
        String exp = '';
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  itemName = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  count = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Count',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) {
                  par = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Par',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) {
                  amountExpiring = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Amount Expiring',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) {
                  exp = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Expiration',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final Map<String, dynamic> updatedData = {};
                if (itemName.isNotEmpty) {
                  updatedData['name'] = itemName;
                }
                if (count != 0) {
                  updatedData['count'] = count;
                }
                if (par != 0) {
                  updatedData['par'] = par;
                }
                if (amountExpiring != 0) {
                  updatedData['amount expiring'] = amountExpiring;
                }
                if (exp.isNotEmpty) {
                  updatedData['exp'] = exp;
                }
                if (updatedData.isNotEmpty) {
                  _firestore
                      .collection(collectionName)
                      .doc(documentId)
                      .update(updatedData);
                }
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                _firestore.collection(collectionName).doc(documentId).delete();
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _updateCount(String documentId, int newCount) {
    _firestore.collection(collectionName).doc(documentId).update({
      'count': newCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection'),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editItem(snapshot.data!.docs[index].id);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteItem(snapshot.data!.docs[index].id);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                _updateCount(
                                    snapshot.data!.docs[index].id, count + 1);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (count > 0) {
                                  _updateCount(
                                      snapshot.data!.docs[index].id, count - 1);
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
            onPressed: _addItemToCollection,
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}

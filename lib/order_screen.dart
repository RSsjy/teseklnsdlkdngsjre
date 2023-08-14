import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart'; // Import for sharing functionality

class OrderScreen extends StatelessWidget {
  final String collectionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OrderScreen({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection(collectionName).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          // Filter items where (par - count) > 0
          final orderItems = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final count = data['count'] ?? 0;
            final par = data['par'] ?? 0;
            return (par - count) > 0;
          }).toList();

          // Extract the text from the order items
          final orderTexts = orderItems.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final itemName = data['name'] ?? '';
            final count = data['count'] ?? 0;
            final par = data['par'] ?? 0;
            final orderAmount = par - count;
            return '$itemName - $orderAmount';
          }).join('\n');

          return Scaffold(
            body: ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (BuildContext context, int index) {
                final data = orderItems[index].data() as Map<String, dynamic>;
                final itemName = data['name'] ?? '';
                final count = data['count'] ?? 0;
                final par = data['par'] ?? 0;
                final orderAmount = par - count;

                return ListTile(
                  title: Text('$itemName - $orderAmount'),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Share the extracted text
                Share.share(orderTexts);
              },
              child: const Icon(Icons.share),
            ),
          );
        },
      ),
    );
  }
}

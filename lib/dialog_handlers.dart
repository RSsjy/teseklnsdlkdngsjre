import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//! Create then move into a folder named: Dialog Handlers

//! Store in add_item_dialog.dart
void addItemToCollectionDialog(
    BuildContext context, FirebaseFirestore firestore, String collectionName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String itemName = '';
      int count = 0;
      int par = 0;
      int amountExpiring = 0;
      String exp = '';
      String location = '';
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
                location = value;
              },
              decoration: const InputDecoration(
                labelText: 'Location',
              ),
            ),
            TextField(
              onChanged: (value) {
                exp = value;
              },
              decoration: const InputDecoration(
                labelText: 'Expiration (YYYY-MM)',
              ),
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
                count = int.tryParse(value) ?? 0;
              },
              decoration: const InputDecoration(
                labelText: 'Count',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              firestore.collection(collectionName).add({
                'name': itemName,
                'count': count,
                'par': par,
                'amount expiring': amountExpiring,
                'exp': exp,
                'location': location,
                'updated':
                    DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
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

//! Store in delete_item_dialog.dart
void deleteItemDialog(BuildContext context, String documentId,
    FirebaseFirestore firestore, String collectionName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () {
              firestore.collection(collectionName).doc(documentId).delete();
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

//! Store in edit_item_dialog.dart
void editItemDialog(
    BuildContext context,
    String documentId,
    FirebaseFirestore firestore,
    String collectionName,
    String initialName,
    String initialLocation,
    String initialExp,
    int initialPar) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String itemName = initialName;
      int count = 0;
      int par = initialPar;
      int amountExpiring = 0;
      String location = initialLocation; // Set the initial value of location
      String exp = initialExp; // Set the initial value of exp

      return AlertDialog(
        title: Text('Edit $itemName'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //! Admin Only
              TextField(
                onChanged: (value) {
                  itemName = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                ),
                controller: TextEditingController(text: itemName),
              ),
              //! Admin Only
              TextField(
                onChanged: (value) {
                  location = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
                controller: TextEditingController(
                    text:
                        location), // Set the initial value of the TextField for Location
              ),
              TextField(
                onChanged: (value) {
                  exp = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Expiration Date (YYYY-MM)',
                ),
                controller: TextEditingController(
                    text:
                        exp), // Set the initial value of the TextField for Expiration Date
              ),
              //! Admin Only
              TextField(
                onChanged: (value) {
                  par = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Par',
                ),
                controller: TextEditingController(
                  text: par.toString(), // Convert par to a String
                ),
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
                  count = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Count',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final Map<String, dynamic> updatedData = {};
              if (itemName.isNotEmpty) {
                updatedData['name'] = itemName;
              }
              if (count >= 0) {
                updatedData['count'] = count;
              }
              if (par >= 0) {
                updatedData['par'] = par;
              }
              if (amountExpiring >= 0) {
                updatedData['amount expiring'] = amountExpiring;
              }
              if (exp.isNotEmpty) {
                updatedData['exp'] = exp;
              }
              if (location.isNotEmpty) {
                updatedData['location'] = location; // Added location attribute
              }
              updatedData['updated'] = DateFormat('yyyy-MM-dd HH:mm')
                  .format(DateTime.now()); // Update updated
              if (updatedData.isNotEmpty) {
                firestore
                    .collection(collectionName)
                    .doc(documentId)
                    .update(updatedData);
              }
              Navigator.pop(context);
            },
            child: const Text('Update'),
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

//! Store in update_count.dart
void updateCount(String documentId, int newCount, FirebaseFirestore firestore,
    String collectionName) {
  firestore.collection(collectionName).doc(documentId).update({
    'count': newCount,
  });
}

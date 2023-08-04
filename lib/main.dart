import 'package:flutter/material.dart';
import 'my_app.dart';
import 'firebase_init.dart';

void main() {
  initializeFirebase();
  runApp(const MyApp());
}

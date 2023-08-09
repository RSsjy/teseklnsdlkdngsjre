import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../z_firebase/firebase_options.dart';
import 'my_app.dart';
// import 'firebase_init.dart';

// void main() {
//   initializeFirebase();
//   runApp(const MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

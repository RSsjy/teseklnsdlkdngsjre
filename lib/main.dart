import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'collection_page_state.dart';
import 'firebase_options.dart';
import 'home_page.dart';

//! Store in main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

//! Store in my_app.dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const routeHome = '/';
  static const routeCollection = '/collection';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inv App',
      initialRoute: routeHome,
      routes: {
        routeHome: (context) => const HomePage(),
        routeCollection: (context) => const CollectionPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

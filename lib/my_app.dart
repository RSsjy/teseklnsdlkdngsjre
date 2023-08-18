import 'package:flutter/material.dart';
import 'home_page.dart';
import 'collection_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inv App',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/collection': (context) => const CollectionPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

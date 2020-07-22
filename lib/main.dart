import 'package:flutter/material.dart';
import 'package:recipedia/Pages/App/Home.dart';
import 'package:recipedia/Pages/Website/Home.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipedia',
        theme: ThemeData(
          fontFamily: 'Sans-Serif',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: (kIsWeb)
            ? WebHome()
            // running on the web
            : AppHome());
  }
}

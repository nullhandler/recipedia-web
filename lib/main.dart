import 'package:flutter/material.dart';
import 'package:recipedia/Pages/App/Home.dart';
import 'package:recipedia/Pages/Website/Home.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/App/Login.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  SharedPreferences prefs;
  String profilePic;

  init() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("googleID") != null) {
       profilePic = prefs.getString("photo");
      setState(() {
        isLoggedIn = true;
        print(isLoggedIn);
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

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
        home: screenToReturn(isLoggedIn));
  }

  Widget screenToReturn(bool check) {
    if (kIsWeb) {
      return WebHome();
    } else {
      if (check != true) {
        return AppHome();
      } else {
        return AppHome(pic: profilePic,);
      }
    }
  }
}

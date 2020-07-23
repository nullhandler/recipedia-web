import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipedia/Pages/App/Home.dart';
import 'package:recipedia/Pages/Website/Home.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'Pages/App/Login.dart';
import 'keys.dart' as secret;

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
    GoogleSignIn _googleSignIn = GoogleSignIn(clientId: secret.clientID);
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
            : LoginScreen());
  }

 void screenToReturn(){
  print(_googleSignIn.isSignedIn());
 }

}

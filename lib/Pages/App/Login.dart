import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipedia/Pages/App/Home.dart';
import 'package:recipedia/Providers/ApiService.dart';
import '../../keys.dart' as secret;
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(clientId: secret.clientID);

  SharedPreferences prefs;
  ApiProvider apiProvider = ApiProvider();

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/background-app.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new RotationTransition(
                        turns: new AlwaysStoppedAnimation(-10 / 360),
                        child: Text(
                          "Recipedia",
                          style: TextStyle(
                              fontSize: 60,
                              color: Colors.white,
                              fontFamily: 'RobotoMono'),
                        )),
                  ),
                  SizedBox(height: 100),
                  Align(child: _signInButton()),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      GoogleSignInAccount user = await _googleSignIn.signIn();
      if (user != null) {
        apiProvider
            .logIn(user.id, user.displayName, user.photoUrl)
            .then((value) => {
                  prefs.setString("googleID", user.id),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppHome()),
                  )
                });
      }
    } catch (error) {
      print(error);
    }
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.black,
      onPressed: () => _handleSignIn(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 25.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

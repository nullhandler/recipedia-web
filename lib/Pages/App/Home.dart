import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipedia/Providers/ApiService.dart';

class AppHome extends StatefulWidget {
  AppHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
//int _counter = 0;
  ApiProvider test = ApiProvider();

  // void _incrementCounter() async{
  //  test.getRecipes().then((value) => {
  //      print(value[0])
  //  });
  //   setState(() {
  //     _counter++;
  //   });
  // }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Floating NavBar Example'),
          centerTitle: true,
        ),
        //If you want to show body behind the navbar, it should be true
        extendBody: true,
        body: Center(
          child: Text(
            "index: $_index",
            style: TextStyle(
              fontSize: 52,
            ),
          ),
        ),
        bottomNavigationBar: FloatingNavbar(
          onTap: (int val) => setState(() => _index = val),
          currentIndex: _index,
          items: [
            FloatingNavbarItem(icon: Icons.home, title: 'WebHome'),
            FloatingNavbarItem(icon: Icons.explore, title: 'Explore'),
            FloatingNavbarItem(icon: Icons.chat_bubble_outline, title: 'Chats'),
            FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
          ],
        ),
      );
  }
}

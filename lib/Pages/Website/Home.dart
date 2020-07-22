import 'package:flutter/material.dart';
import 'package:recipedia/Providers/ApiService.dart';

class WebHome extends StatefulWidget {
  WebHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WebHomeState createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
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
            "index:",
            style: TextStyle(
              fontSize: 52,
            ),
          ),
        ),
        
      );
  }
}

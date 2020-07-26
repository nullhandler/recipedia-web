import 'package:flutter/material.dart';

class CreateRecipe extends StatefulWidget {
  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //Dariusgod42069
        //iamaamir03
        // actions: [ClipOval(child: Image.network('${widget.pic}'))],

        title: Text(
          "Create",
          style: TextStyle(
              fontSize: 24, color: Color(0xff262a46) , fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      //If you want to show body behind the navbar, it should be true
      extendBody: true,
      // body: Center()
    );
  }
}
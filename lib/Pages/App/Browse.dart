import 'package:flutter/material.dart';
import 'package:recipedia/Providers/ApiService.dart';

class Browse extends StatefulWidget {
  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  ApiProvider apiProvider = ApiProvider();

  

  Widget recipes() {
    return FutureBuilder(
      builder: (context, recipeSnap) {
        if (recipeSnap.hasData) {
          return ListView.builder(
            itemCount: recipeSnap.data.length,
            itemBuilder: (context, index) {
              return Card(
                child: Text("$index"),
              );
            },
          );
        } else {
          if (recipeSnap.connectionState == ConnectionState.none ||
              recipeSnap.hasData == null) {
            //print('project snapshot data is: ${recipeSnap.data}');
            return Container();
          }
          return Align(child: Center(child: Text("Error")));
        }
      },
      future: apiProvider.getRecipes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: recipes(),
    );
  }
}
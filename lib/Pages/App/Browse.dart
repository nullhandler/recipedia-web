import 'package:flutter/material.dart';
import 'package:recipedia/Providers/ApiService.dart';
import 'package:recipedia/Constants/Api.dart' as urls;

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
          print(recipeSnap.data);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: recipeSnap.data.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 150,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        recipeSnap.data[index].recipePic != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                                                          child: Image.network(
                                  urls.imagesURL +
                                      "${recipeSnap.data[index].recipePic}",
                                  fit: BoxFit.fill,
                                  width: 150,
                                ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                                                          child:Image.asset(
                                "assets/background-app.jpg",
                                width: 150,
                                fit: BoxFit.fill,
                              )),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              '${recipeSnap.data[index].title}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: new Color(0xFF212121),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    margin: EdgeInsets.all(10),
                  ),
                );
              },
            ),
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
    return recipes();
  }
}

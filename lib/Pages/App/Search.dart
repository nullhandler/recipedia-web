import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipedia/Providers/ApiService.dart';
import 'package:shimmer/shimmer.dart';
import 'package:recipedia/Constants/Api.dart' as urls;
import 'Details.dart';

class Search extends SearchDelegate {
  final apiprovider = ApiProvider();

  @override
  String get searchFieldLabel => 'Search Recipes';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: theme.inputDecorationTheme,
        backgroundColor: theme.backgroundColor,
        primaryColor: Colors.white,
        primaryIconTheme: new IconThemeData(color: Colors.black),
        brightness: theme.brightness,
        iconTheme: new IconThemeData(color: Colors.black));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showResults(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: apiprovider.searchRecipe(query),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
// guard clause: if there is an error it shows an error icon
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Oopsie! No Recipe Found!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }

// guard clause: if there is no data it shows a progress icon
        if (!snapshot.hasData) {
          return Center(child: SpinKitFadingCircle(
              itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(color: Color(0xff262a46)),
            );
          }));
        }

// build a GridView with all results
        List results = snapshot.data;
        print(results);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipeDetails(
                              recipe: results[index],
                            )),
                  )
                },
                child: Hero(
                  tag: 'recipe' + results[index].sId,
                  child: Container(
                    height: 150,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          results[index].recipePic != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: urls.imagesURL +
                                        "${results[index].recipePic}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      )),
                                    ),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[400],
                                      highlightColor: Colors.white,
                                      child: Container(width: 150),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  //                           child: Image.network(

                                  // ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/background-app.jpg",
                                    width: 150,
                                    fit: BoxFit.fill,
                                  )),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                '${results[index].title}',
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
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Feeling Hungry?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Search Recipes From Our Database & Start Cooking Already!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );
    }

    return FutureBuilder(
      future: apiprovider.searchRecipe(query),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
// guard clause: if there is an error it shows an error icon
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Oopsie! No Recipe Found!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }

// guard clause: if there is no data it shows a progress icon
        if (!snapshot.hasData) {
          return Center(child: SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(color: Color(0xff262a46)),
              );
            },
          ));
        }
// build a listview with all suggestions
        List results = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipeDetails(
                              recipe: results[index],
                            )),
                  )
                },
                child: Hero(
                  tag: 'recipe' + results[index].sId,
                  child: Container(
                    height: 150,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          results[index].recipePic != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: urls.imagesURL +
                                        "${results[index].recipePic}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      )),
                                    ),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[400],
                                      highlightColor: Colors.white,
                                      child: Container(width: 150),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  //                           child: Image.network(

                                  // ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/background-app.jpg",
                                    width: 150,
                                    fit: BoxFit.fill,
                                  )),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                '${results[index].title}',
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
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

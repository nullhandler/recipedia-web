import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipedia/Pages/App/Details.dart';
import 'package:recipedia/Providers/ApiService.dart';
import 'package:recipedia/Constants/Api.dart' as urls;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class LikedRecipes extends StatefulWidget {
  @override
  _LikedRecipesState createState() => _LikedRecipesState();
}

class _LikedRecipesState extends State<LikedRecipes>
    with TickerProviderStateMixin {
  ApiProvider apiProvider = ApiProvider();
  List liked = [];
  String userID, profilePic;
  Future get;
  String id;
  Widget recipes() {
    return FutureBuilder(
      builder: (context, recipeSnap) {
        if (recipeSnap.hasData) {
          if (recipeSnap.data != 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: recipeSnap.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => {
                      print(liked),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeDetails(
                                  likedRecipes: liked,
                                  recipe: recipeSnap.data[index],
                                  userID: userID,
                                  profilePic: profilePic,
                                )),
                      )
                    },
                    child: Hero(
                      tag: 'recipe' + recipeSnap.data[index].sId,
                      child: Container(
                        height: 130,
                        child: Card(
                          color: Colors.white,
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            children: [
                              recipeSnap.data[index].recipePic != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: urls.imagesURL +
                                            "${recipeSnap.data[index].recipePic}",
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
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
                            side: BorderSide(color: Colors.grey[400]),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 0.5,
                          margin: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No Liked Recipes Yet!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'Like Something!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }
        } else if (recipeSnap.connectionState == ConnectionState.none ||
            recipeSnap.connectionState == ConnectionState.waiting) {
          return SpinKitWave(
            color: Colors.redAccent,
            size: 50.0,
            controller: AnimationController(
                vsync: this, duration: const Duration(milliseconds: 1200)),
          );
        } else {
          if (recipeSnap.hasData == null || recipeSnap.hasError) {
            //print('project snapshot data is: ${recipeSnap.data}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '404',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'Aw , Snap!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }
          return Align(child: Center(child: Text("Error")));
        }
      },
      future: apiProvider.getLikedRecipes(id),
    );
  }

  @override
  void initState() {
    init();
    //get = apiProvider.getLikedRecipes(id);
    super.initState();
  }

  SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("googleID") != null) {
      userID = id;

      apiProvider.getUser(id).then((user) => {
        print(user),
            liked = user['liked'],
            profilePic = user['profilePic'],
            
          });
      setState(() {
        id = prefs.getString("googleID");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return recipes();
  }
}

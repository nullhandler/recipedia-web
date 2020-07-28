import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:recipedia/Providers/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CreateRecipe extends StatefulWidget {
  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  ApiProvider _apiProvider = new ApiProvider();
  File _image;
  final picker = ImagePicker();
  List<Widget> steps = List<Widget>();
  List<Widget> ingredients = List<Widget>();
  List<TextEditingController> ingc = [];
  List<TextEditingController> stepc = [];
  TextEditingController title = TextEditingController();
  SharedPreferences prefs;
  String userID;
  init() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("googleID") != null) {
      var id = prefs.getString("googleID");
      userID = id;
      setState(() {});
    }
  }
  String imgUrl;
  bool isVeg = true;
  int mins = 0;

  @override
  void initState() {
    init();
    super.initState();
    var temp1 = new TextEditingController();
    ingc.add(temp1);
    var temp2 = new TextEditingController();
    stepc.add(temp2);
    steps.add(Row(
      children: [
        Flexible(
          child: TextField(
            controller: temp2,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red, //this has no effect
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: "Step 1",
            ),
          ),
        ),
      ],
    ));
    ingredients.add(
      Row(
        children: [
          Flexible(
            child: TextField(
              controller: temp1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, //this has no effect
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Ingredient 1",
              ),
            ),
          ),
        ],
      ),
    );
    setState(() {});
  }

  Future<int> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
    if (pickedFile != null) {
      return 1;
    } else {
      return 0;
    }
  }

  addStep() {
    var controller = new TextEditingController();
    var hint = steps.length;
    stepc.add(controller);
    steps.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red, //this has no effect
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Step ${hint + 1}",
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  addIngredient() {
    var controller = new TextEditingController();
    ingc.add(controller);
    var hint = ingredients.length;
    ingredients.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red, //this has no effect
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Ingredient ${hint + 1}",
                ),
              ),
            ),
          ),
        ],
      ),
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          backgroundColor: Color(0xff262a46),
          onPressed: () {
            List<String> ing = [], step = [];
            ingc.forEach((element) {
              ing.add(element.text);
            });
            stepc.forEach((element) {
              step.add(element.text);
            });
            _apiProvider.createRecipe(_image, {
              "time": mins,
              "title": title.text,
              "is_veg": isVeg,
              "userID": userID,
              "ingredients":ing,
              "steps":step
            }).then((value) => {
             Navigator.pop(context)
            });

            setState(() {});
          },
          child: Icon(Icons.done_outline),
        ),
      ),
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Color(0xff262a46),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Create",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ]),
                    ),
                  )),
              Align(
                  child: _image != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 100.0),
                          child: Container(
                              height: 150.0,
                              width: 150.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(75.0),
                                  child: (Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )))),
                        )
                      : InkWell(
                          onTap: () {
                            Future temp = getImage();
                            if (temp != null) {
                              setState(() {});
                            }
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: ClipOval(
                                  child: Container(
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                ),
                                width: 150,
                                height: 150,
                                color: Colors.grey[300],
                                //fit: BoxFit.fill,
                              ))),
                        ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: title,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Title",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChoiceChip(
                  selectedColor: Colors.green[100],
                  label: Row(
                    children: [
                      Icon(Icons.fastfood,
                          color: isVeg ? Colors.green : Colors.black),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Veg',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: isVeg ? Colors.green : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  selected: isVeg,
                  onSelected: (bool selected) {
                    setState(() {
                      isVeg = true;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChoiceChip(
                  selectedColor: Colors.red[100],
                  label: Row(
                    children: [
                      Icon(Icons.fastfood,
                          color: !isVeg ? Colors.red : Colors.black),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Non-Veg',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: !isVeg ? Colors.red : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  selected: !isVeg,
                  onSelected: (bool selected) {
                    setState(() {
                      isVeg = false;
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  color: Color(0xff262a46),
                ),
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: NumberPicker.integer(
                        initialValue: mins,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (m) {
                          setState(() {
                            mins = m;
                          });
                        })),
                Text("Mins")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '- Ingredients -',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: new TextStyle(
                fontSize: 18.0,
                color: new Color(0xFF212121),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ingredients.length,
              itemBuilder: (context, pos) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                    child: Column(
                      children: [
                        ingredients[pos],
                      ],
                    ));
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  addIngredient();
                });
              }),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '- Steps -',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: new TextStyle(
                fontSize: 18.0,
                color: new Color(0xFF212121),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: steps.length,
              itemBuilder: (context, pos) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: steps[pos],
                    ),
                  ]),
                );
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  addStep();
                });
              }),
        ],
      ),
    );
  }
}

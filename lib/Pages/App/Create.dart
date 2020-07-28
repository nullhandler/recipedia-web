import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:recipedia/Constants/Api.dart' as urls;
import 'package:shimmer/shimmer.dart';

class CreateRecipe extends StatefulWidget {
  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  List<Widget> steps = List<Widget>();
  List<Widget> ingredients = List<Widget>();
  String imgUrl;
  bool isVeg = true;
  int mins = 0;

  @override
  void initState() {
    super.initState();
    steps.add(Row(
      children: [
        Flexible(
          child: TextField(),
        ),
      ],
    ));
    ingredients.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(),
          ),
        ],
      ),
    ));
    setState(() {});
  }

  addStep() {
    steps.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(),
          ),
        ],
      ),
    ));
  }

  addIngredient() {
    ingredients.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(),
          ),
        ],
      ),
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            )
                          ]),
                    ),
                  )),
              Align(
                  child: imgUrl != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 100.0),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: urls.imagesURL + imgUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                )),
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[400],
                                highlightColor: Colors.white,
                                child: Container(width: 150),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            // imgUrl = picked Image name
                            // TODO: Image Pick Logic
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: ClipOval(
                                  child: Container(
                                child: Icon(Icons.add),
                                width: 150,
                                height: 150,
                                color: Colors.grey,
                                //fit: BoxFit.fill,
                              ))),
                        ))
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlign: TextAlign.center,
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
            padding: const EdgeInsets.all(1.0),
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
          Expanded(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ingredients.length,
                itemBuilder: (context, pos) {
                  return Column(
                    children: [
                      ingredients[pos],
                    ],
                  );
                }),
          ),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  addIngredient();
                });
              }),
          Padding(
            padding: const EdgeInsets.all(1.0),
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
          Expanded(
            child: ListView.builder(
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
          ),
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

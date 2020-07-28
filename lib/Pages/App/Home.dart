import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipedia/Pages/App/Browse.dart';
import 'package:recipedia/Pages/App/Create.dart';
import 'package:recipedia/Pages/App/Liked.dart';
import 'package:recipedia/Pages/App/Search.dart';
import 'package:recipedia/Providers/ApiService.dart';
import 'package:recipedia/widgets/navbar.dart';

class AppHome extends StatefulWidget {
  AppHome({Key key, this.title, this.pic}) : super(key: key);
  final String title;
  final String pic;

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> with TickerProviderStateMixin {
  int _index = 0;
  TabController _tabController;
  AnimationController _animationController;


  final List<Widget> _listTabs = [Browse(), Browse(), LikedRecipes()];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: _listTabs.length);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animationController.reverse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateRecipe()));
            }),
        // actions: [ClipOval(child: Image.network('${widget.pic}'))],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage('${widget.pic}')))),
          )
        ],
        title: Text(
          "Recipedia",
          style: TextStyle(
              fontSize: 24,
              color: Color(0xff262a46),
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      //If you want to show body behind the navbar, it should be true
      extendBody: true,
      // body: Center(),
      body: TabBarView(
          children: _listTabs,
          controller: _tabController,
          physics: NeverScrollableScrollPhysics()),
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: Color(0xff262a46),
        selectedBackgroundColor: Colors.redAccent,
        itemBorderRadius: 40,
        selectedItemColor: Colors.white,
        borderRadius: 40,
        onTap: (int val) {
          if (val == 1) {
            showSearch(context: context, delegate: Search());
          } else {
            setState(() {
              _index = val;
              _tabController.animateTo(_index);
              _animationController.reverse();
            });
          }
        },
        currentIndex: _index,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.search, title: 'Search'),
          FloatingNavbarItem(
              icon: Icons.favorite_border, title: 'Liked Recipes'),
        ],
      ),
    );
  }
}

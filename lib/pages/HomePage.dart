import 'package:cofisec/pages/FavorisPage.dart';
import 'package:cofisec/tabs/ProfilePage.dart';
import 'package:cofisec/tabs/TrainingTab.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _tabs = [
    TrainingTab(),
    FavorisPage(),
    ProfileTab()
  ];
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _tabs.elementAt(_index),
      bottomNavigationBar: 
      
      
      BottomNavigationBar(
        currentIndex: _index,
        onTap: (i){
          setState(() {
            _index = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            title: Text("Acceuil"),
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            title: Text("Favoris"),
            icon: Icon(Icons.favorite)
          ),
          BottomNavigationBarItem(
            title: Text("Profil"),
            icon: Icon(Icons.person)
          ),
          
        ],
      ),
    );
  }
}
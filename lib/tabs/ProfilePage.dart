import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofisec/pages/AdminPage.dart';
import 'package:cofisec/pages/MyRequests.dart';
import 'package:cofisec/pages/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab({Key key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  List<QueryDocumentSnapshot> _favsDocs = new List();

  _getFavorisProducts() {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      CollectionReference favorissRef =
          FirebaseFirestore.instance.collection('reservation');
      favorissRef
          .where('candidat', isEqualTo: auth.currentUser.uid)
          .get()
          .then((res) {
        setState(() {
          _favsDocs = res.docs;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getFavorisProducts();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      if (auth.currentUser.email == 'admin@admin.com') {
        return AdminPage();
      }else{
        return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(224, 231, 245, 1),
          title: Text(
            "Profil",
            style: TextStyle(color: Color.fromRGBO(143, 29, 31, 1)),
          ),
          actions: [
            auth.currentUser != null
                ? IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      auth.signOut().then((value) => {});
                    },
                  )
                : Container()
          ],
        ),
        body: auth.currentUser == null
            ? Center(
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Text("Vous devez d'abord vous connecter"),
                      FlatButton(
                        child: Text(
                          'Se connecter',
                        ),
                        onPressed: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) {
                              return SignInPage();
                            },
                          ));
                        },
                      )
                    ],
                  ),
                ),
              )
            : Container(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 15,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            radius: 50,
                          ),
                          Container(
                            height: 15,
                          ),
                          Text(auth.currentUser.displayName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          Container(
                            height: 15,
                          ),
                          Text(auth.currentUser.email,
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 29, 31, 1),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Mes demandes(${_favsDocs.length})",
                              style: TextStyle(
                                  color: Color.fromRGBO(33, 35, 82, 1),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width,
                            child: FlatButton(
                              child: Text('Voir details'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyRequestsPage()),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
      }
    }else

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(224, 231, 245, 1),
          title: Text(
            "Profil",
            style: TextStyle(color: Color.fromRGBO(143, 29, 31, 1)),
          ),
          actions: [
            auth.currentUser != null
                ? IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      auth.signOut().then((value) => {});
                    },
                  )
                : Container()
          ],
        ),
        body: auth.currentUser == null
            ? Center(
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Text("Vous devez d'abord vous connecter"),
                      FlatButton(
                        child: Text(
                          'Se connecter',
                        ),
                        onPressed: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) {
                              return SignInPage();
                            },
                          ));
                        },
                      )
                    ],
                  ),
                ),
              )
            : Container(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 15,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            radius: 50,
                          ),
                          Container(
                            height: 15,
                          ),
                          Text(auth.currentUser.displayName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          Container(
                            height: 15,
                          ),
                          Text(auth.currentUser.email,
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 29, 31, 1),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Mes demandes(${_favsDocs.length})",
                              style: TextStyle(
                                  color: Color.fromRGBO(33, 35, 82, 1),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width,
                            child: FlatButton(
                              child: Text('Voir details'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyRequestsPage()),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}

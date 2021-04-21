import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRequestsPage extends StatefulWidget {
  MyRequestsPage({Key key}) : super(key: key);

  @override
  _MyRequestsPageState createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(224, 231, 245, 1),
          title: Text(
            "Mes demandes",
            style: TextStyle(color: Color.fromRGBO(143, 29, 31, 1)),
          ),
        ),
        body: ListView.builder(
          itemCount: _favsDocs.length,
          itemBuilder: (context, index) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('formations')
                  .doc(_favsDocs[index].data()['formation'])
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> _produit = snapshot.data.data();

                  String id = snapshot.data.id;
                  return new GestureDetector(
                      onTap: () {},
                      child: Container(
                          margin: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Container(
                                width: (width - 30) * 0.3,
                                child: Image.network(
                                  _produit['image'],
                                ),
                              ),
                              Container(
                                width: (width - 30) * 0.7,
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_produit['titre']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "${_favsDocs[index].data()['type']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Container(
                                        child: _favsDocs[index]
                                                    .data()['confirmation'] ==
                                                true
                                            ? Container(
                                              padding: EdgeInsets.all(5),
                                                child: Text('confirmé'),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color:
                                                        Colors.green.shade300))
                                            : Container(
                                              padding: EdgeInsets.all(5),
                                                child: Text('en attente'),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color:
                                                        Colors.orange.shade300)))
                                  ],
                                ),
                              )
                            ],
                          )));
                }

                return Container(
                  height: 80,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
        ));
  }
}

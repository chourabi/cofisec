


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofisec/pages/FormationPage.dart';
import 'package:cofisec/pages/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavorisPage extends StatefulWidget {
  FavorisPage({Key key}) : super(key: key);

  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {

    List<QueryDocumentSnapshot> _favsDocs = new List();



  _getFavorisProducts(){
        FirebaseAuth auth = FirebaseAuth.instance;

        if (auth.currentUser != null) {
              CollectionReference favorissRef = FirebaseFirestore.instance.collection('favoris'); 
        favorissRef.where('candidat', isEqualTo: auth.currentUser.uid).get().then((res) {
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
    return Scaffold(
      appBar:              AppBar(
               backgroundColor: Color.fromRGBO(224, 231, 245, 1),
               title: Text("Favoris",style: TextStyle(color: Color.fromRGBO(143, 29, 31, 1)),),
             ),
      body: 
      auth.currentUser == null ? 
      Center(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(children: [Text("Vous devez d'abord vous connecter"),FlatButton(child: Text('Se connecter',),onPressed: (){Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return SignInPage();
        },));},)],),),
      )
      :
      
      Container(
        child: ListView.builder( itemCount: _favsDocs.length, itemBuilder: (context, index) {

          
          return FutureBuilder<DocumentSnapshot>(
          future:  FirebaseFirestore.instance.collection('formations').doc(_favsDocs[index].data()['formation']).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> _produit = snapshot.data.data();


              


              String id =  snapshot.data.id;
              return new GestureDetector(
                    onTap: (){
                      

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FormationPage(id:id)),
                        );

                    },


                    child :
          
          
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: (width - 30 ) * 0.3 ,
                  child: Image.network(_produit['image'], ),
                ),
                Container(
                  width: (width - 30 ) * 0.7 ,
                  padding: EdgeInsets.only(left:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [  
                    Text("${_produit['titre']}", style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w300),)
                             
                  ],),
                )
              ],
            )
          )
          );
            }

            return Container(
              height: 80,
              child: Center(
              child: CircularProgressIndicator(),
            ),
            );
          },
        );
        
        }, ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofisec/pages/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormationPage extends StatefulWidget {
  final String id;
  FormationPage({Key key, this.id}) : super(key: key);

  @override
  _FormationPageState createState() => _FormationPageState();
}

class _FormationPageState extends State<FormationPage> {
  String _id;
  String _choice='group';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = widget.id;

  }


  _alert(title,message){
     Widget okButton = FlatButton(  
    child: Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text(title),  
    content: Text(message),  
    actions: [  
      okButton,  
    ],  );

    showDialog(context: context, builder: (context) {
      return alert;
    },);
  }

  _reserveTrainning(){
    // check if connected first
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      var reservation = {
        "date": new DateTime.now(),
        "candidat":auth.currentUser.uid,
        "formation":_id,
        "type":_choice,
        "confirmation":false
      };
      FirebaseFirestore.instance.collection('reservation').where('confirmation', isEqualTo: false)
      .where('formation',isEqualTo: _id)
      .where('candidat',isEqualTo: auth.currentUser.uid ).get().then((res){
        if (res.docs.length == 0) {
          FirebaseFirestore.instance.collection('reservation').add(reservation).then((finaladd){
            _alert("Merci", "Votre demande a été enregistrée avec succès");
          });
        }else{
          _alert("Oups", "Vous êtes déjà inscrit à cette formation");
        }
      });
    }else{
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          actions: [IconButton(
            icon: Icon(Icons.favorite),
            onPressed: (){
                  FirebaseAuth auth = FirebaseAuth.instance;
              FirebaseFirestore.instance.collection('favoris')
      .where('formation',isEqualTo: _id)
      .where('candidat',isEqualTo: auth.currentUser.uid ).get().then((res){
        if (res.docs.length == 0) {
          FirebaseFirestore.instance.collection('favoris').add({
            'formation': _id,
            'candidat': auth.currentUser.uid,
            
          }).then((finaladd){
            _alert("Favoris", "Formation ajouté au favoris avec succès");
          });
        }else{
          _alert("Favoris", "Formation ajouté au favoris avec succès");
        }
      });
            },
          )],
          backgroundColor: Color.fromRGBO(224, 231, 245, 1),
          title: Text("Details formation",style: TextStyle(color: Color.fromRGBO(143, 29, 31, 1)),),
        ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('formations').doc(_id).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
               children: [
                  Image.network(snapshot.data.data()['image']),
                  Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data.data()['titre'],style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 25,fontWeight: FontWeight.bold),)
                        ,Container(height: 15,),
                        Text(snapshot.data.data()['description'],style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 18,fontWeight: FontWeight.w300),),
                        Text("Prix",style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 25,fontWeight: FontWeight.bold),),
                        ListTile(
                          leading: Radio(
                            groupValue: _choice,
                            value: 'group',
                            onChanged: (v){
                              setState(() {
                                _choice = v;
                              });
                            },
                          ),
                          title:  Text('Group : '+snapshot.data.data()['prixGroup']  ,style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 20,fontWeight: FontWeight.bold),),

                        ),
                        ListTile(
                          leading: Radio(
                            groupValue: _choice,
                            value: 'Individuel',
                            onChanged: (v){
                              setState(() {
                                _choice = v;
                              });
                            },
                          ),
                          title: Text('Individuel : '+snapshot.data.data()['prixIndividuel'] ,style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                        
                       
                        
                        
                        Container(height: 15,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Color.fromRGBO(33, 35, 82, 1),
                          onPressed: (){
                            _reserveTrainning();
                          },
                          child: Text("Réservé",style: TextStyle(color: Colors.white),),
                        ),
                        )
                        
                        
                        
                      ],
                    ),
                  )


               ],
              ),
            );
          }


          if (snapshot.hasError) {
            return Center();

          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
      ));
  }
}
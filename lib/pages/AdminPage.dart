import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofisec/pages/AddNewFormation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

    List<QueryDocumentSnapshot> _formationsDocs = new List();

  getTrainingsList(){
    CollectionReference formationsRef = FirebaseFirestore.instance.collection('formations');
    formationsRef.get().then((res){
      setState(() {
        _formationsDocs = res.docs;
      });
    });
      
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrainingsList();
  }

  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
        FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 231, 245, 1),
        title: Text("Admin dashboard",style: TextStyle(color: Color.fromRGBO(143, 29, 31, 1)),),
        actions: [
          auth.currentUser != null ?
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              auth.signOut().then((value) => {});
            },
          ):
          Container()
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewFormation(updateFN: getTrainingsList,)),
          );
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
                 itemCount: _formationsDocs.length,itemBuilder: (context, index) {
                 return GestureDetector(
                   onTap: (){
                       
                   },
                   child: Container(
                   margin: EdgeInsets.only(right: 15),
                   width: width,
                   child: Card(
                     child: Column(
                       children: [
                         Container(
                           height: width*0.5,
                          width: width*0.5,
                          child: Image.network(_formationsDocs[index].data()['image'])
                         ,
                         ),
                         Container(
                          width: width,
                          child: Text(
                            
                            _formationsDocs[index].data()['titre'],
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 19,fontWeight: FontWeight.bold),
                            )
                         ,
                         ),
                         Container(
                          width: width,
                          child: FlatButton(
                            color: Colors.redAccent,
                            child: Text('Supprimer'),
                            onPressed: (){
AlertDialog alert = AlertDialog(  
                          title: Text("Supprimer"),  
                          content: Text("Voulez vous supprimer cette formation?"),  
                          actions: [  
                            FlatButton(
                              child: Text('Annuler'),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ), 
                            FlatButton(
                              child: Text('Supprimer'),
                              onPressed: (){
                                FirebaseFirestore.instance.collection('formations').doc(_formationsDocs[index].id).delete().then((value){
                                  getTrainingsList();
                                  Navigator.pop(context);
                                });
                              },
                            ),  
                          ],  
                        );  
                        
                        // show the dialog  
                        showDialog(  
                          context: context,  
                          builder: (BuildContext context) {  
                            return alert;  
                          },  
                        );  
                            },
                          ) 
                          
                         ),
                         
                       ],
                     ),
                   ),
                 )
                 );
               },),
    );
  }
}
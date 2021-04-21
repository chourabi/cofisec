import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofisec/pages/FormationPage.dart';
import 'package:flutter/material.dart';

class TrainingTab extends StatefulWidget {
  TrainingTab({Key key}) : super(key: key);

  @override
  _TrainingTabState createState() => _TrainingTabState();
}

class _TrainingTabState extends State<TrainingTab> {

  List<QueryDocumentSnapshot> _formationsDocs = new List();

  _getTrainingsList(){
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
    _getTrainingsList();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
         child: Container(
           
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             
           
           children: [
             AppBar(
               backgroundColor: Color.fromRGBO(224, 231, 245, 1),
               title: Text("Bienvenue à Cofisec",style: TextStyle(color: Color.fromRGBO(143, 29, 31, 1)),),
             ),
             // hi section
             Container(
               width: width,
               height: ( (height-100)*0.5),
               child: Image.asset('assets/logo.png',fit: BoxFit.fill,)
             ),

             Container(
               padding: EdgeInsets.all(15),
               child: Column(children: [
                 Container(
                   child: Text("Nos Formations",style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 25,fontWeight: FontWeight.bold),),
                 )
               ],),
             ),
             Container(
               height: 270,
               padding: EdgeInsets.all(15),
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: _formationsDocs.length,itemBuilder: (context, index) {
                 return GestureDetector(
                   onTap: (){
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormationPage(id: _formationsDocs[index].id,) ),
                      );
                   },
                   child: Container(
                   margin: EdgeInsets.only(right: 15),
                   width: width,
                   height: 260,
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
                         
                       ],
                     ),
                   ),
                 )
                 );
               },)
             ),
             
             


           ],

         ),
         )
       );
  }
}
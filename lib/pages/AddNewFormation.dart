import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNewFormation extends StatefulWidget {
  final dynamic  updateFN;

  AddNewFormation({Key key, this.updateFN}) : super(key: key);

  @override
  _AddNewFormationState createState() => _AddNewFormationState();
}

class _AddNewFormationState extends State<AddNewFormation> {

FirebaseFirestore fs  = FirebaseFirestore.instance;

  TextEditingController _titreController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _imageController = new TextEditingController();
  TextEditingController _prixGController = new TextEditingController();
  TextEditingController _prixIController = new TextEditingController();

dynamic _updateFn;
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    _updateFn = widget.updateFN;

  }
  

  @override
  Widget build(BuildContext context) {

    


    

    return Scaffold(
      appBar: AppBar(
                backgroundColor: Color.fromRGBO(224, 231, 245, 1),
        title: Text("Ajouter une formation",style: TextStyle(color: Color.fromRGBO(143, 29, 31, 1)),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 25,),
                        Text("Ajouter une formation",style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 25,fontWeight: FontWeight.bold),),
            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Titre",
                  errorText:  null
                ),
                controller: _titreController,

              ),
            ),

            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Description",
                  errorText:  null
                ),
                controller: _descriptionController,

              ),
            ),

                        Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Lien image",
                  errorText:  null
                ),
                controller: _imageController,

              ),
            ),

            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Prix group",
                  errorText:  null
                ),
                controller: _prixGController,

              ),
            ),

            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Prix Individuel",
                  errorText:  null
                ),
                controller: _prixIController,

              ),
            ),


            Container(
                           padding: EdgeInsets.only(left: 15,right: 15),
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Color.fromRGBO(33, 35, 82, 1),
                          onPressed: () async{
                            Map<String, dynamic> formation =  {
                                "titre":_titreController.text.trim(),
                                "description":_descriptionController.text.trim(),
                                "prixGroup":_prixGController.text.trim(),
                                "prixIndividuel":_prixIController.text.trim(),
                                "image":_imageController.text.trim(),
                              };
                            await fs.collection('formations').add(
                             formation
                            );

                            _updateFn();
                            Navigator.pop(context);
                          },
                          child: Text("Ajouter",style: TextStyle(color: Colors.white),),
                        ),
                        )
            
            
          ],
        ),
         
      ),
    );
  }
}
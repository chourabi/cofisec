import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofisec/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SignupPage extends StatefulWidget {



  SignupPage({Key key}) : super(key: key);


  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignupPage> {

TextEditingController _emailControl = new TextEditingController();
TextEditingController _passwordControl = new TextEditingController();
TextEditingController _passwordConfirmControl = new TextEditingController();
TextEditingController _nomControl = new TextEditingController();
TextEditingController _phoneControl = new TextEditingController();

  bool _isLoading = false;
  String _errMessage ="";

  FirebaseAuth auth = FirebaseAuth.instance;


  _signinAccount(String email, String password){

    setState(() {
      _isLoading = ! _isLoading;
      _errMessage="";
    });
    auth.createUserWithEmailAndPassword(email: email, password: password).then(( response){
      setState(() {
        _isLoading = ! _isLoading;
      });

      print(response);

      auth.currentUser.updateProfile(displayName: _nomControl.text).then((value){
       // add it fireebase user collections
       FirebaseFirestore.instance.collection('users').doc(auth.currentUser.uid).set({
         'email':_emailControl.text.trim(),
         'phone':_phoneControl.text.trim(),
         'nom':_nomControl.text.trim(),
         
       }).then((value) => Navigator.pop(context));
      });
         
    }).catchError((e){


      setState(() {
        _isLoading = ! _isLoading;
        _errMessage = e.message;
      });
      
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        
        child: SingleChildScrollView(
          
          child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
 Text("Créer un compte",style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 25,fontWeight: FontWeight.bold),),

            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Nom complet",
                  errorText:  null
                ),
                controller: _nomControl,

              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Numéro tel",
                  errorText:  null
                ),
                controller: _phoneControl,

              ),
            ),       
            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Email",
                  errorText:  null
                ),
                controller: _emailControl,

              ),
            ),
            Container(
              
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Mot de passe",
                ),
                controller: _passwordControl,
                obscureText: true,

              ),
            ),
            Container(
              
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Confirmer mot de passe",
                ),
                controller: _passwordConfirmControl,
                obscureText: true,

              ),
            ),

            _isLoading == false ?

                        Container(
                           padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Color.fromRGBO(33, 35, 82, 1),
                          onPressed: (){
                             String email = _emailControl.text.trim();
                             String pass = _passwordControl.text;
                             String confPass = _passwordConfirmControl.text;
                             String nom = _nomControl.text;
                             String phone = _phoneControl.text;

                             if (email != '' && nom!='' && phone != '' && ( pass == confPass )) {
                               _signinAccount(_emailControl.text.trim(), _passwordControl.text);
                             }else{
                               setState(() {
                                 _errMessage = "Veuiller verifier tous les champs.";
                               });
                             }

                          },
                          child: Text("Créer maintenant",style: TextStyle(color: Colors.white),),
                        ),
                        )
                        
           :

            CircularProgressIndicator(),


            _errMessage == "" ? Container() : 

            
            Container(
              margin: EdgeInsets.all(15
              ),
              padding: EdgeInsets.all(20),
              color: Colors.red.shade700,
              child: Text(_errMessage, style: TextStyle(color: Colors.white),),
            ),


            
            
          ],
        ),
        ),
      ),
      
     
    );
  }
}
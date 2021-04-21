import 'package:cofisec/pages/HomePage.dart';
import 'package:cofisec/pages/SignupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SignInPage extends StatefulWidget {



  SignInPage({Key key}) : super(key: key);


  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

TextEditingController _emailControl = new TextEditingController();
TextEditingController _passwordControl = new TextEditingController();

  bool _isLoading = false;
  String _errMessage ="";

  FirebaseAuth auth = FirebaseAuth.instance;


  _signinAccount(String email, String password){

    setState(() {
      _isLoading = ! _isLoading;
      _errMessage="";
    });
    auth.signInWithEmailAndPassword(email: email, password: password).then(( response){
      setState(() {
        _isLoading = ! _isLoading;
      });

      print(response);

         Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
         
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
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text("Authentification",style: TextStyle(color: Color.fromRGBO(33, 35, 82, 1),fontSize: 25,fontWeight: FontWeight.bold),),
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

            _isLoading == false ?

                        Container(
                           padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Color.fromRGBO(33, 35, 82, 1),
                          onPressed: (){
                             _signinAccount(_emailControl.text, _passwordControl.text);
                          },
                          child: Text("Se connecter",style: TextStyle(color: Colors.white),),
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

            Container(
                           padding: EdgeInsets.only(left: 15,right: 15),
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Color.fromRGBO(33, 35, 82, 1),
                          onPressed: (){
                             Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignupPage()),
                                );
                          },
                          child: Text("Créer un compte",style: TextStyle(color: Colors.white),),
                        ),
                        )
            
            
          ],
        ),
      ),
      
     
    );
  }
}
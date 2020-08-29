import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studentselectorflutter/data/event_helper.dart';
// import 'package:studentselectorflutter/data/event_helper.dart' as globals;
import 'main.dart';
import 'data/user.dart' as globals;
import 'package:flutter/material.dart';
  
  
  class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
 
}
  class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
//  String userId;
  String password;
  String username;
  String message = '';
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  //Authentication auth;
  

 final EventsHelper helper = EventsHelper();
Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Login'),),
      body: Container(
        padding: EdgeInsets.all(24),
        child:SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
            children: <Widget>[
              usernameInput(),
              passwordInput(),
              mainButton(),
              validationMessage(),
              
            ],),),),),);
  }
  Widget usernameInput() {
    return Padding(
      padding: EdgeInsets.only(top:120),
      child: TextFormField( 
       controller: txtUsername,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'username',
          icon: Icon(Icons.supervised_user_circle)
        ),
        validator: (text) => text.isEmpty ? 'username is required' :
          null,
      )
    );
  }
  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.only(top:120),
      child: TextFormField(
        controller: txtPassword,
        keyboardType: TextInputType.name,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'password',
          icon: Icon(Icons.enhanced_encryption)
        ),
        validator: (text) => text.isEmpty ? 'Password is required'
        : null,
      )
    );
  }
  
  Widget mainButton() {
    String buttonText =  'Login' ;
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: Container(
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: 
           BorderRadius.circular(20)),
          color: Theme.of(context).accentColor,
          elevation: 3,
          child: Text(buttonText),
          onPressed: () {
            setState(() {
              message = "";
            });
                  if (_formKey.currentState.validate()) { 
                    helper.submitLogin(txtUsername.text, txtPassword.text);
                    helper.getOrganiser(txtUsername.text, txtPassword.text);
                  }
                  print(globals.User.loginResponse);
                  if(globals.User.loginResponse == 200){
                    Navigator.push(context, 
                    
                 MaterialPageRoute(builder: (context) => HomePage()));
                     
                  }
                  else {
                    setState(() {
                    message = "The fields have been filled out incorrectly. Please Try Again.";
                    });
                  }
          
          }
        )
      )
      );
  }

  Widget validationMessage() {
    return Text(message,
      style: TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold),);
  }
  
  

  
}
  
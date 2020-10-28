import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'data/event_helper.dart';
import 'main.dart';

//Creates a Stateful Widget CreateUserScreen
class CreateUserScreen extends StatefulWidget {
  @override
  //seperate state object instantiated to store the mutable state
  _CreateUserScreenState createState() {
    return _CreateUserScreenState();

  } 
}
class _CreateUserScreenState extends State<CreateUserScreen> {
  //Constant Global Key for the form
  final _formKey = GlobalKey<FormState>();
  //Constant Global Key for the scaffold
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String message = '';
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtAdmin = TextEditingController();
  bool admin = false;
  final TextEditingController txtOrganiser = TextEditingController();
  bool organiser = false;
  final TextEditingController txtSubscriber = TextEditingController();
  bool subscriber = false;
  final EventsHelper helper = EventsHelper();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Create User'),),
      body: Container(
        padding: EdgeInsets.all(12),
        child:SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
            children: <Widget>[
              usernameInput(),
              passwordInput(),
              emailInput(),
              isSubscriber(),
              isOrgainser(),
              isAdmin(),
              enterButton(),
              validationMessage(),
            ],),),),),);
  }

  Widget usernameInput() {
    return Padding(
      padding: EdgeInsets.only(top:60),
      child: TextFormField( 
       controller: txtUsername,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Enter Username',
          icon: Icon(Icons.description)
        ),
        //UI input validation
        validator: (text) => text.isEmpty ? 'Username is required' :null,
      )
    );
  }
  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.only(top:60),
      child: TextFormField(
        controller: txtPassword,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Enter Password',
          icon: Icon(Icons.description)
        ),
        validator: (text) => text.isEmpty  ? 'Password is required' : null,
      )
    );
  }
  Widget isOrgainser() {
    return Padding(
      padding: EdgeInsets.only(top:60),
      child: TextFormField(
        controller: txtOrganiser,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Enter Organiser',
          icon: Icon(Icons.description)
        ),
        validator: (text) => text.isEmpty  ? 'Organiser is required' : null,
      )
    );
  }
  Widget isSubscriber() {
    return Padding(
      padding: EdgeInsets.only(top:60),
      child: TextFormField(
        controller: txtSubscriber,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Enter Subscriber',
          icon: Icon(Icons.description)
        ),
        validator: (text) => text.isEmpty  ? 'Subscriber is required' : null,
      )
    );
  }
  Widget isAdmin() {
    return Padding(
      padding: EdgeInsets.only(top:60),
      child: TextFormField(
        controller: txtAdmin,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Enter Admin',
          icon: Icon(Icons.description)
        ),
        validator: (text) => text.isEmpty  ? 'Admin is required' : null,
      )
    );
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.only(top:60),
      child: TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: 'Enter Email',
          icon: Icon(Icons.description)
        ),
        //UI input for email address is validated 
        //using Regular Expression and displays error text 
        validator: PatternValidator(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$', 
        errorText: 'Number of Selections should be greater than 0') 
      )
    );
  }
  
  int responseCode;
  
  Widget enterButton() {
    String buttonText =  'Create User' ;
    
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: Container(
        
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: 
           BorderRadius.circular(20)),
          color: Theme.of(context).accentColor,
          elevation: 3,
          child: Text(buttonText),
          onPressed: () {
                 
                if(txtAdmin.text == "yes"){
                  admin = true;
                }
                if(txtOrganiser.text == "yes"){
                  organiser = true;
                }
                if(txtSubscriber.text == "yes"){
                  subscriber = true;
                }
                //call the validator of the form fields
                //If UI validation is passed call method to create User
                 if (_formKey.currentState.validate()) {
                    helper.createUser(txtUsername.text, txtPassword.text, txtEmail.text, admin, organiser, subscriber);
                }
                //if response from the webservice is HTTP 200
                //then display homepage
                if(responseCode == 200){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => HomePage()));
                }
                //if webservice returns anything other than HTTP 200 response code 
                //then display error message
                else{
                  message = "The fields have been filled out incorrectly";

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

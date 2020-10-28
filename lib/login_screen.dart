import 'package:studentselectorflutter/data/event_helper.dart';
import 'main.dart';
import 'data/user.dart' as globals;
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  //Constant Global Key for the form
  final _formKey = GlobalKey<FormState>();
  //Constand Global Key for the scaffold
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String password;
  String username;
  String message = '';
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  final EventsHelper helper = EventsHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                usernameInput(),
                passwordInput(),
                mainButton(),
                validationMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameInput() {
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: TextFormField(
          controller: txtUsername,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              hintText: 'username', icon: Icon(Icons.supervised_user_circle)),
          //UI input validation
          validator: (text) => text.isEmpty ? 'username is required' : null,
        ));
  }

  Widget passwordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: TextFormField(
          controller: txtPassword,
          keyboardType: TextInputType.name,
          //makes the password unreadable
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'password', icon: Icon(Icons.enhanced_encryption)),
          validator: (text) => text.isEmpty ? 'Password is required' : null,
        ));
  }

  Widget mainButton() {
    String buttonText = 'Login';
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: Container(
            height: 50,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Theme.of(context).accentColor,
                elevation: 3,
                child: Text(buttonText),
                onPressed: () {

                  //set the state of the message
                  setState(() {
                    message = "";
                  });

                  //call the validator of the form fields
                  if (_formKey.currentState.validate()) {
                    //UI validation is passed call webservice to check password in the database
                    helper.submitLogin(txtUsername.text, txtPassword.text);
                    helper.isOrganiser(txtUsername.text, txtPassword.text);
                    helper.isAdmin(txtUsername.text, txtPassword.text);
                  }

                  if (globals.User.loginResponse == 200) {
                    //if response from the webservice is HTTP 200
                    //then display homepage
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    //if webservice returns anything other than HTTP 200 response code 
                    //then display error message
                    setState(() {
                      message =
                          "The fields have been filled out incorrectly. Please Try Again.";
                    });
                  }
                })));
  }

  Widget validationMessage() {
    return Text(
      message,
      style: TextStyle(
          fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}

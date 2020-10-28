import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'data/event_helper.dart';
import 'data/user.dart' as globals;
import 'main.dart';
import 'package:http/http.dart' as http;

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() {
    return _CreateScreenState();
  }
}

class _CreateScreenState extends State<CreateScreen> {
  //Constant Global Key for the form
  final _formKey = GlobalKey<FormState>();
  //Constant Global Key for the scaffold
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String message = '';
  final TextEditingController txtEventTitle = TextEditingController();
  final TextEditingController txtEventDescription = TextEditingController();
  final TextEditingController txtSelectionNum = TextEditingController();
  final EventsHelper helper = EventsHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                titleInput(),
                descriptionInput(),
                selectionNumInput(),
                enterButton(),
                validationMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleInput() {
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: TextFormField(
          controller: txtEventTitle,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              hintText: 'Enter Event Title', icon: Icon(Icons.title)),
          //UI input validation
          validator: (text) => text.isEmpty ? 'Title is required' : null,
        ));
  }

  Widget descriptionInput() {
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: TextFormField(
          controller: txtEventDescription,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              hintText: 'Enter Event Description',
              icon: Icon(Icons.description)),
          validator: (text) => text.isEmpty ? 'Description is required' : null,
        ));
  }

  Widget selectionNumInput() {
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: TextFormField(
            controller: txtSelectionNum,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                hintText: 'Number of Subscribers to Select for Event',
                icon: Icon(Icons.confirmation_number)),
            //UI input is validated using Regular Expression
            //and displays error text           
            validator: PatternValidator(r'^[1-9][0-9]*$',
                errorText: 'Number of Selections should be greater than 0')
            )
        );
  }

  int responseCode;

  Widget enterButton() {
    String buttonText = 'Create Event';

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
                  //call the validator of the form fields
                  //If UI validation is passed call method to create event
                  if (_formKey.currentState.validate()) {
                    createEvent();
                  }
                  //if response from the webservice is HTTP 200
                  //then display homepage
                  if (responseCode == 200) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } 
                  //if webservice returns anything other than HTTP 200 response code 
                  //then display error message
                  else {
                    message = "The fields have been filled out incorrectly";
                  }
                })));
  }

  //Asynchronous method that creates an Event by
  //using HTTP POST method
  Future createEvent() async {
    //Awaits for the response of the HTTP GET request
    //notifies the widget that the state is changing
    setState(() {
      message = "";
    });
    //try catch block to display error if backend cannot be reached
    try {
      var response = await http.post('http://localhost:8080/event',
          headers: <String, String>{'Content-Type': 'application/json'},
          //marshall the json body to be part of HTTP Post
          body: jsonEncode({
            'eventDescription': txtEventDescription.text,
            'eventStatus': true,
            'selectionNum': txtSelectionNum.text,
            'eventTitle': txtEventTitle.text,
            'organiserID': globals.User.userID,
          }));
      responseCode = response.statusCode;
    } 
    //catch the error and set state to display error message
    catch (e) {
      print('Error: $e');
      setState(() {
        message = "Unable to reach the Web Services";
      });
    }
  }

  Widget validationMessage() {
    return Text(
      message,
      style: TextStyle(
          fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}

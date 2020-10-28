import 'package:flutter/material.dart';
import 'package:studentselectorflutter/create_event.dart';
import 'package:studentselectorflutter/createuser_screen.dart';
import 'package:studentselectorflutter/login_screen.dart';
import 'package:studentselectorflutter/organised_screen.dart';
import 'package:studentselectorflutter/subscribedTo.dart';
import 'package:studentselectorflutter/ui.dart';
import './data/event_helper.dart';
import 'data/user.dart' as globals;
import 'subscribedTo.dart';

/// main method is called when the application starts
void main() => runApp(StudentSelectorApp());

/// The first class that is instantiated by the main method
/// builds the app using a constellation of other widgets
class StudentSelectorApp extends StatelessWidget {
  @override

  ///override the build method of the Stateless Widget class
  ///with description of how to display StudentSelectorApp instance
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Selector',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

///Instantiates the HomePage of the student selector App
///Extended from StatefulWidget as the state will change according
///to response from the backend webservices.
class HomePage extends StatefulWidget {
  @override
  //seperate state object instantiated to store the mutable state
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EventsHelper helper;
  List<dynamic> events = List<dynamic>();
  int eventsCount;

  @override
  //Initialise the state of the Stateful Widget
  void initState() {
    if (globals.User.isLogin == true) {
      helper = EventsHelper();
      initialize();
      super.initState();
    }
  }

  //Asynchronous method which awaits to get Events
  //Future represents the result of an asynchronous operation
  Future initialize() async {
    events = await helper.getEvents();
    //notifies the widget that the state is changing
    setState(() {
      eventsCount = events.length;
      events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;

    if (MediaQuery.of(context).size.width < 600) {
      isSmall = true;
    }
    //navigation if logged for various roles
    //admin, organiser, subscriber
    if (globals.User.isLogin == true) {
      //navigation related to organiser
      if (globals.User.isOrganiser == true) {
        return Scaffold(
            //Build the navigation bar
            appBar: AppBar(
              title: Text('Student Selector'),
              actions: <Widget>[
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: (isSmall) ? Icon(Icons.home) : Text('Home')),
                ),
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: (isSmall)
                          ? Icon(Icons.add_circle)
                          : Text('Subscribed')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscribedTo()));
                  },
                ),
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: (isSmall)
                          ? Icon(Icons.add_circle)
                          : Text('Organised')),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Organised()));
                  },
                ),
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: (isSmall) ? Icon(Icons.create) : Text('Create')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateScreen()));
                  },
                ),
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: (isSmall)
                          ? Icon(Icons.home)
                          : Text(
                              "Logged in as: " + globals.User.globalUsername)),
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.all(20),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: (isSmall)
                  //depending on the screen size display a list or a table
                      ? EventsList(events, false)
                      : EventsTable(events, false)),
            ])));
      }
      //navigation related to admin
      else if (globals.User.isAdmin == true) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Student Selector'),
              actions: <Widget>[
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child:
                          (isSmall) ? Icon(Icons.create) : Text('Create User')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateUserScreen()));
                  },
                ),
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: (isSmall)
                          ? Icon(Icons.home)
                          : Text(
                              "Logged in as: " + globals.User.globalUsername)),
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.all(20),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: (isSmall)
                      ? EventsList(events, false)
                      : EventsTable(events, false)),
            ])));
      }
      //navigation related to subscriber
      else {
        return Scaffold(
            appBar: AppBar(title: Text('Student Selector'), actions: <Widget>[
              InkWell(
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: (isSmall) ? Icon(Icons.home) : Text('Home')),
              ),
              InkWell(
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: (isSmall)
                        ? Icon(Icons.add_circle)
                        : Text('Subscribed')),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SubscribedTo()));
                },
              ),
              InkWell(
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: (isSmall)
                        ? Icon(Icons.home)
                        : Text("Logged in as: " + globals.User.globalUsername)),
              ),
            ]),
            body: SingleChildScrollView(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.all(20),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: (isSmall)
                      ? EventsList(events, false)
                      : EventsTable(events, false)),
            ])));
      }
    }
    //navigation if not logged in
    else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Student Selector'),
            actions: <Widget>[
              InkWell(
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: (isSmall) ? Icon(Icons.home) : Text('Home')),
              ),
              InkWell(
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: (isSmall) ? Icon(Icons.tag_faces) : Text('Login')),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              )
            ],
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(children: [
                Text('Welcome to Student Selector. Login to view Events'),
              ]),
            ),
          ])));
    }
  }
}

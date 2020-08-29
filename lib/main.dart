import 'package:flutter/material.dart';
import 'package:studentselectorflutter/create_event.dart';
import 'package:studentselectorflutter/login_screen.dart';
import 'package:studentselectorflutter/organised_screen.dart';
import 'package:studentselectorflutter/subscribedTo.dart';
import 'package:studentselectorflutter/ui.dart';
import './data/event_helper.dart';
import 'data/user.dart' as globals;
import 'subscribedTo.dart';
import 'package:http/http.dart' as http;

void main() => runApp(StudentSelectorApp());

class StudentSelectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Selector',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EventsHelper helper;
  List<dynamic> events = List<dynamic>();
  int eventsCount;

  @override
  void initState() {
    if (globals.User.isLogin == true) {
      helper = EventsHelper();
      initialize();
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;

    if (MediaQuery.of(context).size.width < 600) {
      isSmall = true;
    }
    if (globals.User.isLogin == true) {
      if (globals.User.isOrganiser == true) {
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
                // child: Row(children: [
                //   Text('Search Events'),
                //   Container(
                //       padding: EdgeInsets.all(20),
                //       width: 200,
                //       child: TextField(
                //         controller: txtSearchController,
                //         keyboardType: TextInputType.text,
                //         textInputAction: TextInputAction.search,
                //         onSubmitted: (text) {
                //           helper.getEvents().then((value) {
                //             events = value;
                //             setState(() {
                //               events = events;
                //             });
                //           });
                //         },
                //       )),
                //   Container(
                //       padding: EdgeInsets.all(20),
                //       child: IconButton(
                //           icon: Icon(Icons.search),
                //           onPressed: () =>
                //               helper.getEvents())),
                // ]),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: (isSmall)
                      ? EventsList(events, false)
                      : EventsTable(events, false)),
            ])));
      } else {
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
                // child: Row(children: [
                //   Text('Search Events'),
                //   Container(
                //       padding: EdgeInsets.all(20),
                //       width: 200,
                //       child: TextField(
                //         controller: txtSearchController,
                //         keyboardType: TextInputType.text,
                //         textInputAction: TextInputAction.search,
                //         onSubmitted: (text) {
                //           helper.getEvents().then((value) {
                //             events = value;
                //             setState(() {
                //               events = events;
                //             });
                //           });
                //         },
                //       )),
                //   Container(
                //       padding: EdgeInsets.all(20),
                //       child: IconButton(
                //           icon: Icon(Icons.search),
                //           onPressed: () =>
                //               helper.getEvents())),
                // ]),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: (isSmall)
                      ? EventsList(events, false)
                      : EventsTable(events, false)),
            ])));
      }
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Student Selector'),
            actions: <Widget>[
              InkWell(
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: (isSmall) ? Icon(Icons.home) : Text('Home')),
              ),
              // InkWell(
              //   child: Padding(
              //       padding: EdgeInsets.all(20.0),
              //       child: (isSmall) ? Icon(Icons.add_circle) : Text('Subscribed')),
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => SubscribedTo()));
              //   },
              // ),

              //   InkWell(
              //   child: Padding(
              //       padding: EdgeInsets.all(20.0),
              //       child: (isSmall) ? Icon(Icons.add_circle) : Text('Organised')),
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Organised()));
              //   },
              // ),

              // InkWell(
              //   child: Padding(
              //       padding: EdgeInsets.all(20.0),
              //       child: (isSmall) ? Icon(Icons.create) : Text('Create')),
              //       onTap: () {

              //         Navigator.push(context, MaterialPageRoute(builder: (context) => CreateScreen()));
              //   },
              // ),
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
                //       Container(
                //           padding: EdgeInsets.all(20),
                //           width: 200,
                //           child: TextField(
                //             controller: txtSearchController,
                //             keyboardType: TextInputType.text,
                //             textInputAction: TextInputAction.search,
                //             onSubmitted: (text) {
                //               helper.getEvents().then((value) {
                //                 events = value;
                //                 setState(() {
                //                   events = events;
                //                 });
                //               });
                //             },
                //           )),
                //       Container(
                //           padding: EdgeInsets.all(20),
                //           child: IconButton(
                //               icon: Icon(Icons.search),
                //               onPressed: () =>
                //                   helper.getEvents())),
              ]),
            ),
            //   Padding(
            //       padding: EdgeInsets.all(20),
            //       child: (isSmall)
            //            ? EventsList(events, false )
            //           : EventsTable(events, false)),
          ])));
    }
  }

  Future initialize() async {
    events = await helper.getEvents();
    setState(() {
      eventsCount = events.length;
      events = events;
    });
  }

}

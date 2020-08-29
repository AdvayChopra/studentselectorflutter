import 'package:flutter/material.dart';
import 'ui.dart';
import 'data/user.dart' as globals;
import 'data/event_helper.dart';
import 'main.dart';

class SubscribedTo extends StatefulWidget {
  @override
  _SubscribedScreenState createState() => _SubscribedScreenState();
}

class _SubscribedScreenState extends State<SubscribedTo> {
  EventsHelper helper;
  List<dynamic> events = List<dynamic>();
  int eventsCount;
  
  @override
  void initState() {
    helper = EventsHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;
    if (MediaQuery.of(context).size.width < 700) {
      isSmall = true;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Subscribed Events'),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20.0), 
              child: (isSmall) ? Icon(Icons.home) : Text('Home')),
              onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => HomePage())
              );
            },
            ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20.0), 
              child:(isSmall) ? Icon(Icons.add_circle) : Text('Subscribed')),
            ),
        ],),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Subscribed Events')
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child:  (isSmall) ? EventsList(events, true) : EventsTable(events, true)
        ),

      ],),
      
    );
  }

  Future initialize() async {
   
    events = await helper.getSubscribed(globals.User.userID);
    setState(() {
      eventsCount = events.length;
      events = events;
    });
  }
}
import 'package:flutter/material.dart';
import 'ui.dart';
import 'data/user.dart' as globals;
import 'data/event_helper.dart';
import 'main.dart';

//Creates a Stateful Widget OrganisedScreen
class SubscribedTo extends StatefulWidget {
  @override
  //seperate state object instantiated to store the mutable state
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
  
  //Asynchronous method which awaits to get Subscribed Events
  //Future represents the result of an asynchronous operation
  Future initialize() async {
    events = await helper.getSubscribed(globals.User.userID);
    //notifies the widget that the state is changing
    setState(() {
      eventsCount = events.length;
      events = events;
    });
  }

  @override
  //Initialise the state of the Stateful Widget
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
                //on tap of back button navigate to home page
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
          //depending on the screen size display a list or a table
          child:  (isSmall) ? EventsList(events, true) : EventsTable(events, true)
        ),

      ],),
      
    );
  }
  
  
}
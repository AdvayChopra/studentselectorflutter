import 'package:flutter/material.dart';
import 'package:studentselectorflutter/data/sel_details.dart';
import 'package:studentselectorflutter/selDetails_screen.dart';
import 'package:studentselectorflutter/subscribers_screen.dart';
import 'data/user.dart' as globals;
import 'login_screen.dart';
import 'data/event_helper.dart';
import 'main.dart';

class Organised extends StatefulWidget {
  @override
  _OrganisedScreenState createState() => _OrganisedScreenState();
}

class _OrganisedScreenState extends State<Organised> {
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
      appBar: AppBar(title: Text('Organised Events'),
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
              child:(isSmall) ? Icon(Icons.reorder) : Text('Organised')),
            ),
        ],),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Organised Events')
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child:  (isSmall) ? OrganisedEventsList(events, true) : OrganisedEventsTable(events, true)
        ),

      ],),
      
    );
  }

  Future initialize() async {
  
    events = await helper.getOrganised(globals.User.userID);
    setState(() {
      eventsCount = events.length;
      events = events;
    });
  }
}
class OrganisedEventsTable extends StatelessWidget { 
   final List<dynamic> events;
//   static List<String> columns = <String> ['eventID','eventTitle','selectionNum','eventDescription','action'];
   final bool organised;  

   OrganisedEventsTable(this.events, this.organised);
   final EventsHelper helper = EventsHelper();

   @override 
   Widget build(BuildContext context) { 
    
    
    return Table(
      columnWidths: {
        0: FlexColumnWidth(6),
        1: FlexColumnWidth(5),
        2: FlexColumnWidth(4),
        3: FlexColumnWidth(3),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(0),
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: 
        
        events.map((event) {
        return TableRow(  
          children: [
            TableCell(child:TableText(event.eventID.toString())),
            TableCell(child:TableText(event.eventTitle)),
            TableCell(child:TableText(event.selectionNum.toString())),
            TableCell(child:TableText(event.eventDescription)),
            TableCell( child: IconButton(
                color:  Colors.blue , 
                tooltip: 'View Event Details', 
                icon: Icon(Icons.view_list), 
                onPressed: () {
                     Navigator.push(context, 
                     MaterialPageRoute(builder: (context) => SubscribersScreen(eventID: event.eventID)));

                  
                }
                )
              
            ),
            TableCell(
              child: IconButton(
                color:  Colors.amber , 
                tooltip: (event.eventStatus)?'Start Selection':'View Selection Details', 
                icon: (event.eventStatus)?Icon(Icons.send):Icon(Icons.info), 
                onPressed: () {
                  if(event.eventStatus){  
                    helper.startSelection(event.eventID);
                     Navigator.push(context, 
                     MaterialPageRoute(builder: (context) => SelDetailsScreen(eventID: event.eventID)));
                    } 
                    
                  else{
                    helper.getDetails(event.eventID);
                    if(SelDetails != null){
                        
                      Navigator.push(context, 
                          
                      MaterialPageRoute(builder: (context) => SelDetailsScreen(eventID: event.eventID)));
                    }
                  }
                }
                ))
          ]
        );
      }).toList(),
    );
   } 
}
   class TableText extends StatelessWidget {
    final String text;
    TableText(this.text);

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Text(text, 
          style: TextStyle(color: Theme.of(context).primaryColorDark),),
      );
    }
  }
  class OrganisedEventsList extends StatelessWidget {
  final List<dynamic> events;
  final bool organised; 
 
  OrganisedEventsList(this.events, this.organised);
  final EventsHelper helper = EventsHelper();
  
   @override
  Widget build(BuildContext context) {
    final int eventsCount = events.length;
    print(eventsCount);
    return Container(
      height: MediaQuery.of(context).size.height /1.4,
      child: ListView.builder(
      itemCount: (eventsCount==null) ? 0: eventsCount,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          title: Text(events[position].title),
          subtitle: Text(events[position].authors),
          trailing: IconButton(
                 color:  Colors.amber, 
                tooltip: 'Start Selection', 
                icon: Icon(Icons.star), 
               onPressed: () {
                  if (organised == false) {
                    helper.getOrganised(globals.User.userID);
                  }
              }),
        );
      }));
  }
  
  }
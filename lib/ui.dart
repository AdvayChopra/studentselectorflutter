import 'package:flutter/material.dart';
import 'package:studentselectorflutter/subscribedTo.dart'; 
import 'data/event_helper.dart'; 


class EventsTable extends StatelessWidget { 
  final List<dynamic> events; 
  final bool subscribed;
   
  EventsTable(this.events, this.subscribed); 
   
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
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: 
        events.map((event) {
        return TableRow(  
          children: [
            TableCell(child:TableText(event.eventID.toString())),
            TableCell(child:TableText(event.eventTitle)),
            TableCell(child:TableText(event.eventDescription)),
            TableCell(child:TableText(event.selectionNum.toString())),
            TableCell(
              child: IconButton(
                color: (subscribed) ? Colors.green : Colors.red, 
                tooltip: (subscribed) ? 'Remove from favorites' : 'Add to subscribed', 
                icon: Icon(Icons.star), 
                onPressed: () {
                  if (subscribed == false) {
                    helper.addToSubscribed(event);
                  }
              
              })),

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
  class EventsList extends StatelessWidget {
  final List<dynamic> events;
  final bool subscribed;
   
  
  EventsList(this.events, this.subscribed);
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
                 color: (subscribed) ? Colors.red : Colors.amber, 
                tooltip: (subscribed) ? 'Remove from favorites' : 'Add to favorites', 
                icon: Icon(Icons.star), 
               onPressed: () {
                  if (subscribed == false) {
                    helper.addToSubscribed(events[position]);
                  }
    
              }),
        );
      }));
  }
  
  }




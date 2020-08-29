import 'dart:convert';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:studentselectorflutter/data/event.dart';


import 'package:studentselectorflutter/data/event_helper.dart';
import 'package:studentselectorflutter/data/sel_details.dart';
import 'package:studentselectorflutter/organised_screen.dart';
import 'main.dart';
import 'data/subscription.dart'as globals;
import 'package:flutter/material.dart';
  
  
  class SubscribersScreen extends StatefulWidget {
    final int eventID;
    const SubscribersScreen ({ Key key, this.eventID }): super(key: key);
    @override
    _SubscribersScreenState createState() => _SubscribersScreenState();
    // @override
    // SubscribersTable createState() => SubscribersTable(subscribers);
}
  class _SubscribersScreenState extends State<SubscribersScreen> {
  EventsHelper helper;
  List<dynamic> subscriptions = List<dynamic>();
  int subscriptionsCount;
  
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
      appBar: AppBar(title: Text('Subscribers of The Event'),
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
              child: (isSmall) ? Icon(Icons.home) : Text('Organised')),
              onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => Organised())
              );
            },
            ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20.0), 
              child:(isSmall) ? Icon(Icons.reorder) : Text('Subscribers')),
            ),
        ],),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Subscribers of The Event')
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child:  (isSmall) ? SubscribersList(subscriptions) : SubscribersTable(subscriptions),

        ),

      ],),
      
    );
  }

  Future initialize() async {
  
    subscriptions = await helper.getSubscribers(widget.eventID);
    setState(() {
      subscriptionsCount = subscriptions.length;
      subscriptions = subscriptions;
    });
  }
}
class SubscribersTable extends StatelessWidget { 
   final List<dynamic> subscriptions;
   EventsHelper helper=EventsHelper();
   //final bool organised;  
  // @override
  //   _SubscribersScreenState createState() => _SubscribersScreenState();
   SubscribersTable(this.subscriptions);
   //final EventsHelper helper = EventsHelper();
   TextEditingController txtWeight = TextEditingController();
   @override 
   Widget build(BuildContext context) { 
     
     //int _value = 1;
     GlobalKey _formKey= GlobalKey();
    return Table(
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        // 2: FlexColumnWidth(4),
        // 3: FlexColumnWidth(3),
        // 4: FlexColumnWidth(2),
        // 5: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: 
        subscriptions.map((subscriptions) {
        return TableRow(  
          children: [
            TableCell(child:TableText(subscriptions.username)),
            TableCell(child:TextFormField(
              key: _formKey,
              controller: txtWeight,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
              hintText: 'Weight of Student',
              icon: Icon(Icons.confirmation_number)
                ),  
              validator: PatternValidator(r'^[1-2]*$', errorText: 'Weight can either be 1 or 2'),
              // onChanged: (txtWeight){
              //   //_formKey.currentState.validate();
              //   helper.submitWeight(txtWeight);
              //   },
            )),

            // TableCell(child:DropdownButton(
            //   value: _value,
            //   items: [
            //     DropdownMenuItem(
            //       child: Text("1"),
            //       value: 1,
            //     ),
            //     DropdownMenuItem(
            //       child: Text("2"),
            //       value: _value = 2,
            //     ),
            //   ],
            //   onChanged: (value) {
            //   setState((){_value = value;});
                
              
             
            //   }
            //  ),
            //  ),
            TableCell(child: submitButton())
          ]
        );
      }).toList(),
      
    );
    
   } 
    Widget submitButton(){
    String buttonText =  'Save Weights' ;
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Container(
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: 
           BorderRadius.circular(20)),
          color: Colors.blueGrey,
          elevation: 3,
          child: Text(buttonText),
          onPressed: () {
                
            helper.submitWeight(globals.Subscription.globalEventID, txtWeight.text);
                 
          }
        )
      )
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
  class SubscribersList extends StatelessWidget {
  final List<dynamic> subscribers;
 // final bool organised; 
 
  SubscribersList(this.subscribers);
  //final EventsHelper helper = EventsHelper();
  
   @override
  Widget build(BuildContext context) {
    final int subscribersCount = subscribers.length;
    print(subscribersCount);
    return Container(
      height: MediaQuery.of(context).size.height /1.4,
      child: ListView.builder(
      itemCount: (subscribersCount==null) ? 0: subscribersCount,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          title: Text(subscribers[position].username),
        );
      }));
  }


  
  
}
  
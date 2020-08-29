import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studentselectorflutter/data/event_helper.dart';
import 'package:studentselectorflutter/data/sel_details.dart';
import 'package:studentselectorflutter/organised_screen.dart';
import 'main.dart';
import 'data/user.dart';
import 'package:flutter/material.dart';
  
  
  class SelDetailsScreen extends StatefulWidget {
    final int eventID;
    const SelDetailsScreen ({ Key key, this.eventID }): super(key: key);
  @override
  _SelDetailsScreenState createState() => _SelDetailsScreenState();

 
}
  class _SelDetailsScreenState extends State<SelDetailsScreen> {
  EventsHelper helper;
  List<dynamic> selDetails = List<dynamic>();
  int selDetailCount;
  
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
      appBar: AppBar(title: Text('Selection Details'),
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
              child:(isSmall) ? Icon(Icons.reorder) : Text('Details')),
            ),
        ],),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Selection Details')
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child:  (isSmall) ? SelectedDetailsList(selDetails) : SelectedDetailsTable(selDetails)
        ),

      ],),
      
    );
  }

  Future initialize() async {
  
    selDetails = await helper.getDetails(widget.eventID);
    setState(() {
      selDetailCount = selDetails.length;
      selDetails = selDetails;
    });
  }
}
class SelectedDetailsTable extends StatelessWidget { 
   final List<dynamic> selDetails;
   //final bool organised;  

   SelectedDetailsTable(this.selDetails);
   //final EventsHelper helper = EventsHelper();

   @override 
   Widget build(BuildContext context) { 
     
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
        // 1: FlexColumnWidth(5),
        // 2: FlexColumnWidth(4),
        // 3: FlexColumnWidth(3),
        // 4: FlexColumnWidth(2),
        // 5: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: 
        selDetails.map((selDetail) {
        return TableRow(  
          children: [
            TableCell(child:TableText(selDetail.username),
            // TableCell(child:TableText(event.eventTitle)),
            // TableCell(child:TableText(event.selectionNum.toString())),
            // TableCell(child:TableText(event.eventDescription)),
            // TableCell(
            //   child: IconButton(
            //     color:  Colors.amber , 
            //     tooltip: 'Start Selection', 
            //     icon: Icon(Icons.send), 
            //     onPressed: () {
                  
            //         helper.startSelection(event.eventID);
                  
//                 
            //  })
            )
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
  class SelectedDetailsList extends StatelessWidget {
  final List<dynamic> selDetails;
 // final bool organised; 
 
  SelectedDetailsList(this.selDetails);
  //final EventsHelper helper = EventsHelper();
  
   @override
  Widget build(BuildContext context) {
    final int selDetailsCount = selDetails.length;
    print(selDetailsCount);
    return Container(
      height: MediaQuery.of(context).size.height /1.4,
      child: ListView.builder(
      itemCount: (selDetailsCount==null) ? 0: selDetailsCount,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          title: Text(selDetails[position].username),
          // subtitle: Text(selDetails[position].authors),
          // trailing: IconButton(
          //        color:  Colors.amber, 
          //       tooltip: 'Start Selection', 
          //       icon: Icon(Icons.star), 
          //      onPressed: () {
          //         if (organised == false) {
          //           helper.getOrganised(globals.User.userID);
          //         }
          //     }),
        );
      }));
  }
  
  
}
  
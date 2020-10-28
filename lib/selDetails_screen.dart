import 'package:studentselectorflutter/data/event_helper.dart';
import 'package:studentselectorflutter/organised_screen.dart';
import 'main.dart';
import 'package:flutter/material.dart';

//Creates a Stateful Widget for Selection Details Screen
class SelDetailsScreen extends StatefulWidget {
  final int eventID;
  const SelDetailsScreen({Key key, this.eventID}) : super(key: key);
  @override
  //seperate state object instantiated to store the mutable state
  _SelDetailsScreenState createState() => _SelDetailsScreenState();
}

class _SelDetailsScreenState extends State<SelDetailsScreen> {
  EventsHelper helper;
  List<dynamic> selDetails = List<dynamic>();
  int selDetailCount;

  @override
  //Initialise the state of the Stateful Widget
  void initState() {
    helper = EventsHelper();
    initialize();
    super.initState();
  }

  //Asynchronous method which awaits to get Selection Details
  //Future represents the result of an asynchronous operation
  Future initialize() async {
    selDetails = await helper.getDetails(widget.eventID);
    //notifies the widget that the state is changing
    setState(() {
      selDetailCount = selDetails.length;
      selDetails = selDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;
    if (MediaQuery.of(context).size.width < 700) {
      isSmall = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Selection Details'),
        actions: <Widget>[
          InkWell(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: (isSmall) ? Icon(Icons.home) : Text('Home')),
            onTap: () {
              //on tap of back button navigate to home page
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          InkWell(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: (isSmall) ? Icon(Icons.home) : Text('Organised')),
            onTap: () {
              //on tap of back button navigate to organised screen
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Organised()));
            },
          ),
          InkWell(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: (isSmall) ? Icon(Icons.reorder) : Text('Details')),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20), child: Text('Selection Details')),
          Padding(
              padding: EdgeInsets.all(20),
              child: (isSmall)
                  ? SelectedDetailsList(selDetails)
                  : SelectedDetailsTable(selDetails)),
        ],
      ),
    );
  }
}

class SelectedDetailsTable extends StatelessWidget {
  final List<dynamic> selDetails;

  SelectedDetailsTable(this.selDetails);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: selDetails.map((selDetail) {
        return TableRow(children: [
          TableCell(
            child: TableText(selDetail.username),
          )
        ]);
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
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).primaryColorDark),
      ),
    );
  }
}

//Display Stateless Widget in List format
class SelectedDetailsList extends StatelessWidget {
  final List<dynamic> selDetails;

  SelectedDetailsList(this.selDetails);

  @override
  Widget build(BuildContext context) {
    final int selDetailsCount = selDetails.length;
    print(selDetailsCount);
    return Container(
        height: MediaQuery.of(context).size.height / 1.4,
        child: ListView.builder(
            itemCount: (selDetailsCount == null) ? 0 : selDetailsCount,
            itemBuilder: (BuildContext context, int position) {
              return ListTile(
                title: Text(selDetails[position].username),
              );
            }));
  }
}

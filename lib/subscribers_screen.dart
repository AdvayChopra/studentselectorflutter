import 'package:form_field_validator/form_field_validator.dart';
import 'package:studentselectorflutter/data/event_helper.dart';
import 'package:studentselectorflutter/organised_screen.dart';
import 'main.dart';
import 'data/subscription.dart' as globals;
import 'package:flutter/material.dart';

//Creates a Stateful Widget OrganisedScreen
class SubscribersScreen extends StatefulWidget {
  final int eventID;
  const SubscribersScreen({Key key, this.eventID}) : super(key: key);
  @override
  //seperate state object instantiated to store the mutable state
  _SubscribersScreenState createState() => _SubscribersScreenState();
}

class _SubscribersScreenState extends State<SubscribersScreen> {
  EventsHelper helper;
  List<dynamic> subscriptions = List<dynamic>();
  int subscriptionsCount;

  @override
  //Initialise the state of the Stateful Widget
  void initState() {
    helper = EventsHelper();
    initialize();
    super.initState();
  }

  //Asynchronous method which awaits to get Subscribers
  //Future represents the result of an asynchronous operation
  Future initialize() async {
    subscriptions = await helper.geWeightings(widget.eventID);
    //notifies the widget that the state is changing
    setState(() {
      subscriptionsCount = subscriptions.length;
      subscriptions = subscriptions;
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
        title: Text('Subscribers of The Event'),
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
                child: (isSmall) ? Icon(Icons.reorder) : Text('Subscribers')),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: Text('Subscribers of The Event')),
          Padding(
            padding: EdgeInsets.all(20),
            child: (isSmall)
                ? SubscribersList(subscriptions)
                : SubscribersTable(subscriptions),
          ),
        ],
      ),
    );
  }
}

class SubscribersTable extends StatelessWidget {
  final List<dynamic> subscriptions;
  final EventsHelper helper = EventsHelper();
  SubscribersTable(this.subscriptions);

  @override
  Widget build(BuildContext context) {
    TextEditingController txtWeight = TextEditingController();
    return Table(
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: subscriptions.map((subscriptions) {
        return TableRow(children: [
          TableCell(child: TableText(subscriptions.username)),
          TableCell(child: TableText(subscriptions.weight.toString())),
          TableCell(child: weight1()),
          TableCell(child: weight2()),
        ]);
      }).toList(),
    );
  }

  Widget weight1() {
    String buttonText = 'Weight 1';
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Container(
            height: 50,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.blueGrey,
                elevation: 3,
                child: Text(buttonText),
                onPressed: () {
                  //on Press call webservice to submit weight for an event
                  helper.submitWeight(globals.Subscription.globalEventID, 1);
                })));
  }

  Widget weight2() {
    String buttonText = 'Weight 2';
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Container(
            height: 50,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.blueGrey,
                elevation: 3,
                child: Text(buttonText),
                onPressed: () {
                  //on Press call webservice to submit weight for an event
                  helper.submitWeight(globals.Subscription.globalEventID, 2);
                })));
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
class SubscribersList extends StatelessWidget {
  final List<dynamic> subscribers;
  SubscribersList(this.subscribers);
  @override
  Widget build(BuildContext context) {
    final int subscribersCount = subscribers.length;
    print(subscribersCount);
    return Container(
        height: MediaQuery.of(context).size.height / 1.4,
        child: ListView.builder(
            itemCount: (subscribersCount == null) ? 0 : subscribersCount,
            itemBuilder: (BuildContext context, int position) {
              return ListTile(
                title: Text(subscribers[position].username),
              );
            }));
  }
}

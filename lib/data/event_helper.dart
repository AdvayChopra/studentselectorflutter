import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:studentselectorflutter/data/event.dart';
import 'package:studentselectorflutter/data/sel_details.dart';
import 'package:studentselectorflutter/data/subscription.dart';
import 'package:studentselectorflutter/data/subscription.dart' as globals;
import 'event.dart';
import 'user.dart' as globals;

///Helper class which calls all Webservices from the UI
///using http.dart library/package
class EventsHelper {
  //Asynchronous method that returns a dynamic list of events
  Future<List<dynamic>> getEvents() async {
    final String url = 'http://localhost:8080/events';
    //Awaits for the response of the HTTP GET request
    Response result = await http.get(url);
    //If HTTP Response status code is 200
    //then unmarshall json response to Event object
    // and return it
    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);

      final events = <Event>[];
      for (var item in jsonResponse) {
        final event = Event(
          item['eventID'],
          item['organiserID'],
          item['selectionNum'],
          item['eventTitle'],
          item['eventDescription'],
          item['eventStatus'],
        );
        if (item['eventStatus'] == true) {
          events.add(event);
        }
      }

      return events;
    } else {
      return null;
    }
  }

  //Asynchronous method that returns a dynamic list of events
  Future<List<dynamic>> getSubscribed(int userID) async {
    String base = "http://localhost:8080/eventByUserID/";
    String query = userID.toString();
    String url = base + query;
    //Awaits for the response of the HTTP GET request
    var response = await http.get(url);
    //If HTTP Response status code is 200
    //then unmarshall json response to Event object
    // and return it
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final events = <Event>[];
      for (var item in jsonResponse) {
        final event = Event(
          item['eventID'],
          item['organiserID'],
          item['selectionNum'],
          item['eventTitle'],
          item['eventDescription'],
          item['eventStatus'],
        );
        if (item['eventStatus'] == true) events.add(event);
      }

      return events;
    } else {
      return null;
    }
  }

  //Asynchronous method that returns a dynamic list of events
  Future<List<dynamic>> getOrganised(int userID) async {
    String base = "http://localhost:8080/eventByOrganiserID/";
    String query = userID.toString();
    String url = base + query;
    //Awaits for the response of the HTTP GET request
    var response = await http.get(url);
    //If HTTP Response status code is 200
    //then unmarshall json response to Event object
    // and return it

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final events = <Event>[];
      for (var item in jsonResponse) {
        final event = Event(
          item['eventID'],
          item['organiserID'],
          item['selectionNum'],
          item['eventTitle'],
          item['eventDescription'],
          item['eventStatus'],
        );
        events.add(event);
      }

      return events;
    } else {
      return null;
    }
  }

  //Asynchronous method that adds a subscription by
  //using HTTP POST method
  Future addToSubscribed(Event event) async {
    //Awaits for the response of the HTTP POST request
    await http.post('http://localhost:8080/subscription',
        headers: <String, String>{'Content-Type': 'application/json'},
        //marshall the json body to be part of HTTP Post
        body: jsonEncode(<String, int>{
          'eventID': event.eventID,
          'userID': globals.User.userID,
          'weight': 1
        }));
  }

  //Asynchronous method that submits a login by
  //using HTTP POST method
  Future submitLogin(String username, String password) async {
    //Awaits for the response of the HTTP POST request
    var response = await http.post('http://localhost:8080/login',
        headers: <String, String>{'Content-Type': 'application/json'},
        //marshall the json body to be part of HTTP Post
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));

    var userID = int.parse(response.body);
    //set the user details as global variables
    globals.User.globalUsername = username;
    globals.User.userID = userID;
    globals.User.loginResponse = response.statusCode;
    if (response.statusCode == 200) {
      globals.User.isLogin = true;
    }
  }

  //Asynchronous method that submits weights by
  //using HTTP POST method
  Future submitWeight(int eventID, int weight) async {
    //Awaits for the response of the HTTP POST request
    await http.post('http://localhost:8080/updateWeight',
        headers: <String, String>{'Content-Type': 'application/json'},
        //marshall the json body to be part of HTTP Post
        body: jsonEncode(<String, int>{
          'eventID': eventID,
          'weight': weight,
          'userID': globals.User.userID
        }));
  }

  //Asynchronous method that verifies if organiser by
  //using HTTP POST method
  Future isOrganiser(String username, String password) async {
    String url = "http://localhost:8080/getOrganiser";
    //Awaits for the response of the HTTP POST request
    var response = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        //marshall the json body to be part of HTTP Post
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));
    bool b = response.body == 'true';
    //set global variable if the user is an Organiser
    globals.User.isOrganiser = b;
  }

  //Asynchronous method that creates user by
  //using HTTP POST method
  Future createUser(String username, String password, String email, bool admin,
      bool organiser, bool subscriber) async {
      //Awaits for the response of the HTTP POST request
      await http.post("http://localhost:8080/user",
        headers: <String, String>{'Content-Type': 'application/json'},
        //marshall the json body to be part of HTTP Post
        body: jsonEncode({
          'username': username,
          'password': password,
          'email ': email,
          'admin': admin,
          'organiser': organiser,
          'subscirber': subscriber
        }));
  }

  //Asynchronous method that verifies if admin by
  //using HTTP POST method
  Future isAdmin(String username, String password) async {
    String url = "http://localhost:8080/getAdmin";
    //Awaits for the response of the HTTP POST request
    var response = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        //marshall the json body to be part of HTTP Post
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));

    bool b = response.body == 'true';
    globals.User.isAdmin = b;
  }

  //Asynchronous method that starts the selection process
  Future startSelection(int eventID) async {
    String base = "http://localhost:8080/selector/";
    String query = eventID.toString();
    String url = base + query;
    //Awaits for the response of the HTTP GET request
    await http.get(url);
  }

  //Asynchronous method that returns a dynamic list 
  //of Selection Details usernames
  Future getDetails(int eventID) async {
    String base = "http://localhost:8080/selectedUsersByEventID/";
    String query = eventID.toString();
    String url = base + query;
    //Awaits for the response of the HTTP GET request
    var response = await http.get(url);
    //If HTTP Response status code is 200
    //then unmarshall json response to Event object
    // and return it
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final selDetails = <SelDetails>[];
      for (var item in jsonResponse) {
        final selDetail = SelDetails(
          item['username'],
        );
        selDetails.add(selDetail);
      }

      return selDetails;
    } else {
      return null;
    }
  }

  //Asynchronous method that returns a dynamic list of Subscription
  Future getSubscribers(int eventID) async {
    globals.Subscription.globalEventID = eventID;
    String base = "http://localhost:8080/subscribedUsersByEventID/";
    String query = eventID.toString();
    String url = base + query;
    //Awaits for the response of the HTTP GET request
    var response = await http.get(url);
    //If HTTP Response status code is 200
    //then unmarshall json response to Event object
    // and return it
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final subscriptions = <Subscription>[];
      for (var item in jsonResponse) {
        final subscription = Subscription(item['username'], item['weight']);
        subscriptions.add(subscription);
      }

      return subscriptions;
    } else {
      return null;
    }
  }

  //Asynchronous method that returns a dynamic list of weightings
  Future geWeightings(int eventID) async {
    globals.Subscription.globalEventID = eventID;
    String base = "http://localhost:8080/subscriptionWeightingsByEventID/";
    String query = eventID.toString();
    String url = base + query;
    //Awaits for the response of the HTTP GET request
    var response = await http.get(url);
    //If HTTP Response status code is 200
    //then unmarshall json response to Event object
    // and return it
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final subscriptions = <Subscription>[];
      for (var item in jsonResponse) {
        final subscription = Subscription(item['username'], item['weight']);
        subscriptions.add(subscription);
      }

      return subscriptions;
    } else {
      return null;
    }
  }
}

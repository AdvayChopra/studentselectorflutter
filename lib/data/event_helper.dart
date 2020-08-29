import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentselectorflutter/data/event.dart';
import 'package:studentselectorflutter/data/sel_details.dart';
import 'package:studentselectorflutter/data/subscription.dart';
import 'package:studentselectorflutter/data/subscription.dart' as globals;
import '../subscribedTo.dart';
import 'event.dart';
import 'user.dart' as globals;

class EventsHelper {
  Future<List<dynamic>> getEvents() async {
    final String url = 'http://localhost:8080/events';

    Response result = await http.get(url);
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

  Future<List<dynamic>> getSubscribed(int userID) async {
    String base = "http://localhost:8080/eventByUserID/";
    String query = userID.toString();
    String url = base + query;
    var response = await http.get(url);

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
        if(item['eventStatus']==true)
          events.add(event);
      }

      return events;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> getOrganised(int userID) async {
    String base = "http://localhost:8080/eventByOrganiserID/";
    String query = userID.toString();
    String url = base + query;
    var response = await http.get(url);

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
        events.add(event);
      }

      return events;
    } else {
      return null;
    }
  }

  Future addToSubscribed(Event event) async {

    print(globals.User.userID);
    var response = await http.post('http://localhost:8080/subscription',
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, int>{
          'eventID': event.eventID,
          'userID': globals.User.userID,
          // 'selected': false,
           'weight': 1
        }));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  // Future removeFromSubscribed(Event event) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String id = preferences.getString(event.eventID.toString());
  //   if (id != '') {
  //     await preferences.setString(
  //         event.eventID.toString(), json.encode(event.toJson()));
  //   }

  //   // var response = await http.delete(
  //   //   'http://localhost:8080/subscriptionByID/' + event.eventID.toString(),
  //   // );
  // }

  Future submitLogin(String username, String password) async {
    var response = await http.post('http://localhost:8080/login',
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var userID = int.parse(response.body);
    
    globals.User.globalUsername = username;
    globals.User.userID = userID;
    globals.User.loginResponse = response.statusCode;
    if (response.statusCode == 200) {
      globals.User.isLogin = true;
    }
    
  }
  
  Future submitWeight(int eventID, String weightString) async {
    
    int weight = int.parse(weightString);
    var response = await http.post('http://localhost:8080/updateWeight',
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
          <String, int>
            {'eventID':eventID, 'weight': weight, 'userID':globals.User.userID}));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future getOrganiser(String username, String password) async{
    var response = await http.post("http://localhost:8080/getUser",
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));

    String str = response.body;
    bool b = str == "true";
    globals.User.isOrganiser = b;
  }

  Future startSelection(int eventID) async {
    String base = "http://localhost:8080/selector/";
    String query = eventID.toString();
    String url = base + query;
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future getDetails(int eventID) async {
    
    String base = "http://localhost:8080/selectedUsersByEventID/";
    String query = eventID.toString();
    String url = base + query;
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
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
  
  
  Future getSubscribers(int eventID) async {
    globals.Subscription.globalEventID = eventID;
    String base = "http://localhost:8080/subscribedUsersByEventID/";
    String query = eventID.toString();
    String url = base + query;
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final subscriptions = <Subscription>[];
      for (var item in jsonResponse) {
        final subscription = Subscription(
          item['username'],
          item[eventID]
          
        );
        subscriptions.add(subscription);
      }

      return subscriptions;
    } else {
      return null;
    }
  }

//  Future removeFromSubscribed(Event event, BuildContext context) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String id = preferences.getString(event.eventID.toString());
//     if (id != '') {
//       await preferences.remove(event.eventID.toString());
//        events.remove(event);
//       Navigator.push(context, MaterialPageRoute(builder: (context)=> _SubscribedScreenState.);

//     }
//   }

}

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentselectorflutter/data/event.dart';
import '../subscribedTo.dart';
import 'event.dart';

class SubscribeHelper {

 /* Future<List<dynamic>> getEvents() async {

    final String url = 'localhost:8080/user'; 
    
    Response result = await http.get(url);
    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
//      final eventsMap = jsonResponse[0];
      final user = <Event>[];
      for( var item in jsonResponse){
        final event = Event(
        item['userID'],
        );
        user.add(event);
      }
     // List<dynamic> events = eventsMap.map((i) => Event.fromJson(i)).toList();
      return user;
    }
    else {
      return null;
    }
        final String url = "localhost:8080/subscription";
    //COME BACK HERE
    
    Response result = await http.post(url);
    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
    Future<http.Response> postSubscription(Event event) {
  
}
  }

*/


}
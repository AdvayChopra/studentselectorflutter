///model class for Event
class Event {
  int eventID;
  int organiserID;
  int selectionNum;
  String eventTitle;
  String eventDescription;
  bool eventStatus;

  Event(this.eventID, this.organiserID, this.selectionNum, this.eventTitle,
      this.eventDescription, this.eventStatus);

//method to marshall dart object Event to JSON-JavaScript Object Notation
  Map<String, dynamic> toJson() {
    return {
      "eventID": eventID,
      "organiserID": organiserID,
      "selectionNum": selectionNum,
      "eventTitle": eventTitle,
      "eventDescription": eventDescription,
      "eventStatus": eventStatus
    };
  }

//method to unmarshall a JSON string to dart object Event
  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    final int eventID = parsedJson['eventID'];
    final int organiserID = parsedJson['organiserID'];
    final int selectionNum = parsedJson['selectionNum'];
    final String eventTitle = parsedJson['eventTitle'];
    final String eventDescription = parsedJson['eventDescription'];
    final bool eventStatus = parsedJson['eventStatus'];
    return Event(eventID, organiserID, selectionNum, eventTitle,
        eventDescription, eventStatus);
  }
}

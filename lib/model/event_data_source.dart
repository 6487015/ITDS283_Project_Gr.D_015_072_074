//ref: HeyFlutter․com https://youtu.be/LoDtxRkGDTw
import 'package:flutter/animation.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_application_1/model/event.dart';

class EventDataSource extends CalendarDataSource {
   EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) {
    return getEvent(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return getEvent(index).to;
  }

  @override
  String getSubject(int index) {
    return getEvent(index).addEvents;
  }

  @override
   Color getColor(int index) {
   return getEvent(index).backgroundColor;
 }

}
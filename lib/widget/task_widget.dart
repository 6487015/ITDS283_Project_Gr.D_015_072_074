//ref: HeyFlutter․com https://youtu.be/LoDtxRkGDTw
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_application_1/model/event_data_source.dart';
import 'package:flutter_application_1/page/event_viewing_page.dart';
import 'package:flutter_application_1/provider/event_provider.dart';


class TaskWidget extends StatefulWidget {
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return 
       SfCalendar(
        view: CalendarView.timelineDay,
        timeSlotViewSettings:
          const TimeSlotViewSettings(timeInterval: Duration(hours: 2)),/*กำหนดให้ event มองเห็นแบบย่อในเวลา 2 ชม.*/
        dataSource: EventDataSource(provider.events), 
        initialDisplayDate: provider.selectedDate,
        appointmentBuilder: appointmentBuilder,
        headerHeight: 40,
        todayHighlightColor: Colors.black,
        selectionDecoration: BoxDecoration(//เมื่อทำการเลือกกล่องแล้วจะเป็นสีดำอ่อนๆ
          color: Colors.black.withOpacity(0.3), //Colors.tranaparent
        ),/**/
        onTap: (details) {
          if (details.appointments == null) return;

          final event = details.appointments!.first;
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => EventViewingPage(event: event))));
        },
      );
    
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
          color: event.backgroundColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Text(
          event.addEvents,
          maxLines: 2, // max line กำหนดให้มี 2 บรรทัด
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


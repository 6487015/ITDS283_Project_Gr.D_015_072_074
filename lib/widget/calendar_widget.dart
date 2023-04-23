//ref: HeyFlutter․com https://youtu.be/LoDtxRkGDTw
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/task_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_application_1/model/event_data_source.dart';
import 'package:flutter_application_1/provider/event_provider.dart';
import 'package:flutter_application_1/model/event.dart';


class CalendarWidget extends StatelessWidget {
  final List<Event> events;
  final Function(Event) deleteEvent;
  final Function(Event) addEvent;
  final Function(Event) updateEvent;

  const CalendarWidget({
    Key? key,
    required this.events,
    required this.deleteEvent,
    required this.addEvent,
    required this.updateEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: CalendarView.month,
      monthViewSettings: const MonthViewSettings(
            showAgenda: true, //แสดง event ข้างล่าง
            agendaViewHeight: 150,//ความสูงของปฏิทิน
            agendaItemHeight: 60,//ความสูงของกล่อง event ข้างล่าง
            
          ),
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      onTap: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(details.date!);//ต้องเลือก date ด้วย
        showModalBottomSheet(
          context: context,
          builder: (context) => TaskWidget(),
        );
      },
    );
  }
}

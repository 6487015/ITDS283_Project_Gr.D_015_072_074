//ref: HeyFlutter․com https://youtu.be/LoDtxRkGDTw
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/model/event.dart';
import 'package:flutter_application_1/provider/event_provider.dart';
import 'package:flutter_application_1/page/event_edit_page.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 236, 131, 166),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: buildViewingActions(context, event),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30), //const = กำหนดให้ค่าคงที่ไม่เปลี่ยนแปลง
        children: <Widget>[
          buildDateTime(event),
          const SizedBox(height: 30),
          TextFormField(
            initialValue: event.addEvents,
            readOnly: true, //ไม่สามารถกดเพื่อแก้ไขได้
            decoration: const InputDecoration(
              icon: Icon(Icons.list_alt),
              labelText: 'Add Event',
              labelStyle: TextStyle(
                color: Color(0xFF6200EE),
              ),
              //border: OutlineInputBorder(),
              enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6200EE)),
              ),/**/
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            initialValue: event.description,
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              labelText: 'Description',
              labelStyle: TextStyle(
                color: Color(0xFF6200EE),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6200EE)),
              ),/**/
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Event event) {
    return [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EventEditingPage(event: event),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          final provider = Provider.of<EventProvider>(context, listen: false);

          provider.deleteEvent(event);
          Navigator.of(context).pop();
        },
      )
    ];
  }

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate('From', event.from),
        buildDate('To', event.to),
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          date.toString(), //แปลง date ให้เป็น string จะได้ string ออกมาเป็น "2022-01-15 10:30:00.000"
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

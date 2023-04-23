import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'Bottombar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/widget/calendar_widget.dart';
import 'package:flutter_application_1/page/event_edit_page.dart';
import 'package:flutter_application_1/provider/event_provider.dart';
import 'package:provider/provider.dart';


class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar App'),
        backgroundColor: Color.fromARGB(255, 236, 131, 166),
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          return CalendarWidget(
            events: eventProvider.eventsOfSelectedDate,
            deleteEvent: eventProvider.deleteEvent,
            addEvent: eventProvider.addEvent,
            updateEvent: eventProvider.updateEvent,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 236, 131, 166),
        child: const Icon(Icons.add, color: Colors.yellow,),
        onPressed:() {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: ((context) =>  EventEditingPage()),
            ),
          );
        }    
      ),
    );
  }
}

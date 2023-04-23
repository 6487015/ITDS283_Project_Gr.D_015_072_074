//ref: HeyFlutter․com https://youtu.be/LoDtxRkGDTw
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/model/event_data_source.dart';


class EventProvider extends ChangeNotifier {
  final List<Event> _events = []; // สร้าง list สำหรับเก็บ events
 
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  List<Event> get events => _events; // getter สำหรับ events

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;
  

  List<Event> get eventsOfSelectedDate => //calculate all the events of a specific date if we click this date it also should only the events of this date
      _events.where((event) => event.from.isAtSameMomentAs(selectedDate) || (event.to != null && event.to.isAtSameMomentAs(selectedDate))).toList();



  void addEvent(Event event) {
    if (_firebaseAuth.currentUser != null) {
      final userDocRef =
          _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid);
      final taskCollectionRef = userDocRef.collection('calendar');

      taskCollectionRef.add({
        'addEvents': event.addEvents,
        'description': event.description,
        'from': event.from,
        'to': event.to,
        'completed': false,
        'createdAt': DateTime.now(),
      }).then((docRef) {
        event.id = docRef.id;
        _events.add(event);// เพิ่ม event เข้าไปใน list
        notifyListeners();// แจ้งเตือน Consumer ว่ามีการเปลี่ยนแปลง state
      });
    }
  }

 void editEvent(Event newEvent, Event oldEvent) async {
    notifyListeners();

    final index = _events.indexWhere((e) => e.id == oldEvent.id);
    if (index >= 0) {
      _events[index] = newEvent;// อัพเดท event ที่ตรงกับ id ใน list
      notifyListeners();
    }

    // Update the event in the database
    await _db
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('calendar')
        .doc(oldEvent.id)//เปลี่ยนข้อมูลเก่า ถ้าใช้ newEvent.id จะไม่มีข้อมูลให้เปลี่ยน
        .update({
      'addEvents': newEvent.addEvents,
      'description': newEvent.description,
      'from': newEvent.from,
      'to': newEvent.to,
    });
  }

 void deleteEvent(Event event) {
  if (_firebaseAuth.currentUser != null) {
    final userDocRef =
        _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid);
    final taskCollectionRef = userDocRef.collection('calendar');

    _events.removeWhere((e) => e.id == event.id); // ลบ event ที่ตรงกับ id ออกจาก list
    final docRef = taskCollectionRef.doc(event.id);
    docRef.delete().then((_) {
      notifyListeners();
    }).catchError((error) {
      print('Error deleting event: $error');

    taskCollectionRef
        .doc(event.id) // อ้างอิงไปยังเอกสารที่ต้องการลบโดยใช้ id
        .delete()
        .then((_) {
      notifyListeners();
    });
  });
} /**/
}


  void updateEvent(Event event) async {
    // Update the local copy of the event
    int index = _events.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      _events[index] = event;// อัพเดท event ที่ตรงกับ id ใน list
      notifyListeners();
    }

    // Update the event in the database
    await _db
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('calendar')
        .doc(event.id)
        .update({
      'addEvents': event.addEvents,
      'description': event.description,
      'from': event.from,
      'to': event.to,
    });
  }
}


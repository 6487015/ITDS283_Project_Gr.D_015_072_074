//ref: HeyFlutter․com https://youtu.be/LoDtxRkGDTw
import 'package:flutter/material.dart';

class Event {
  String? id;
  String? get eventId => id;
  set eventId(String? value) => id = value;


  final String addEvents;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;

  Event({
    required this.addEvents,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.pink,
  });
}
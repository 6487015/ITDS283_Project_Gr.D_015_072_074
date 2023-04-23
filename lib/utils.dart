//ref: HeyFlutter․com https://youtu.be/LoDtxRkGDTw
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat("yMMMMd").format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String  toDate(DateTime dateTime) {
    final date = DateFormat("yMMMMd").format(dateTime);

    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);

    return '$time';
  }

  static DateTime removeTime(DateTime dateTime){
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
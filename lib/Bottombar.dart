import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'calendar_page.dart';
import 'Todolist.dart';
import 'logout_page.dart';
import 'package:intl/intl.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {

  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  final screen = [
    HomePage(),
    Calendar(),
    TodoList(),
    LogoutPage()

  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget> [
      Icon(Icons.mood_outlined, size: 30),
      Icon(Icons.calendar_month_rounded, size: 30),
      Icon(Icons.list_rounded, size: 30),
      Icon(Icons.settings, size: 30)

    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: screen[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white),
        ),//สีในไอคอน
        child: CurvedNavigationBar(
          key: navigationKey,
          color: Colors.pink.shade300,//สีแถบนาวิเกเตอร์บาร์
          buttonBackgroundColor: Colors.pink.shade900,//สีรอบไอคอนที่โดนกด
          backgroundColor: Colors.transparent,
          height: 60,
          animationDuration: Duration(milliseconds: 300),
          index: index,
          items: items,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
    );
  }
}
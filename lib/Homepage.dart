/*import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[

            Container(
              height: 100,
            ),

            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: TextStyle(fontSize: 35)
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 50),
              child:  Container(
                child: Center(
                  child: Image.asset("images/home.gif")/*Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                      image: AssetImage("images/home.gif"),
                      fit: BoxFit.cover))
                  )*/
                ),
                width: MediaQuery.of(context).size.width*0.5,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.amber.shade100,
                )
              )
            ),

          ],
        ),
      )
    );
  }
}*/

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule App"),
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home1.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/images/home.gif",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.5,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: TextStyle(fontSize: 35, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





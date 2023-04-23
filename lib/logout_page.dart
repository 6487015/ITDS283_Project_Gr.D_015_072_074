import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'Bottombar.dart';
import 'Homepage.dart';
import 'package:getwidget/getwidget.dart';

class LogoutPage extends StatelessWidget {
  LogoutPage({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child:Column(
          children: [
            Container(
              width: w,
              height: h * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/pink-yellow-gradient-md.png"),
                      fit: BoxFit.cover)),
              child: Column(children: [
                SizedBox(
                  height: h * 0.15,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white70,
                  radius: 60,
                  backgroundImage: AssetImage("assets/images/logout.png"),
                )
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                    "Have a good day!",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 93, 147),
                    ),
                  ),
                    SizedBox(
                      height: 90,
                    ),
                    Column(children: <Widget>[
                      GFButton(
                          onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40))),
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 196, 215),
                                    title:
                                        const Text('Log out'),
                                    content: const Text('Are you sure?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          
                                        },
                                         child: Text('Cancel', style: TextStyle(color: Colors.black),) 
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await _auth.signOut();
                                          Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (context) => LoginPage()),
                                      );},
                                         child: Text('Yes', style: TextStyle(color: Colors.red),)   
                                      ),
                                    ]),
                              ),
                          color: Color.fromARGB(255, 255, 93, 147),
                          shape: GFButtonShape.pills,
                          size: h * 0.08,
                          child: Center(
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(249, 242, 248, 124),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                    ]
                    ),
                  ]
                  ),
            )
          ],
        )),
      );
  }
}

import 'package:flutter/material.dart';

class MyFirstApp extends StatelessWidget {
  const MyFirstApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.greenAccent,
              title: Text("User Basic Details"),
            ),
            body: Column(children: <Widget>[
              Container(
                width: 250,
                padding: EdgeInsets.all(20.0),
                color: Colors.pinkAccent,
                child: Text("Name:Yamini"),
              ),
              Container(
                width: 250,
                padding: EdgeInsets.all(20.0),
                color: Colors.pink,
                child: Text("Age:24"),
              ),
              Container(
                width: 250,
                padding: EdgeInsets.all(20.0),
                color: Colors.purpleAccent,
                child: Text("Qualification:Bachelor of Engineering"),
              ),
              Container(
                width: 250,
                padding: EdgeInsets.all(20.0),
                color: Colors.purple,
                child: Text("City:Chennai"),
              )
            ])));
  }
}

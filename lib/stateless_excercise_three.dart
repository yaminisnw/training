import 'package:flutter/material.dart';

class VerticalColors extends StatelessWidget {
  const VerticalColors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Colors Page'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50,
                color: Colors.lightBlueAccent,
              ),
              Container(
                height: 50,
                color: Colors.lightBlue,
              ),
              Container(
                height: 50,
                color: Colors.blue,
              ),
              Container(
                height: 50,
                color: Colors.blueAccent,
              ),
              Container(
                height: 50,
                color: Colors.indigoAccent,
              ),
              Container(
                height: 50,
                color: Colors.indigo,
              ),
              Container(
                height: 50,
                color: Colors.deepPurpleAccent,
              ),
              Container(
                height: 50,
                color: Colors.deepPurple,
              ),
              Container(
                height: 50,
                color: Colors.purpleAccent,
              ),
              Container(
                height: 50,
                color: Colors.purple,
              ),
            ],
          )),
    );
  }
}

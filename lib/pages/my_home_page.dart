import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training/auth/login_page.dart';

import '../flavors.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    userName();
  }

  Future<void> userName() async {
    final _count = await FirebaseFirestore.instance
        .collection('counters')
        .doc('counter_doc${uid}')
        .get();
    _counter = _count['count'];
    setState(() {});
  }

  int _counter = 0;

  //Taking the user from the authentication
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setInt('counter', _counter);
    //Update Firebase Storage
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference _counterRef =
        _firestore.collection('counters').doc('counter_doc${uid}');
    await _counterRef.set(
        {'count': _counter, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true));
  }

  // Future<void> _loadCounter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _counter = prefs.getInt('counter') ?? 0;
  //   });
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _loadCounter();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(F.title),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => CounterLoginPage(),
                  ),
                );
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Hello ${F.title}',
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Counter Users')
                  .doc(uid)
                  .snapshots(),
              builder: (c, i) {
                if (i.hasError) {
                  return SizedBox();
                }
                if (!i.hasData) {
                  return SizedBox();
                }
                final data = i.requireData;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'You have pushed the button : ${_counter} times',
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

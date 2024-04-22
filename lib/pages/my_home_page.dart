import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training/auth/login_page.dart';
import 'package:flutter_training/pages/common_counter.dart';
import 'package:flutter_training/pages/single_user_multiple_counter.dart';

import '../flavors.dart';
import 'list_of_counters.dart';

class MyHomePage extends StatefulWidget {
  final String docid;

  const MyHomePage({super.key, required this.docid});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    userName();
    //no need
  }

  Future<void> userName() async {
    //_countDoc is the document name that is used for local reference [] is the field inside the document
    final _countDoc = await FirebaseFirestore.instance
        .collection('counters')
        .where('uid', isEqualTo: uid)
        .get();
    if (_countDoc.docs.isNotEmpty) {
      var first = _countDoc.docs.first;
      _updatedTime = first['updatedAt'].toDate();
      _counter = first['count'];
      setState(() {});
    }
  }

  Future<void> updateCounter() async {
    final countersCollection =
        FirebaseFirestore.instance.collection('counters');
    final currentTime = DateTime.now();
    final previousUpdatedTime = currentTime.difference(_updatedTime).inMinutes;
    if (previousUpdatedTime >= 3) {
      countersCollection.doc(widget.docid).set({
        'count': _counter,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
  }

  DateTime _updatedTime = DateTime.now();
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
        _firestore.collection('counters').doc(widget.docid);
    await _counterRef.set(
      {
        'count': _counter,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> _counterHistory() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference _counterRef = _firestore
        .collection('counters')
        .doc(widget.docid)
        .collection('history')
        .doc();
    await _counterRef.set(
      {
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp()
      },
    );
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
          if (widget.docid.isNotEmpty)
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('counters')
                    .doc(widget.docid)
                    .snapshots(),
                builder: (c, i) {
                  if (i.hasError) {
                    return SizedBox();
                  }
                  if (!i.hasData) {
                    return SizedBox();
                  }
                  final data = i.requireData;
                  if (!data.exists) {
                    return SizedBox();
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'You have pushed the button : ${data['count']} times',
                        ),
                      ],
                    ),
                  );
                }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () async {
                  updateCounter();
                  if (_counter == 10) {
                    await _counterHistory();
                    _counter = 0;
                    setState(() {});
                  } else {
                    await _incrementCounter();
                  }
                },
                heroTag: 'Increment',
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => CommonCounter(),
                    ),
                  );
                },
                heroTag: 'MultiUser',
                child: Text('Multi-User'),
              )
            ],
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => MultipleCounters(),
                      ),
                    );
                  },
                  child: Text('MultipleCounters')),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => ListOfCounters(),
                      ),
                    );
                  },
                  child: Text('MultipleCountersList'))
            ],
          ),
          if (widget.docid.isNotEmpty)
            Expanded(
                child: StreamBuilder(
              stream: _updateHistory(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }
                if (snapshot.hasError) {
                  return SizedBox();
                }
                return ListView.builder(
                    itemCount: snapshot.data?.size,
                    itemBuilder: (context, index) {
                      final item = snapshot.data?.docs[index];

                      return ListTile(
                        title: Text(''),
                        isThreeLine: true,
                        subtitle: Text(
                            'Created time: ${item?['createdAt']}\nUpdated time ${item!['updatedAt']}'),
                      );
                    });
              },
            ))
        ],
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _updateHistory() {
    return FirebaseFirestore.instance
        .collection('counters')
        .doc(widget.docid)
        .collection('history')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}

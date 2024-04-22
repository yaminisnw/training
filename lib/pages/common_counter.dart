import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training/auth/login_page.dart';
import 'package:flutter_training/pages/my_home_page.dart';

import '../flavors.dart';

class CommonCounter extends StatefulWidget {
  const CommonCounter({super.key});

  @override
  State<CommonCounter> createState() => _CommonCounterState();
}

class _CommonCounterState extends State<CommonCounter> {
  String _docid = 'common_counter';
  @override
  void initState() {
    super.initState();
    userName();
  }

  Future<void> userName() async {
    //_countDoc is the document name that is used for local reference [] is the field inside the document
    final _countDoc = await FirebaseFirestore.instance
        .collection('counters')
        .doc(_docid)
        .get();
    _updatedTime = _countDoc['updatedAt'].toDate();
    _counter = _countDoc['count'];
    setState(() {});
  }

  Future<void> updateCounter() async {
    final countersCollection =
        FirebaseFirestore.instance.collection('counters');
    final currentTime = DateTime.now();
    final previousUpdatedTime = currentTime.difference(_updatedTime).inMinutes;
    if (previousUpdatedTime >= 3) {
      countersCollection.doc(_docid).set({
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
        _firestore.collection('counters').doc(_docid);
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
        .doc(_docid)
        .collection('history')
        .doc();
    await _counterRef.set(
      {
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp()
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => MyHomePage(
                  docid: 'common_counter',
                ),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
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
          if (_docid.isNotEmpty)
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('counters')
                    .doc(_docid)
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
            ],
          ),
          if (_docid.isNotEmpty)
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
        .doc(_docid)
        .collection('history')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}

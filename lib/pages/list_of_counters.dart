import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'my_home_page.dart';

class ListOfCounters extends StatefulWidget {
  const ListOfCounters({super.key});

  @override
  State<ListOfCounters> createState() => ListOfCountersState();

  Future<void> sharedData(List<String> uid) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference _sharedRef =
        _firestore.collection('counters').doc();
    await _sharedRef.set(
      {'sharedCounter': uid},
    );
  }
}

class ListOfCountersState extends State<ListOfCounters> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Of Users'),
      ),
      body: Center(
          child: StreamBuilder(
        stream:
            //FirebaseFirestore.instance.collection('Counter Users').snapshots(),
            FirebaseFirestore.instance
                .collection('counters')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            MyHomePage(docid: item?.id ?? ''),
                      ),
                    );
                  },
                  title: Text('uid:${item?['uid']}'),
                  isThreeLine: true,
                  subtitle: Text('counterid:${item?.id}'),
                );
              });
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseFirestore.instance.collection('counters').doc().set({
            'count': 0,
            'uid': FirebaseAuth.instance.currentUser?.uid,
            'createdAt': DateTime.now(),
            'updatedAt': DateTime.now(),
          });
        },
        tooltip: 'Add Counters',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _incrementCounter() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference counterRef =
          _firestore.collection('counters').doc(user.uid);
      DocumentSnapshot counterSnapshot = await counterRef.get();
      int currentCounter =
          counterSnapshot.exists ? counterSnapshot.get('count') ?? 0 : 0;
      await counterRef.set({'count': currentCounter + 1, 'uid': user.uid});
    }
  }
}

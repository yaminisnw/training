import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListOfUsers extends StatefulWidget {
  const ListOfUsers({super.key});

  @override
  State<ListOfUsers> createState() => ListOfUsersState();

  Future<void> sharedData(List<String> uid) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference _sharedRef =
        _firestore.collection('counters').doc();
    await _sharedRef.set(
      {'sharedCounter': uid},
    );
  }
}

class ListOfUsersState extends State<ListOfUsers> {
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
            FirebaseFirestore.instance.collection('Counter Users').snapshots(),
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
                  title: Text('uid:${item?['uid']}'),
                  isThreeLine: true,
                  subtitle: Text(
                      'Created time: ${item?['createdAt']}\nUpdated time ${item!['updatedAt']}'),
                );
              });
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter();
        },
        tooltip: 'Increment',
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

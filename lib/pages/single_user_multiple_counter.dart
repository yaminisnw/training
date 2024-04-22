import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_page.dart';
import '../flavors.dart';

class MultipleCounters extends StatefulWidget {
  const MultipleCounters({super.key});

  @override
  State<MultipleCounters> createState() => _MultipleCountersState();
}

class _MultipleCountersState extends State<MultipleCounters> {
  late String _userId;
  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
  }

  int _counter = 0;

  //Taking the user from the authentication
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> _incrementCounter(DocumentReference counterRef) async {
    await counterRef.update({
      'count': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
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
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Counter Users')
                .doc(_userId)
                .collection('multipleCounters')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No data available');
              }
              if (snapshot.hasData && snapshot.data!.docs.length > 1) {
                // User has multiple counters
                // You can handle this case here
              }

              var counterDocs = snapshot.data!.docs;
              if (counterDocs.length > 1) {
                return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: counterDocs.length,
                      itemBuilder: (context, index) {
                        var counterData = counterDocs[index].data() as Map<
                            String, dynamic>?; // Cast to Map<String, dynamic>
                        return CounterTile(
                          count: counterData?['count'] ?? 0,
                          onIncrement: () {
                            _incrementCounter(counterDocs[index]
                                .reference); // Pass DocumentReference
                          },
                        );
                      },
                    ));
              } else {
                var counterData = counterDocs.first.data()
                    as Map<String, dynamic>?; // Cast to Map<String, dynamic>
                return CounterTile(
                  count: counterData?['count'] ?? 0,
                  onIncrement: () {
                    _incrementCounter(
                        counterDocs.first.reference); // Pass DocumentReference
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class CounterTile extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;

  const CounterTile({
    required this.count,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Counter'),
      subtitle: Text('Count: $count'),
      trailing: IconButton(
        onPressed: onIncrement,
        icon: Icon(Icons.add),
      ),
    );
  }
}

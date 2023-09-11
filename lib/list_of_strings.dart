import 'package:flutter/material.dart';

class StringsApp extends StatelessWidget {
  const StringsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner:false,
        home: StringsList());
  }
}

class StringsList extends StatefulWidget {
  const StringsList({super.key});

  @override
  State<StringsList> createState() => _StringsListState();
}

class _StringsListState extends State<StringsList> {
  @override
  Widget build(BuildContext context) {
    final items = ["Orange","Strawberry",
      "Pineapple",
      "Apple",
      "Kiwi",
      "Custardapple",
      "Litchi",
      "Rambutan",
      "Starfruit",
      "Mango"];

    items.sort((a,b){
      return a.compareTo(b);
    });
    return Scaffold(
        appBar: AppBar(
          title: Text("Sorting List Alphabetically"),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            children:items.map((cone){
              return Container(
                child: Card(
                  child:Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      child: Text(cone, style: TextStyle(fontSize: 18))),
                ),
              );
            }).toList(),
          ),
        )
    );



  }
}

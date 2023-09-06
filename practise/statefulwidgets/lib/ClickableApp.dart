import 'package:flutter/material.dart';


class ClickApp extends StatelessWidget {
  const ClickApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clickable App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const ClickableApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class ClickableApp extends StatefulWidget {

  const ClickableApp({super.key});

  @override
  State<ClickableApp> createState() => ClickableAppState();


}

class ClickableAppState extends State<ClickableApp> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(title:Text('Click Demo'),backgroundColor: Colors.deepOrangeAccent,),backgroundColor: Colors.greenAccent,
      body: Center(child: ElevatedButton(style: ElevatedButton.styleFrom(
          backgroundColor: isPressed ? Colors.blue : Colors.grey), onPressed: () { setState(() {
            isPressed = ! isPressed;
          }); }, child: Text('Press Here'),)
      ),
    );
  }

}

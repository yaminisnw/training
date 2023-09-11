import 'package:flutter/material.dart';
//import 'register_page.dart';

import 'stateless_excercise_three.dart';
// import 'stateless_exercise_one.dart';
//import 'stateless_exercise_two.dart';
//import 'ClickableApp.dart';
//import 'list_of_strings.dart';
//import 'user_detail_form.dart';

void main() {
  runApp (const VerticalColors());
  // runApp (const MyApp()) ;
  // runApp(const MyApp());
  //runApp(const ClickApp());
  // runApp(const StringsApp());
  //runApp(const UserDetailsForm());
}

/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.redAccent,
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
        Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Center(
          child: Container(
            width: 200,
            height: 150,
            /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
            //child: Column(mainAxisAlignment: MainAxisAlignment.start,children:[Image.asset('assets/images/blue_particles.jpeg')])
          ),
        ),
      ),
      Padding(
        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              hintText: 'Enter valid email id as abc@gmail.com'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 15, bottom: 0),
        //padding: EdgeInsets.symmetric(horizontal: 15),
        child: TextField(

          obscureText: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              hintText: 'Enter secure password'),
        ),
      ), ElevatedButton(
      onPressed: () {
        //TODO FORGOT PASSWORD SCREEN GOES HERE
      },
      child: Text(
        'Forgot Password',
        style: TextStyle(color: Colors.black, fontSize: 15,),
      ),
    ),
      Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
            color: Colors.cyan, borderRadius: BorderRadius.circular(20)),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HomePage()));
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
      Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
              color: Colors.cyan, borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: ()
            {
              Navigator.push(context,MaterialPageRoute(builder: (_) => RegisterPage()));

            },
            child: Text('Register'),)

      ),

    SizedBox(
    height: 130,
    ),
    Text('New User? Create Account')
    ],
    ),
    ),
    );
  }
} */
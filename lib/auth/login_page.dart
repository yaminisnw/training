import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training/auth/sign_up_page.dart';
import 'package:flutter_training/pages/my_home_page.dart';

class CounterLoginPage extends StatefulWidget {
  const CounterLoginPage({super.key});

  @override
  State<CounterLoginPage> createState() => _CounterLoginPageState();
}

class _CounterLoginPageState extends State<CounterLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child:
              Text('User Login', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: 'Email', hintText: 'Enter Email'),
                  validator: (value) {
                    final emailValidation = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (emailValidation.hasMatch(value ?? '')) {
                      return null;
                    }
                    return 'Invalid Email';
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password', hintText: 'Enter Password'),
                  validator: (value) {
                    if ((value?.length ?? 0) >= 8) {
                      return null;
                    }
                    if ((value != passwordController.text)) {
                      return 'Enter Correct Password';
                    }
                    return 'Invalid Password';
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => MyHomePage(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                          print(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        }
                      }
                    },
                    child: Text('SignIn')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text('Sign Up'))
              ],
            ),
          )),
    );
  }
}

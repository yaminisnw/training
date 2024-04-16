import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training/auth/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User SignUp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const CounterLoginPage(),
              ),
            );
          },
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
                  decoration: InputDecoration(labelText: 'Enter Email'),
                  validator: (value) {
                    final emailValidation = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9[a-zA-Z]+");
                    if (emailValidation.hasMatch(value ?? '')) {
                      return null;
                    }
                    return 'Invalid Email';
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Enter Password'),
                  validator: (value) {
                    if ((value?.length ?? 0) >= 8) {
                      return null;
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
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          var uid = userCredential.user?.uid;
                          await FirebaseFirestore.instance
                              .collection('Counter Users')
                              .doc(uid)
                              .set({
                            'email': emailController.text,
                            'createdAt': DateTime.now(),
                            'updatedAt': DateTime.now(),
                            "uid": uid
                          });
                          await FirebaseFirestore.instance
                              .collection('counters')
                              .doc('counter_doc${uid}')
                              .set({
                            'count': 0,
                            'uid': uid,
                            'createdAt': DateTime.now(),
                            'updatedAt': DateTime.now(),
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  CounterLoginPage(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Text('Submit'))
              ],
            ),
          )),
    );
  }
}

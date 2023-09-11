

import 'package:flutter/material.dart';

class UserDetailsForm extends StatelessWidget {
  const UserDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final appTitle = ' User Details';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: Scaffold(
        //backgroundColor: Colors.indigoAccent[100],
        appBar: AppBar(
          backgroundColor: Colors.purple[200],
          title: Text(appTitle),),
        body: CustomizedForm(),
      ),);
  }
}

class CustomizedForm extends StatefulWidget {
  const CustomizedForm({super.key});

  @override
  State<CustomizedForm> createState() => CutomizedFormState();
}

class CutomizedFormState extends State<CustomizedForm> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(icon: Icon(Icons.person),
                  hintText: 'Enter Name',
                  labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },),
            TextFormField(decoration: InputDecoration(icon: Icon(Icons.phone),
                hintText: 'Enter Phone Number',
                labelText: 'Phone Number'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your number';
                }
                return null;
              },),
            TextFormField(decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                hintText: 'Enter date of birth', labelText: 'DOB'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the DOB';
                }
                return null;
              },),
            TextFormField(decoration: InputDecoration(
                icon: Icon(Icons.maps_home_work),
                hintText: 'Enter your address',
                labelText: 'Address'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Address';
                }
                return null;
              },),
            TextFormField(decoration: InputDecoration(
                icon: Icon(Icons.pin_drop),
                hintText: 'Enter your City',
                labelText: 'City'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the City';
                }
                return null;
              },),
            TextFormField(decoration: InputDecoration(
                icon: Icon(Icons.mail_sharp),
                hintText: 'Enter your postal pincode', labelText: 'Zipcode'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Zipcode';
                }
                return null;
              },),
            Container(
                padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed:(){ if (formKey.currentState!.validate()) {
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(title:Text("Success"),content:Text("Submitted Successfully"),);});
                    // If the form is valid, display a Snackbar.

                  }  },
                )),
          ],
        ));

  }
}
/*class AlertDialogBox extends StatelessWidget {
  const AlertDialogBox ({super.key, required Text title, required Text content});
  final alertTitle ='Form Submission';
  final alertContent =  'Form Submitted Successfully';

  @override
  Widget build(BuildContext context) {
    return AlertDialogBox(title:Text(alertTitle),content:Text(alertContent));
  }
}*/



import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WriteExample extends StatefulWidget {
  const WriteExample({Key? key}) : super(key: key);

  @override
  State<WriteExample> createState() => _WriteExampleState();
}

class _WriteExampleState extends State<WriteExample> {
  final database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    final dailySpecial = database.child('/produkte/');

    return Scaffold(
        body: Center(
      child: Column(children: [
        ElevatedButton(
            onPressed: () {
              dailySpecial
                  .set({'normalesBroetchen': 0.3})
                  .then((value) => print("Erfolgreich geschrieben"))
                  .catchError((onError) => print(onError));
            },
            child: Text("Setze Brötchen"))
      ]),
    ));
  }
}

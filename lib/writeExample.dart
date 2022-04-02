import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:broetchenservice/writeToDB.dart';
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
                  .set({'koernerbroetchen': 2.5})
                  .then((value) => print("Erfolgreich geschrieben"))
                  .catchError((onError) => print(onError));
            },
            child: Text("Setze Brötchen")),
        ElevatedButton(
            onPressed: () {
              writeOrder();
            },
            child: Text("Speicher Bestellung"))
      ]),
    ));
  }

  writeOrder() {
    //Create SingleOrder List
    List<SingleOrder> sol = [
      new SingleOrder("normalesbroetchen", 3, 0.3),
      new SingleOrder("milchbroetchen", 1, 0.8),
      new SingleOrder("coffee", 1, 2)
    ];

    //Create WholeOrder Object which sets userID and Value
    WholeOrder wo = new WholeOrder(sol);

    //Write Whole Order to DB
    writeToDB().writeOrder(wo);
  }
}
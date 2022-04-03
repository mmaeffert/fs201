import 'package:broetchenservice/order/product.dart';
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
            child: Text("Speicher Bestellung")),
        ElevatedButton(
            onPressed: () {
              writeToDB().changeUserBalance(10, "Guthaben aufgelade", "");
            },
            child: Text("Change balance")),
      ]),
    ));
  }

  writeOrder() {
    //Create SingleOrder List
    List<SingleOrder> sol = [
      new SingleOrder(
          3, false,
          Product(
            0.3,
            "Kaiser Brötchen",
          )),
      new SingleOrder(1, false,Product(0.8, "Körner Brötchen")),
    ];

    //Create WholeOrder Object which sets userID and Value
    WholeOrder wo = new WholeOrder(sol);

    //Write Whole Order to DB
    writeToDB().writeOrder(wo);
  }
}

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
    List<SingleOrder> sol = [
      new SingleOrder("normalesbroetchen", 3, 0.3),
      new SingleOrder("kornerbroetchen", 1, 0.8)
    ];
    // sol.forEach((element) {
    //   print(element.identifier);
    // });
    WholeOrder wo = new WholeOrder(sol);
    // wo.orderList.forEach(((element) {
    //   print(element.identifier);
    // }));
    writeToDB().writeOrder(wo);
  }
}

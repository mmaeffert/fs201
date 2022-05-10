import 'package:broetchenservice/db/readFromDB.dart';
import 'package:flutter/material.dart';

class ReadExample extends StatefulWidget {
  const ReadExample({Key? key}) : super(key: key);

  @override
  State<ReadExample> createState() => _ReadExampleState();
}

class _ReadExampleState extends State<ReadExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        ElevatedButton(
            onPressed: () {
              ReadFromDB().getOrderList();
            },
            child: Text("getOrderList")),
        ElevatedButton(
            onPressed: () {
              ReadFromDB().getOrderList();
            },
            child: Text("getWholeOrderList")),
      ]),
    ));
  }
}

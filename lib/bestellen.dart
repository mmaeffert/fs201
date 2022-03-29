import 'dart:math';
import 'package:flutter/material.dart';
import './quantitySelector.dart';

class Bestellen extends StatefulWidget {
  const Bestellen({Key? key}) : super(key: key);

  @override
  State<Bestellen> createState() => _BestellenState();
}

class _BestellenState extends State<Bestellen> {
  List<TableRow> orderlist = [];

  addRandomWidgetsToOrderList() {
    for (int i = 0; i < 10; i++) {
      orderlist.add(TableRow(children: [
        Center(
          child: Text(Random().nextInt(1000).toString()),
        ),
        Center(
          child: Text(Random().nextInt(1000).toString()),
        ),
        Center(
          child: QuantitySelector(),
        )
      ]));
    }
  }

  @override
  void initState() {
    // test();
    orderlist.add(TableRow(children: [
      Center(child: Text("Produkt")),
      Center(child: Text("Preis")),
      Center(child: Text("Menge"))
    ]));
    addRandomWidgetsToOrderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Table(
            children: orderlist,
          )
        ],
      ),
    ));
  }
}

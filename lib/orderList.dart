import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<ListTile> tileList = [];

  @override
  void initState() {
    tileList.add(ListTile(
      title: Text("dfsfsfsfd"),
      onTap: () {
        setState(() {});
      },
    ));
    getChildrenList();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ListView(children: tileList)),
    );
  }

  getChildrenList() async {
    List<WholeOrder> wholeOrderList = await ReadFromDB().getOrderList();

    for (WholeOrder wo in wholeOrderList) {
      tileList.add(
        ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            title: Text(
              wo.toString(),
              style: TextStyle(
                  fontSize: 15, color: Color.fromARGB(255, 179, 178, 185)),
            )),
      );
    }
  }
}

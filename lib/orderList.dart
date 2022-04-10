import 'dart:collection';

import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/themes.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import './appbar.dart' as ab;

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Map<String, Icon> statusIcon = {
    'o': Icon(Icons.timelapse, color: Colors.orangeAccent),
    'p': Icon(Icons.check, color: Colors.green),
    'r': Icon(Icons.attach_money_outlined, color: Colors.green),
    'c': Icon(Icons.cancel, color: Colors.redAccent)
  };
  List<ExpansionTile> tileList = [];
  bool isloading = true;
  @override
  void initState() {
    getChildrenList().then((value) {
      setState(() {
        isloading = false;
      });
    });
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ab.Appbar.MainAppBar(context),
        body: Padding(
            padding: EdgeInsets.all(12),
            child: Container(
                width: (MediaQuery.of(context).size.width > 800)
                    ? 800
                    : MediaQuery.of(context).size.width,
                child: Card(
                    color: currentTheme.getPrimaryColor(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black)),
                    child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(children: tileList))))));
  }

  Future<List<WholeOrder>> getChildrenList() async {
    List<WholeOrder> wholeOrderList = await ReadFromDB().getOrderList();

    for (WholeOrder wo in wholeOrderList) {
      tileList.add(
        ExpansionTile(
          textColor: Color.fromARGB(255, 52, 69, 77),
          childrenPadding: EdgeInsets.only(left: 15),
          expandedAlignment: Alignment.topLeft,
          title: Row(
            children: [
              statusIcon[wo.getStatus()] as Icon,
              Text("  " + getDate(wo.timeStamp) + "  "),
              Text(wo.wholeOrderValue.toStringAsFixed(2) + " €")
            ],
          ),
          children: [
            Text(
              wo.standingOrder ? "Aus Dauerauftrag" : "Aus Bestellung",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black),
            ),
            generateOrderList(wo.orderList)
          ],
        ),
      );
    }

    return wholeOrderList;
  }

  generateOrderList(List<SingleOrder> singleOrderList) {
    DataTable result = DataTable(columns: [
      DataColumn(label: Text("Artikel")),
      DataColumn(label: Text("Anzahl")),
      DataColumn(label: Text("Preis"))
    ], rows: []);

    for (SingleOrder so in singleOrderList) {
      result.rows.add(DataRow(cells: [
        DataCell(Text(
          so.identifier,
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          so.amount.toString(),
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          so.price.toString(),
          style: TextStyle(color: Colors.black),
        ))
      ]));
    }

    return result;
  }

  getDate(int timeStamp) {
    String result = "";
    result += DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true)
            .day
            .toString() +
        '/';
    result += DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true)
            .month
            .toString() +
        '/';
    result += DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true)
        .year
        .toString();
    return result;
  }
}

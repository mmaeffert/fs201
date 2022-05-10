import 'package:broetchenservice/balance.dart';
import 'package:flutter/material.dart';
import './appbar.dart' as ab;
import './db/readFromDB.dart';
import './orderList.dart';
import './themes.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({Key? key}) : super(key: key);

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  bool isloading = true;
  List<ExpansionTile> tableRows = [];

  @override
  void initState() {
    getBalanceList().then((value) {
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
        body: isloading
            ? Text("loading...")
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(children: tableRows)));
  }

  getBalanceList() async {
    List<Balance> balanceList = await ReadFromDB().getBalanceList();

    for (Balance ba in balanceList) {
      tableRows.add(ExpansionTile(
        childrenPadding: EdgeInsets.only(left: 15),
        expandedAlignment: Alignment.topLeft,
        title: Row(
          children: [
            Text(
              ba.balance.toString(),
              style:
                  TextStyle(color: ba.balance >= 0 ? Colors.green : Colors.red),
            ),
            Text(" € - " + getDate(ba.timestamp) + " - ",
                style: TextStyle(color: CustomTheme().getTextColor())),
            ba.comment != null
                ? Text(ba.comment.toString(),
                    style: TextStyle(color: CustomTheme().getTextColor()))
                : SizedBox.shrink(),
          ],
        ),
        children: [
          ba.orderID != null ? Text(ba.orderID.toString()) : SizedBox.shrink(),
        ],
      ));
    }
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

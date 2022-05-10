import 'package:flutter/services.dart';
import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/db/writeToDB.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/themes.dart';
import 'package:flutter/material.dart';
import 'package:broetchenservice/UI%20Kit/alertDialogKit.dart';
import './appbar.dart' as ab;

class OrderList extends StatefulWidget {
  final List<String> openTiles;
  const OrderList({Key? key, required this.openTiles}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Map<String, Icon> statusIcon = {
    'o': const Icon(Icons.timelapse_outlined, color: Colors.orangeAccent),
    'p': const Icon(Icons.check_outlined, color: Colors.green),
    'r': const Icon(Icons.attach_money_outlined, color: Colors.green),
    'c': const Icon(Icons.cancel_outlined, color: Colors.redAccent)
  };

  List<ExpansionTile> tileList = [];
  List<Widget> standingOrderList = [];
  bool isloading = true;

  @override
  void initState() {
    getChildrenList().then((value) {
      setState(() {
        isloading = false;
      });
    });
    getStandingOrderColumn().then((value) => standingOrderList = value);
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: ab.Appbar.TabAppBar(context),
          body: TabBarView(children: [
            //Orderslist
            Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                    width: (MediaQuery.of(context).size.width > 800)
                        ? 800
                        : MediaQuery.of(context).size.width,
                    child: isloading
                        ? const Text("loading...")
                        : Card(
                            color: currentTheme.getPrimaryColor(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(color: Colors.black)),
                            child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(children: tileList))))),

            //Standing orders list
            Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                color: currentTheme.getPrimaryColor(),
                child: Column(children: standingOrderList),
              ),
            )
          ])),
    );
  }

  getStandingOrderColumn() async {
    List<Widget> returnList = [];
    var standingOrder = await ReadFromDB().getStandingOrder();

    if (standingOrder == null) {
      return;
    }

    returnList.add(Text("Erstellt am: " + getDate(standingOrder['timestamp'])));
    returnList.add(Text("Einkaufswert: " + standingOrder['value']));

    List<SingleOrder> singleOrders =
        await ReadFromDB().getSingleOrdersFromID(standingOrder['orderid']);

    for (SingleOrder so in singleOrders) {
      returnList.add(Row(
        children: [
          Text(so.identifier + "  -  "),
          Text(so.amount.toString() + " Stück für jeweils "),
          Text(so.price.toString() + " €")
        ],
      ));
    }

    returnList.add(IconButton(
        onPressed: (() {
          writeToDB().deleteStandingOrder();
          AlertDialogKit.alertDialog1(
              context,
              "Der Dauerauftrag wurde beendet. Eventuell musst du noch die offene Bestellung löschen",
              "Ok");
          setState(() {});
        }),
        icon: const Icon(Icons.cancel_outlined)));

    return returnList;
  }

  Future<List<WholeOrder>> getChildrenList() async {
    List<WholeOrder> wholeOrderList = await ReadFromDB().getOrderList();
    wholeOrderList.sort((WholeOrder wo1, WholeOrder wo2) {
      return wo2.timeStamp - wo1.timeStamp;
    });

    for (WholeOrder wo in wholeOrderList) {
      tileList.add(
        ExpansionTile(
          initiallyExpanded:
              widget.openTiles.contains(wo.orderID) ? true : false,
          textColor: const Color.fromARGB(255, 52, 69, 77),
          childrenPadding: const EdgeInsets.only(left: 15),
          expandedAlignment: Alignment.topLeft,
          title: Row(
            children: [
              statusIcon[wo.status] as Icon,
              Text("  " + getDate(wo.timeStamp) + "  "),
              Text(wo.wholeOrderValue.toStringAsFixed(2) + " €")
            ],
          ),
          children: [
            Row(
              children: [
                Text(
                  wo.standingOrder ? "Aus Dauerauftrag" : "Aus Bestellung",
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.black),
                ),
                (wo.status == 'o')
                    ? IconButton(
                        onPressed: (() {
                          writeToDB().cancelOrder(wo);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Bestellung wurde abgebrochen und der Betrag erstattet'),
                          ));
                          setState(() {
                            wo.status = 'c';
                          });
                        }),
                        icon: const Icon(Icons.cancel),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            Row(
              children: [
                Text(
                  "Bestellnummer: " + wo.orderID!,
                  style: const TextStyle(color: Colors.black),
                ),
                IconButton(
                    onPressed: () => {copyToClipboard(wo.orderID!)},
                    icon: const Icon(Icons.copy))
              ],
            ),
            generateOrderList(wo.orderList)
          ],
        ),
      );
    }

    wholeOrderList.sort(((a, b) => a.timeStamp - b.timeStamp));
    return wholeOrderList;
  }

  copyToClipboard(String orderID) async {
    await Clipboard.setData(ClipboardData(text: orderID));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  //Creates the table that is displayed, when you expand the tile
  generateOrderList(List<SingleOrder> singleOrderList) {
    DataTable result = DataTable(columns: const [
      DataColumn(label: Text("Artikel")),
      DataColumn(label: Text("Anzahl")),
      DataColumn(label: Text("Preis"))
    ], rows: const []);

    for (SingleOrder so in singleOrderList) {
      result.rows.add(DataRow(cells: [
        DataCell(Text(
          so.identifier,
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          so.amount.toString(),
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          so.price.toString(),
          style: const TextStyle(color: Colors.black),
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

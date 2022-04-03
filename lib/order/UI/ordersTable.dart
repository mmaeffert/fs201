import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../db/readFromDB.dart';
import '../../themes.dart';
import '../product.dart';
import '../singleOrder.dart';
import "package:intl/intl.dart";

class OrdersTable extends StatefulWidget {
  OrdersTable();
  List<SingleOrder> orders = [];
  List<SingleOrder> get getOrders => orders;

  @override
  State<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersTable> {
  @override
  void initState() {
    super.initState();
    widget.orders.add(SingleOrder(
        3,
        Product(
          0.3,
          "Kaiser Brötchen",
        )));
    widget.orders.add(SingleOrder(1, Product(0.8, "Körner Brötchen")));
    // _getEmployees();
  }

  @override
  Widget build(BuildContext context) {
    final Tablenbreite = MediaQuery.of(context).size.width - 340;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 0, left: 0),
              child: Divider(
                  color: CustomTheme.isDarkTheme
                      ? Colors.white24
                      : Colors.black26),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 0, left: 10),
              child: const Text("Bestellübersicht",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Divider(
                color:
                    CustomTheme.isDarkTheme ? Colors.white24 : Colors.black26),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 40,
                      columnSpacing: 20,
                      dataRowHeight: 35,
                      onSelectAll: (b) {},
                      horizontalMargin: 8,
                      columns: const [
                        DataColumn(
                          label: Text('Brötchen'),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text(
                            'Menge',
                            textAlign: TextAlign.center,
                          )),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text(
                            'Preis',
                            textAlign: TextAlign.center,
                          )),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text(
                            'Summe',
                            textAlign: TextAlign.center,
                          )),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text(
                            'Dauerauftrag',
                            textAlign: TextAlign.center,
                          )),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text(
                            'Löschen',
                            textAlign: TextAlign.center,
                          )),
                        ),
                        // Lets add one more column to show a delete button
                      ],
                      rows: widget.orders
                          .map(
                            (order) => DataRow(

                                //selected: true,
                                cells: [
                                  DataCell(
                                    Container(
                                      constraints:
                                          BoxConstraints(minWidth: 130),
                                      width: Tablenbreite * 0.45, //SET width
                                      child: Text(
                                        order.identifier,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 60, //SET width
                                      child: Text(
                                        order.amount.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  DataCell(
                                    Container(
                                      constraints: BoxConstraints(minWidth: 70),
                                      width: Tablenbreite * 0.25,
                                      child: Text(
                                        NumberFormat.currency(locale: 'eu')
                                            .format(order.price),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  DataCell(
                                    Container(
                                      constraints: BoxConstraints(minWidth: 70),
                                      width: Tablenbreite * 0.25,
                                      child: Text(
                                        NumberFormat.currency(locale: 'eu')
                                            .format(order.price * order.amount),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: 60,
                                        child: Checkbox(
                                          value: order.standingOrder,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              // order.standingOrder = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                        width: 50,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  widget.orders.remove(order);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              )),
                                        )),
                                  ),
                                ]),
                          )
                          .toList(),
                    )),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: 20, bottom: 20, right: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  "Kostenpflichtig bestellen",
                  // style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

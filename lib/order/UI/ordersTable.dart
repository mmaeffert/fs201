import 'dart:ui';
import 'package:broetchenservice/UI%20Kit/textKit.dart';
import 'package:broetchenservice/order/UI/purchaseOrder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../UI Kit/headerKit.dart';
import '../singleOrder.dart';
import 'package:broetchenservice/appbar.dart' as ab;

// ignore: must_be_immutable
class OrdersTable extends StatefulWidget {
  OrdersTable({Key? key}) : super(key: key);

  @override
  State<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersTable> {
  List<SingleOrder> orders = []; //whole orders

  // Object with add one Purchase to Table UI
  PurchaseOrder purchaseOrder = PurchaseOrder();

  @override
  void initState() {
    super.initState();
    //Listener which listen to the object purchaseOrder.
    //By every tap on the button in the purchaseOrder UI, this class gets an impulse
    purchaseOrder.addListener(addSingleOrder);
  }

//to add Purchase to the table
  addSingleOrder() {
    setState(() {
      orders.add(SingleOrder(purchaseOrder.quantitySelector.getQuantity(),
          purchaseOrder.isStandingOrder, purchaseOrder.chosenProduct));
    });
  }

  @override
  Widget build(BuildContext context) {
//tablewidth (with 340 as a fix size for amount, delete, isStandingAlone and margins of Columns)
    final displayWidthforTable = MediaQuery.of(context).size.width - 340;
    return Scaffold(
      appBar: ab.Appbar.MainAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //to Add Purchase to List orders
              purchaseOrder,

              HeaderKit.header1("Bestellübersicht"),

              orders.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Center(
                          child: Text(
                        "Es sind keine Einträge vorhanden!",
                        style: TextStyle(fontSize: 14),
                      )))
                  : Container(
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
                              columns: SingleOrder.DataTableColumnsGerman,
                              rows: orders
                                  .map(
                                    (order) => DataRow(

                                        //selected: true,
                                        cells: [
                                          DataCell(
                                            Container(
                                              constraints: const BoxConstraints(
                                                  minWidth: 160),
                                              width: displayWidthforTable *
                                                  0.48, //SET width
                                              child: Text(
                                                order.identifier,
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width: 55, //SET width
                                              child: Text(
                                                order.amount.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                          DataCell(
                                            Container(
                                              constraints: const BoxConstraints(
                                                  minWidth: 70),
                                              width:
                                                  displayWidthforTable * 0.26,
                                              child: Text(
                                                TextKit.textwithEuro(
                                                    order.price),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                          DataCell(
                                            Container(
                                              constraints: const BoxConstraints(
                                                  minWidth: 70),
                                              width:
                                                  displayWidthforTable * 0.26,
                                              child: Text(
                                                TextKit.textwithEuro(
                                                    order.price * order.amount),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                width: 70,
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
                                                width: 70,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          orders.remove(order);
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
                  child: const Text(
                    "Kostenpflichtig bestellen",
                    // style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

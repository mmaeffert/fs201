import 'package:broetchenservice/order/UI/ordersTable.dart';
import 'package:broetchenservice/order/UI/purchaseOrder.dart';
import 'package:flutter/material.dart';

import '../singleOrder.dart';
import '../wholeOrder.dart';
import 'package:broetchenservice/appbar.dart' as ab;

import 'ordersTable.dart';

class OrderLayout extends StatefulWidget with ChangeNotifier{
  OrderLayout({Key? key}) : super(key: key);

  @override
  State<OrderLayout> createState() => _OrderLayoutState();
}

class _OrderLayoutState extends State<OrderLayout> {

  late WholeOrder wholeOrder; //All orders with User info
  late PurchaseOrder purchaseOrder;
  OrdersTable ordersTable = OrdersTable();

  @override
  void initState() {
    purchaseOrder =  PurchaseOrder(ordersTable);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: ab.Appbar.MainAppBar(context),
      body: SingleChildScrollView(
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          purchaseOrder,
          ordersTable
        ],
      ),
      ),
    );
  }
}

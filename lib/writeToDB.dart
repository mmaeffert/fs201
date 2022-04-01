import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class writeToDB {
  final database = FirebaseDatabase.instance.ref();

  //Writes an Order to DB
  writeOrder(WholeOrder order) {
    final orderNode = database.child('/bestellungen/' + '10');

    //Create composition JSON data
    var orderListJson = [];
    order.orderList.forEach((singleOrder) {
      orderListJson.add({
        'identifier': singleOrder.identifier,
        'amount': singleOrder.amount,
        'price': singleOrder.price
      });
    });

    var query = {
      'uid': order.userID,
      'value': order.wholeOrderValue,
      'time': {".sv": "timestamp"},
      'composition': orderListJson
    };

    orderNode
        .set(query)
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));
  }
}

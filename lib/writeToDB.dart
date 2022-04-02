import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class writeToDB {
  final database = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  //Writes an Order to DB
  writeOrder(WholeOrder order) {
    final orderNode = database.child('/bestellungen/').push();

    final orderID = orderNode.key;

    //Create composition JSON data
    var orderListJson = [];
    order.orderList.forEach((singleOrder) {
      orderListJson.add({
        'identifier': singleOrder.identifier,
        'amount': singleOrder.amount,
        'price': singleOrder.price,
        'status': singleOrder.status
      });
    });

    var query = <String, dynamic>{
      'uid': order.userID,
      'value': order.wholeOrderValue,
      'time': {".sv": "timestamp"},
      'composition': orderListJson
    };

    orderNode
        .set(query)
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));

    database
        .child('/user_order/' + user!.uid)
        .update({orderID!: 1})
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));
    ;

    double orderValue = 0;
    order.orderList.forEach((singleOrder) {
      orderValue += singleOrder.amount * singleOrder.price;
    });

    changeUserBalance(orderValue * (-1), "from order", orderID);
  }

  updateUser() {
    final userEntry = database.child('/users/' + user!.uid);

    var query = <String, dynamic>{
      'name': user!.displayName,
      'mail': user!.email,
    };

    userEntry
        .update(query)
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));
  }

  changeUserBalance(double balance, String comment, String orderID) {
    print("BALANCE: " + balance.toString());

    if (balance == 0) {
      throw new Exception("Balance must be positive");
    }

    final balanceTable = database.child('/balance/' + user!.uid);

    var query = <String, dynamic>{
      DateTime.now().millisecondsSinceEpoch.toString(): {
        'balance': balance,
        'comment': (comment == "") ? "no comment" : comment,
        'orderID': (orderID == "") ? "N/A" : orderID
      }
    };

    balanceTable
        .update(query)
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));
  }
}

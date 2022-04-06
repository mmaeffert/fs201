import 'dart:collection';

import 'package:broetchenservice/order/product.dart';
import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ReadFromDB with ChangeNotifier {
  final database = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  getOrderList() async {
    print("hello");
    print(user!.uid);
    List<WholeOrder> wholeOrderList = [];
    DataSnapshot orders;
    LinkedHashMap<String, String> ordersMap;

    orders = await database.child('/user_order/' + user!.uid).get();

    print('orders.value: ' + orders.value.toString());

    ordersMap = LinkedHashMap<String, String>.from(
        orders.value as LinkedHashMap<Object?, Object?>);

    print('ordersMap: ' + ordersMap.toString());

    Iterable keySet = ordersMap.keys;

    print('keySet: ' + keySet.toString());

    for (String key in keySet) {
      List<SingleOrder> singleOrderList =
          await getSingleOrdersFromID(ordersMap[key]!);
      print('New SingleOrderList: ' + singleOrderList.toString());
      wholeOrderList.add(WholeOrder(
        singleOrderList,
      ));
    }

    for (WholeOrder wo in wholeOrderList) {
      print('NEW WHOLEORDER:\n ' + wo.toString());
    }

    return wholeOrderList;
  }

  getUserBalance() async {
    DataSnapshot ds =
        await database.child('/users/' + user!.uid + '/balance/').get();
    return ds.value;
  }

  Future<bool> userCanAfford(double balanceToAdd) async {
    balanceToAdd *= -1;
    var userBalance = await getUserBalance();
    userBalance = userBalance.toDouble();
    double userBalanceLimit = await getUserBalanceLimit();

    print('claculation: ' +
        ((userBalance + balanceToAdd) >= userBalanceLimit).toString());

    return ((userBalance + balanceToAdd) >= userBalanceLimit);
  }

  Future<double> getUserBalanceLimit() async {
    var userBalance;
    String userRole = "";
    await getUserRole().then((value) => userRole = value);
    await database
        .child('/balance_limit/' + userRole)
        .get()
        .then((value) => userBalance = value.value);
    print('USERBALANCE LIMIT: ' + userBalance.toString());
    return userBalance.toDouble();
  }

  Future<String> getUserRole() async {
    String userRole = "";
    await database.child('/users/' + user!.uid + '/role/').get().then((value) {
      userRole = value.value as String;
    });
    print('USER ROLE: ' + userRole);
    return userRole;
  }

  Future<bool> userAlreadyExists() async {
    DataSnapshot snapshot = await database.child('/user/' + user!.uid).get();
    return (snapshot.value == null) ? false : true;
  }

  getSingleOrdersFromID(String orderID) async {
    List<SingleOrder> singleOrderList = [];

    await database
        .child('/orders/' + orderID + '/composition/')
        .get()
        .then((composition) {
      final data = composition.value as List<dynamic>;
      data.forEach((key) {
        final temp = SingleOrder(
            key['amount'], true, Product(key['price'], key['identifier']));

        singleOrderList.add(temp);
      });
    });
    print('END OF FUNCTION' + singleOrderList.toString());
    singleOrderList.forEach((element) {
      //print('in list: ' + element.toString());
    });
    return singleOrderList;
  }
}

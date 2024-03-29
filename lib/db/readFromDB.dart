// ignore_for_file: unnecessary_null_comparison

import 'dart:collection';

import 'package:broetchenservice/balance.dart';
import 'package:broetchenservice/order/product.dart';
import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ReadFromDB with ChangeNotifier {
  final database = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  // Als ich anfing diese Funktion zu schreiben, wussten nur Gott und ich wie der Code funktioniert
  // Jetzt weiß es nur noch Gott
  // Respekt an jeden der versucht das zu verbessern
  // Solltest du es schaffen, verewige dich in diesem Kommentar
  getOrderList() async {
    List<WholeOrder> wholeOrderList = [];
    DataSnapshot orders;
    LinkedHashMap<String, String> ordersMap;

    orders = await database
        .child('/user_order/' + user!.uid)
        .orderByKey()
        .limitToLast(10)
        .get();

    ordersMap = LinkedHashMap<String, String>.from(
        orders.value as LinkedHashMap<Object?, Object?>);

    Iterable keySet = ordersMap.keys;

    for (String key in keySet) {
      List<SingleOrder> singleOrderList =
          await getSingleOrdersFromID(ordersMap[key]!);

      DataSnapshot wholeOrderSnapshot =
          await database.child('/orders/' + ordersMap[key]!).get();
      var wholeOrderProperties = LinkedHashMap<String, dynamic>.from(
          wholeOrderSnapshot.value as LinkedHashMap<Object?, Object?>);

      wholeOrderList.add(WholeOrder(
          singleOrderList,
          wholeOrderProperties['standingOrder'],
          wholeOrderProperties['status'],
          wholeOrderProperties['orderid'],
          wholeOrderProperties['timestamp']));
    }

    return wholeOrderList;
  }

  Future<double> getUserBalance() async {
    if (user != null) {
      DataSnapshot ds =
          await database.child('/users/' + user!.uid + '/balance/').get();
      return double.parse(ds.value.toString());
    } else {
      return 0.0;
    }
  }

  //Gets BalanceList from Database
  Future<List<Balance>> getBalanceList() async {
    DataSnapshot ds = await database.child('/balance/' + user!.uid).get();

    var balanceMap =
        LinkedHashMap.from(ds.value as LinkedHashMap<Object?, Object?>);

    Iterable<dynamic> keySet = balanceMap.keys;

    List<Balance> balanceList = [];

    for (String key in keySet) {
      balanceList.add(Balance(
          int.parse(key),
          double.parse(balanceMap[key]['balance'].toString()),
          balanceMap[key]['comment'],
          balanceMap[key]['orderID'].toString()));
    }

    return balanceList;
  }

  Future<WholeOrder> getOpenOrder() async {
    DataSnapshot ds = await database.child('/open_orders/' + user!.uid).get();
    ds = await database.child('/orders/' + ds.value.toString()).get();

    var openOrder =
        LinkedHashMap.from(ds.value as LinkedHashMap<Object?, Object?>);

    return WholeOrder(await getSingleOrdersFromID(openOrder['orderid']),
        openOrder['standingOrder'], openOrder['status'], openOrder['orderid']);
  }

  //Gets Produktlist depending on current userrole
  Future<List<Product>> getProductList() async {
    List<Product> productList = [];
    String userRole = await getUserRole();
    if (userRole == "") {
      userRole = 'customer';
    }

    DataSnapshot ds = await database.child('/products/').get();

    LinkedHashMap<Object?, Object?> productMap =
        LinkedHashMap.from(ds.value as LinkedHashMap<Object?, Object?>);

    Iterable<dynamic> keySet = productMap.keys;

    for (String key in keySet) {
      LinkedHashMap priceForUser =
          LinkedHashMap.from(productMap[key] as LinkedHashMap);

      productList
          .add(Product(double.parse(priceForUser[userRole].toString()), key));
    }
    return productList;
  }

  Future<bool> userCanAfford(double balanceToAdd) async {
    balanceToAdd *= -1;
    var userBalance = await getUserBalance();
    userBalance = userBalance.toDouble();
    double userBalanceLimit = await getUserBalanceLimit();

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
    return userBalance.toDouble();
  }

  Future<String> getUserRole() async {
    String userRole = "";
    await database.child('/users/' + user!.uid + '/role/').get().then((value) {
      userRole = value.value as String;
    });
    return userRole;
  }

  Future<bool> userAlreadyExists() async {
    if (user == null) {
      return false;
    }
    DataSnapshot snapshot = await database.child('/users/' + user!.uid).get();
    return snapshot.exists;
  }

  userAlreadyHasOpenOrder() async {
    DataSnapshot ds = await database.child('/open_orders/' + user!.uid).get();
    return ds.exists;
  }

  userAlreadyHasStandingOrder() async {
    DataSnapshot ds =
        await database.child('/standingorders/' + user!.uid).get();

    return ds.exists;
  }

  getStandingOrder() async {
    DataSnapshot ds =
        await database.child('/standingorders/' + user!.uid).get();
    return ds.value;
  }

  getOrderStatus(String orderID) async {
    DataSnapshot ds = await database.child('/orders/' + orderID).get();
    final order =
        LinkedHashMap.from(ds.value as LinkedHashMap<Object?, Object?>);
    return order['status'];
  }

  getSingleOrdersFromID(String orderID) async {
    List<SingleOrder> singleOrderList = [];

    await database
        .child('/orders/' + orderID + '/composition/')
        .get()
        .then((composition) {
      final data = composition.value as List<dynamic>;
      for (var key in data) {
        final temp = new SingleOrder(
            key['amount'], new Product(key['price'], key['identifier']));

        singleOrderList.add(temp);
      }
    });

    return singleOrderList;
  }

  Future<bool> userHasAssignedClass() async {
    DataSnapshot ds =
        await database.child('/users/' + user!.uid + '/class/').get();
    print('Does he have  class assigned?:  ' + ds.exists.toString());
    return ds.exists;
  }
}

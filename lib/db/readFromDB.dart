import 'dart:collection';
import 'dart:convert';

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

  getSingleOrdersFromID(String orderID) async {
    List<SingleOrder> singleOrderList = [];

    await database
        .child('/orders/' + orderID + '/composition/')
        .get()
        .then((composition) {
      //print('Composition: ' + composition.value.toString());

      final data = composition.value as List<dynamic>;
      //print('data: ' + data.toString());
      data.forEach((key) {
        // singleOrderList.add(new SingleOrder(
        //     key['amount'], true, new Product(key['price'], key['identifier'])));
        // print('PRICE: ' + key['price'].toString());
        // print('AMOUNT: ' + key['amount'].toString());

        // print('IDENTIFIER: ' + key['identifier']);

        final temp = new SingleOrder(
            key['amount'], true, new Product(key['price'], key['identifier']));
        //print(temp.toString());
        //print('before add');
        singleOrderList.add(temp);
        //print(singleOrderList.toString());
        //print('after add');
      });
      // data.forEach((key, value) {
      //   print('Value: ' + value);
      //   // print('identifier: ' + value['identifier']);
      //   // singleOrderList.add(new SingleOrder(value['price'], true,
      //   //     new Product(value['price'], value['identifier'])));
      // });
    });
    print('END OF FUNCTION' + singleOrderList.toString());
    singleOrderList.forEach((element) {
      //print('in list: ' + element.toString());
    });
    return singleOrderList;
  }
}

//This class represents a whole order, consisting of many singleOrders

import 'package:broetchenservice/order/singleOrder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WholeOrder {
  double wholeOrderValue = 0; //Value of all SingleOrders
  String userID = ""; //Unique User ID fetched from Google account data
  late List<SingleOrder> orderList;
  var timeStamp = 0;

  @override
  toString() {
    String result = "";
    result += 'Value: ' +
        wholeOrderValue.toString() +
        '\nuserID: ' +
        userID +
        ' Timestamp: ' +
        DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true).toString() +
        '\n';
    for (SingleOrder so in orderList) {
      result += '---' + so.toString() + '\n';
    }
    return result;
  }

  WholeOrder(List<SingleOrder> orderList) {
    //Setting unique user id
    final user = FirebaseAuth.instance.currentUser;
    userID = user!.uid;

    timeStamp = DateTime.now().millisecondsSinceEpoch;

    //Setting wholeOrderValue
    this.orderList = orderList;
    wholeOrderValue = getOrderValue();

    //Check if order is empty
    // if (wholeOrderValue == 0) {
    //   throw new Exception("Empty Order");
    // }
  }

  //Calculates whole order value
  getOrderValue() {
    double sum = 0;
    this.orderList.forEach((singleOrder) {
      sum += singleOrder.amount * singleOrder.price;
    });
    return sum;
  }
}

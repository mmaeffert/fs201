//This class represents a whole order, consisting of many singleOrders

import 'package:broetchenservice/order/singleOrder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WholeOrder {
  String status = 'o';
  bool standingOrder = false;
  double wholeOrderValue = 0; //Value of all SingleOrders
  String userID = ""; //Unique User ID fetched from Google account data
  late List<SingleOrder> orderList;
  var timeStamp = 0;
  String? orderID = "";

  getStatus() {
    return status;
  }

  @override
  toString() {
    String result = "";
    result += 'Value: ' +
        wholeOrderValue.toString() +
        '\nuserID: ' +
        userID +
        ' Timestamp: ' +
        DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true).toString() +
        '\n' +
        ' StandingOrder: ' +
        standingOrder.toString() +
        '\n OrderID: ' +
        orderID.toString() +
        '\n status: ' +
        status +
        '\n';
    for (SingleOrder so in orderList) {
      result += '---' + so.toString() + '\n';
    }
    return result;
  }

  WholeOrder(List<SingleOrder> orderList, bool standingOrder, String status,
      [String? orderID, int? timestamp]) {
    this.orderID = orderID;
    this.status = status;
    this.standingOrder = standingOrder;
    //Setting unique user id
    final user = FirebaseAuth.instance.currentUser;
    userID = user!.uid;

    if (timestamp != null) {
      this.timeStamp = timestamp;
    } else {
      timeStamp = DateTime.now().millisecondsSinceEpoch;
    }

    //Setting wholeOrderValue
    this.orderList = orderList;
    wholeOrderValue = getOrderValue();

    //Check if order is empty
    // if (wholeOrderValue == 0) {
    //   throw new Exception("Empty Order");
    // }
  }

  updateOrderValue() {
    wholeOrderValue = 0;
    for (SingleOrder so in orderList) {
      wholeOrderValue += so.price * so.amount;
    }
    wholeOrderValue = double.parse(wholeOrderValue.toStringAsFixed(2));
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

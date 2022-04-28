import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class writeToDB {
  final database = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  //Writes an Order to DB
  Future<String> writeOrder(WholeOrder order) async {
    //Checks if user can afford
    bool userCanAfford = false;
    await ReadFromDB()
        .userCanAfford(order.getOrderValue())
        .then((value) => userCanAfford = value);

    print('Can he afford?: ' + userCanAfford.toString());
    if (!userCanAfford) {
      return "user cant afford";
    }

    //Checks if order is empty
    bool isEmptyOrder = true;
    int orderAmountSum = 0;
    for (SingleOrder so in order.orderList) {
      orderAmountSum += so.amount;
    }
    if (order.wholeOrderValue <= 0 || orderAmountSum <= 0) {
      return "empty order";
    }

    //Checks if user already has an open order
    if (await ReadFromDB().userAlreadyHasOpenOrder()) {
      return "has open order";
    }

    //Checks if user already has open order
    if (order.standingOrder &&
        await ReadFromDB().userAlreadyHasStandingOrder()) {
      return "has standingorder";
    }

    final orderNode = database.child('/orders/').push();
    final orderID = orderNode.key;
    //Create composition JSON data
    var orderListJson = [];
    order.orderList.forEach((singleOrder) {
      orderListJson.add({
        'identifier': singleOrder.identifier,
        'amount': singleOrder.amount,
        'price': singleOrder.price,
      });
    });

    //Creates wholeorder Object as JSON
    var query = <String, dynamic>{
      'uid': order.userID,
      'value': order.wholeOrderValue.toStringAsFixed(2),
      'composition': orderListJson,
      'timestamp': order.timeStamp,
      'status': order.status,
      'standingOrder': order.standingOrder,
      'orderid': orderID
    };
    print('Standingorder?????: ' + order.standingOrder.toString());

    //writes into "orders" table
    orderNode
        .set(query)
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));

    //writes into "open_orders" table
    database
        .child('/open_orders/')
        .set({user!.uid: query})
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));

    //Writes into "standingorders"
    if (order.standingOrder) {
      database
          .child('/standingorders/')
          .set({user!.uid: query})
          .then((value) => print("Erfolgreich geschrieben"))
          .catchError((onError) => print(onError));
    }

    //Writes into assist table user_order, which saves the orders a certain user did
    database
        .child('/user_order/' + user!.uid)
        .push()
        .set(orderID)
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));

    //calculates the value of the whole order
    double orderValue = 0;
    order.orderList.forEach((singleOrder) {
      orderValue += singleOrder.amount * singleOrder.price;
    });

    //makes entry in "balance" table
    changeUserBalance(orderValue * (-1), "from order", orderID!);

    return "success";
  }

  //Cancels an order
  cancelOrder(WholeOrder wo) async {
    DataSnapshot ds = await database.child('/open_orders/' + user!.uid).get();
    ds.ref.remove();

    database.child('/orders/' + wo.orderID!).update({'status': 'c'});

    changeUserBalance(wo.wholeOrderValue, "Caneled order", wo.orderID!);
  }

  //Deletes standing Order
  deleteStandingOrder() async {
    DataSnapshot ds =
        await database.child('/standingorders/' + user!.uid).get();
    ds.ref.remove();
  }

  //Updates user data
  updateUser() async {
    final userEntry = database.child('/users/' + user!.uid);

    var query = <String, dynamic>{
      'name': user!.displayName,
      'mail': user!.email,
    };

    await ReadFromDB().userAlreadyExists().then((value) {
      if (!value) {
        query.addAll({'role': 'customer', 'balance': 0.0});
      }
    });

    userEntry
        .update(query)
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));
  }

  //Changes user balance positively or negatively
  //Leave comment as "" if you do not want to leave a comment
  //Leave order ID as "" if you do not want to leace an order id
  changeUserBalance(double balance, String comment, String orderID) async {
    //Creates reference to balance table
    final balanceTable = database.child('/balance/' + user!.uid);

    var query = <String, dynamic>{
      DateTime.now().millisecondsSinceEpoch.toString(): {
        'balance': double.parse(balance.toStringAsFixed(2)),
        'comment': (comment == "") ? "no comment" : comment,
        'orderID': (orderID == "") ? "N/A" : orderID
      }
    };

    balanceTable
        .update(query)
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));

    var currentBalance = await ReadFromDB().getUserBalance();
    currentBalance = (currentBalance == null) ? 0.0 : currentBalance.toDouble();
    print('Current balance: ' + currentBalance.toString());
    database
        .child('/users/' + user!.uid)
        .update({'balance': currentBalance + balance});
  }
}

import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class writeToDB {
  final database = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  //Writes an Order to DB
  Future<bool> writeOrder(WholeOrder order) async {
    bool userCanAfford = false;
    await ReadFromDB()
        .userCanAfford(order.getOrderValue())
        .then((value) => userCanAfford = value);

    print('Can he afford?: ' + userCanAfford.toString());
    if (!userCanAfford) {
      return false;
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
        'status': singleOrder.status
      });
    });

    //Creates wholeorder Object as JSON
    var query = <String, dynamic>{
      'uid': order.userID,
      'value': order.wholeOrderValue,
      'time': {".sv": "timestamp"},
      'composition': orderListJson,
      'timestamp': order.timeStamp
    };

    //writes into "orders" table
    orderNode
        .set(query)
        .then((value) => print("Erfolgreich geschrieben"))
        .catchError((onError) => print(onError));

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

    //Adjust user balance
    var currentBalance = await ReadFromDB().getUserBalance();
    currentBalance = (currentBalance == null) ? 0.0 : currentBalance.toDouble();
    print('Current balance: ' + currentBalance.toString());
    database
        .child('/users/' + user!.uid)
        .update({'balance': currentBalance + orderValue * (-1)});
    return true;
  }

  //Updates user data
  updateUser() async {
    final userEntry = database.child('/users/' + user!.uid);

    var query = <String, dynamic>{
      'name': user!.displayName,
      'mail': user!.email,
    };

    await ReadFromDB().userAlreadyExists().then((value) {
      if (value == false) {
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
  changeUserBalance(double balance, String comment, String orderID) {
    //Creates reference to balance table
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

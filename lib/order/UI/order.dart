import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/db/writeToDB.dart';
import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:broetchenservice/themes.dart';
import 'package:flutter/material.dart';
import '../../appbar.dart' as ab;
import '../product.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  double checkoutCart = 60;
  bool expanded = false;
  WholeOrder wo = new WholeOrder([], false, 'o');
  List<Container> cardList = [];
  bool isloaded = false;
  List<SingleOrder> singleOrderList = [];
  List<Container> shoppingcartWidgets = [];
  bool standingOrder = false;
  bool orderThrough = false;

  @override
  void initState() {
    generateProductCards().then((value) {
      setState(() {
        isloaded = true;
      });
    });
    wo.orderList = singleOrderList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ab.Appbar.MainAppBar(context),
      body: Stack(
        children: [
          // Cards with Product Information
          Wrap(
            children: !isloaded ? [CircularProgressIndicator()] : cardList,
          ),

          //Shoppingcart
          WillPopScope(
              onWillPop: () async {
                if (checkoutCart > 60) {
                  checkoutCart = 60;
                  setState(() {});
                  return false;
                }
                return true;
              },
              child: Container(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: InkWell(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          color: currentTheme.getPrimaryColor(),
                          width: MediaQuery.of(context).size.width,
                          height: checkoutCart,
                          child: Column(children: [
                            Row(
                              children: [
                                Icon(Icons.shopping_bag, size: 50),
                                Container(
                                  padding: EdgeInsetsDirectional.only(top: 12),
                                  child: Text(
                                    wo.wholeOrderValue.toString() + " \$",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: currentTheme.getTextColor(),
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),

                            //Current items in the shopping cart
                            Column(
                              children: shoppingcartWidgets,
                            ),

                            //Finish order area
                            Container(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: Row(
                                children: [
                                  Text("Dauerauftrag  "),
                                  Checkbox(
                                      value: standingOrder,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          standingOrder = value!;
                                          wo.standingOrder = standingOrder;
                                        });
                                      }),
                                  ElevatedButton(
                                      onPressed: () {
                                        sendOrder(wo).then((value) {
                                          singleOrderList = [];
                                          shoppingcartWidgets = [];
                                          setState(() {});
                                        });
                                      },
                                      child: Text("Bestellung aufgeben"))
                                ],
                              ),
                            )
                          ]),
                        ),
                        onTap: () {
                          if (expanded) {
                            checkoutCart = 60;
                            expanded = false;
                          } else {
                            checkoutCart = 500;
                            expanded = true;
                          }
                          setState(() {});
                        },
                      ))))
        ],
      ),
    );
  }

  Future<List<Container>> generateProductCards() async {
    List<Product> productList = await ReadFromDB().getProductList();

    for (Product product in productList) {
      cardList.add(Container(
          //width: MediaQuery.of(context).size.width / 2.1,
          height: 50,
          child: GestureDetector(
            child: Card(
              color: currentTheme.getPrimaryColor(),
              child: Row(
                children: [
                  Text(product.identifier, style: TextStyle(fontSize: 15)),
                  Text('  ' + product.price.toString())
                ],
              ),
            ),
            onTap: () {
              showTopSnackBar(
                context,
                CustomSnackBar.success(
                    icon: Icon(Icons.sentiment_very_satisfied,
                        color: const Color(0x15000000), size: 60),
                    backgroundColor: Color.fromARGB(255, 122, 145, 126),
                    message: "Wurde zum Warenkorb hinzugefügt"),
                showOutAnimationDuration: Duration(milliseconds: 700),
                hideOutAnimationDuration: Duration(milliseconds: 300),
                displayDuration: Duration(milliseconds: 1500),
                additionalTopPadding: -20,
              );
              addToShoppingCart(SingleOrder(
                  getAmountOfAProduct(product.identifier), product));
            },
          )));
    }
    return cardList;
  }

  bool isProductAlreadyInCart(SingleOrder so) {
    for (SingleOrder soList in singleOrderList) {
      if (soList.identifier == so.identifier) {
        return true;
      }
    }
    return false;
  }

  //Adds a procut to the shopping cart
  addToShoppingCart(SingleOrder so) {
    for (SingleOrder soList in singleOrderList) {
      if (soList.identifier == so.identifier) {
        soList.amount++;
      }
    }

    if (!isProductAlreadyInCart(so)) {
      singleOrderList.add(SingleOrder(1, Product(so.price, so.identifier)));
    }

    updateShoppingCartWidgets(so);
    wo.updateOrderValue();

    setState(() {});
  }

  // Completely generates the shopping cart item widgets
  updateShoppingCartWidgets(SingleOrder so) {
    shoppingcartWidgets = [];
    for (SingleOrder soList in singleOrderList) {
      if (soList.amount > 0) {
        shoppingcartWidgets.add(Container(
          child: Row(
            children: [
              Text(soList.identifier),
              Text(soList.price.toString() + ' \$'),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        changeShoppingCartAmount(soList, -1);
                      },
                      icon: Icon(Icons.arrow_back_outlined)),
                  Text(soList.amount.toString()),
                  IconButton(
                      onPressed: () {
                        changeShoppingCartAmount(soList, 1);
                      },
                      icon: Icon(Icons.arrow_forward_outlined)),
                ],
              )
            ],
          ),
        ));
      }
    }
  }

  //Increases or decreases the amount in the shopping cart
  changeShoppingCartAmount(SingleOrder so, int amount) {
    if (so.amount == 0 && amount < 0) {
      return;
    }
    so.amount += amount;
    wo.updateOrderValue();
    updateShoppingCartWidgets(so);
    setState(() {});
  }

  int getAmountOfAProduct(String identifier) {
    for (SingleOrder so in singleOrderList) {
      if (so.identifier == identifier) {
        return so.amount;
      }
    }
    return 0;
  }

  //processes order
  Future sendOrder(WholeOrder _wo) async {
    var result = await writeToDB().writeOrder(_wo);
    orderThrough = true;
    switch (result) {
      case "user cant afford":
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Du hast leider nicht genügend Guthaben für diese Bestellung. Melde dich dafür bei Max"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK")),
                  ]);
            });
        break;

      case "empty order":
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Du kannst keine leere Bestellung einreichen..."),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Schade")),
                  ]);
            });
        break;

      case "has standingorder":
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Du hast noch einen offenen Dauerauftrag. Sollen wir ihn ersetzen?"),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await writeToDB().deleteStandingOrder();
                          sendOrder(_wo);
                          Navigator.of(context).pop();
                        },
                        child: Text("ja")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Nein"))
                  ]);
            });
        break;

      case "has open order":
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Du hast noch eine offene Bestellung. Sollen wir sie ersetzen?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          ReadFromDB()
                              .getOpenOrder()
                              .then((value) => writeToDB().cancelOrder(value));
                          sendOrder(_wo);
                          Navigator.of(context).pop();
                        },
                        child: Text("ja")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Nein"))
                  ]);
            });
        break;

      case "success":
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Deine Bestellung ist eingegangen. Thanks for being a Brötchenservice customer"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK")),
                  ]);
            });
        break;

      default:
        print("result: " + result.toString());
        break;
    }
  }
}

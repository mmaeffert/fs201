import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/db/writeToDB.dart';
import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:broetchenservice/orderList.dart';
import 'package:broetchenservice/themes.dart';
import 'package:flutter/material.dart';
import '../../appbar.dart' as ab;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'order/product.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  double checkoutCart = 60;
  bool expanded = false;
  WholeOrder wo = WholeOrder([], false, 'o');
  List<Container> cardList = [];
  bool isloaded = false;
  List<SingleOrder> singleOrderList = [];
  List<Container> shoppingcartWidgets = [];
  bool standingOrder = false;
  bool orderThrough = false;
  bool shoppingCartActive = false;
  double checkoutCartValue = 0.0;

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
          ListView(
            children: !isloaded
                ? [CircularProgressIndicator()]
                : cardList +
                [
                  Container(
                    height: 20,
                  )
                ],
          ),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: InkWell(
                  child: Container(
                    height: 55,
                    color: currentTheme.getPrimaryColor(),
                    alignment: FractionalOffset.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    child: Row(children: [
                      Icon(
                        Icons.shopping_bag,
                        size: 50,
                      ),
                      Text(
                        wo.wholeOrderValue.toString() + ' Euro',
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
                  ),
                  //onTap: () => _showBottonSheet(),
                  onTap: () {
                    print(':(');
                    showModalBottomSheet(
                        backgroundColor: currentTheme.getPrimaryColor(),
                        context: context,
                        builder: (BuildContext context) {
                          return BottomSheet(
                              onClosing: () {},
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                    StateSetter setState) {
                                  return Column(children: [
                                    Row(
                                      children: [
                                        Icon(Icons.shopping_bag, size: 50),
                                        Container(
                                          padding: EdgeInsetsDirectional.only(
                                              top: 12),
                                          child: Text(
                                            wo.wholeOrderValue.toString() +
                                                " \$",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                currentTheme.getTextColor(),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),

                                    //Current items in the shopping cart
                                    Expanded(
                                      child: ListView(
                                          children: updateShoppingCartWidgets(
                                              context, setState)),
                                    ),

                                    //Finish order area
                                    Align(
                                      alignment: FractionalOffset.bottomCenter,
                                      child: Container(
                                        alignment:
                                        AlignmentDirectional.bottomCenter,
                                        child: Row(
                                          children: [
                                            Text("Dauerauftrag  "),
                                            Checkbox(
                                                value: standingOrder,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    standingOrder = value!;
                                                    wo.standingOrder =
                                                        standingOrder;
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
                                                child:
                                                Text("Bestellung aufgeben"))
                                          ],
                                        ),
                                      ),
                                    )
                                  ]);
                                });
                              });
                        });
                  }))
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
              color: CustomTheme.darkTheme.backgroundColor,
              child: Row(
                children: [
                  Text(product.identifier, style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Text(
                    '  ' + product.price.toString() + ' €   ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                        color: currentTheme.getPrimaryColor()),
                    child: IconButton(
                        onPressed: () {
                          showTopSnackBar(
                            context,
                            CustomSnackBar.success(
                                icon: Icon(Icons.sentiment_very_satisfied,
                                    color: const Color(0x15000000), size: 60),
                                backgroundColor:
                                Color.fromARGB(255, 122, 145, 126),
                                message: "Wurde zum Warenkorb hinzugefügt"),
                            showOutAnimationDuration:
                            Duration(milliseconds: 700),
                            hideOutAnimationDuration:
                            Duration(milliseconds: 300),
                            displayDuration: Duration(milliseconds: 1500),
                            additionalTopPadding: -20,
                          );
                          addToShoppingCart(SingleOrder(
                              getAmountOfAProduct(product.identifier),
                              product));
                        },
                        icon: Icon(Icons.plus_one_outlined)),
                  )
                ],
              ),
            ),
          )));
      cardList.add(Container(
          width: MediaQuery.of(context).size.width,
          child: Divider(
            color: currentTheme.getPrimaryColor(),
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

    wo.updateOrderValue();

    setState(() {});
  }

  // Completely generates the shopping cart item widgets
  updateShoppingCartWidgets(BuildContext context, StateSetter setState) {
    shoppingcartWidgets = [];
    for (SingleOrder soList in singleOrderList) {
      if (soList.amount > 0) {
        shoppingcartWidgets.add(Container(
          child: Row(
            children: [
              Text(soList.identifier),
              Text(soList.price.toString() + ' \$'),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        changeShoppingCartAmount(soList, -1);
                        updateShoppingCartWidgets(context, setState);
                        setState(() {});
                      },
                      icon: Icon(Icons.arrow_back_outlined)),
                  Text(soList.amount.toString()),
                  IconButton(
                      onPressed: () {
                        changeShoppingCartAmount(soList, 1);
                        updateShoppingCartWidgets(context, setState);
                        setState(() {});
                      },
                      icon: Icon(Icons.arrow_forward_outlined)),
                ],
              )
            ],
          ),
        ));
      }
    }
    return shoppingcartWidgets;
  }

  //Increases or decreaschangeShoppingCartAmountes the amount in the shopping cart
  changeShoppingCartAmount(SingleOrder so, int amount) {
    print(wo);
    if (so.amount == 0 && amount < 0) {
      return;
    }
    so.amount += amount;
    wo.updateOrderValue();
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
    print('RESULT:  ' + result.toString());
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
                        onPressed: () async {
                          await ReadFromDB()
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

      default:
        if (result[0] == 'success') {
          setState(() {});
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
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderList(
                                      openTiles: [result[1].toString()],
                                    )));
                          },
                          child: Text("OK")),
                    ]);
              });
        }
        break;
    }
  }
}

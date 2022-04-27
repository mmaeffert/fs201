import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/db/writeToDB.dart';
import 'package:broetchenservice/order/singleOrder.dart';
import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:broetchenservice/themes.dart';
import 'package:flutter/material.dart';
import '../../appbar.dart' as ab;
import '../product.dart';

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

  @override
  void initState() {
    generateProductCards().then((value) {
      setState(() {
        isloaded = true;
      });
      print('CRDLIST: ' + cardList.toString());
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
          Wrap(
            children: !isloaded ? [CircularProgressIndicator()] : cardList,
          ),
          Expanded(
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
                        Column(
                          children: shoppingcartWidgets,
                        ),
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
                                    });
                                  }),
                              ElevatedButton(
                                  onPressed: () {
                                    writeToDB().writeOrder(wo);
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
                  )))
        ],
      ),
    );
  }

  Future<List<Container>> generateProductCards() async {
    List<Product> productList = await ReadFromDB().getProductList();

    for (Product product in productList) {
      cardList.add(Container(
          width: MediaQuery.of(context).size.width / 2.1,
          height: 50,
          child: GestureDetector(
            child: Card(
              color: currentTheme.getPrimaryColor(),
              child: Column(
                children: [
                  Text(product.identifier),
                  Text(product.price.toString())
                ],
              ),
            ),
            onTap: () {
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

  addToShoppingCart(SingleOrder so) {
    for (SingleOrder soList in singleOrderList) {
      if (soList.identifier == so.identifier) {
        print('test');
        print(soList.amount + 1);

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
                        changeShoppingCartAmoung(soList, -1);
                      },
                      icon: Icon(Icons.arrow_back_outlined)),
                  Text(soList.amount.toString()),
                  IconButton(
                      onPressed: () {
                        changeShoppingCartAmoung(soList, 1);
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

  changeShoppingCartAmoung(SingleOrder so, int amount) {
    if (so.amount == 0 && amount < 0) {
      return;
    }
    print(so.amount);
    print(amount);
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
}

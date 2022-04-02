import 'package:broetchenservice/order/wholeOrder.dart';
import 'package:broetchenservice/themes.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import '../../quantitySelector.dart';
import '../product.dart';
import 'package:broetchenservice/themes.dart';

import '../singleOrder.dart';
import 'ordersTable.dart';

class PurchaseOrder extends StatefulWidget {
  PurchaseOrder(this.table);
  OrdersTable table;
  bool _isStandingOrder = false; //Standing order = Dauerauftrag
  late Product chosenProduct;
  @override
  State<PurchaseOrder> createState() => _PurchaseOrderState();
}

class _PurchaseOrderState extends State<PurchaseOrder> {
  //Product from Dropdown
  List<Product> salableProducts = []; //this are our Products what we sale


  bestellungaufgeben() async {

    setState(() {
      widget.table.orders.add(SingleOrder(quantitySelector.getQuantity(), widget.chosenProduct));
    });

    /*
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Die Bestellung wurde erfolgreich aufgegeben!'),
          actions: <Widget>[
            TextButton(
              child: Text('Bestätigen'),
              onPressed: () {
                // Hier passiert etwas anderes
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

     */
  }

  @override
  void initState() {
    salableProducts.add(Product(0.3, "Kaisersemmel"));
    salableProducts.add(Product(0.3, "Körnerbrötchen"));
    salableProducts.add(Product(0.3, "Kürbiskernbrötchen"));
    widget.chosenProduct = salableProducts.first;
    super.initState();
  }

  QuantitySelector quantitySelector = new QuantitySelector();

  double calculatePrice() {
    setState(() {});
    return quantitySelector.getQuantity() * widget.chosenProduct.price;
  }

  @override
  Widget build(BuildContext context) {
    quantitySelector.addListener(calculatePrice);

    double _screenwidth = MediaQuery.of(context).size.width;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              margin: EdgeInsets.only(top: 10, bottom: 0),
              child: Divider(color: CustomTheme.isDarkTheme
                  ?Colors.white24: Colors.black26)),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 0),
            child: const Text("Bestellung aufgeben",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Divider(color: CustomTheme.isDarkTheme
              ?Colors.white24: Colors.black26),
          Container(
            constraints: BoxConstraints(maxWidth: 420),
            margin: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 8),
                          child: const Text(
                            "Brötchensorte: ",
                            style: TextStyle(fontSize: 16),
                          )),
                      DropdownButton<Product>(
                        dropdownColor: CustomTheme.isDarkTheme
                            ? CustomTheme.darkTheme.backgroundColor
                            : CustomTheme.lightTheme.backgroundColor,
                        items: salableProducts.map((Product product) {
                          return DropdownMenuItem<Product>(
                            value: product,
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: product.identifier + "\n",
                                      style: CustomTheme.isDarkTheme
                                          ? TextStyle(
                                              color: CustomTheme.darkTheme
                                                  .textTheme.bodyText2?.color
                                                  ?.withOpacity(0.8))
                                          : TextStyle(
                                              color: CustomTheme.lightTheme
                                                  .textTheme.bodyText1?.color
                                                  ?.withOpacity(0.6)),
                                    ),
                                    TextSpan(
                                      text: NumberFormat.currency(locale: 'eu')
                                          .format(product.price),
                                      style: CustomTheme.isDarkTheme
                                          ? TextStyle(
                                              color: CustomTheme.darkTheme
                                                  .textTheme.bodyText2?.color)
                                          : TextStyle(
                                              color: CustomTheme.lightTheme
                                                  .textTheme.bodyText1?.color
                                                  ?.withOpacity(0.8)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        value: widget.chosenProduct,
                        style: TextStyle(fontSize: 16),
                        onChanged: (value) {
                          setState(() {
                            widget.chosenProduct = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Text(
                          "Anzahl: ",
                          style: TextStyle(fontSize: 16),
                        )),
                    quantitySelector,

                    /*
                            DropdownButton<String>(
                              items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: anzahl,
                              style: TextStyle(fontSize: 16),
                              onChanged: (value) {
                                setState(() {
                                  anzahl = value!;
                                });
                              },
                            ),
                            */
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Dauerauftrag:",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 20),
                        child: Checkbox(
                          value: widget._isStandingOrder,
                          onChanged: (bool? value) {
                            setState(() {
                              widget._isStandingOrder = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    "Summe: " +
                        NumberFormat.currency(locale: 'eu')
                            .format(calculatePrice())
                            .toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 20, bottom: 10, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      bestellungaufgeben();
                    },
                    child: Text(
                      "Zur Bestellung hinzufügen",
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
    );
  }
}

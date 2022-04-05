/*
* This class represents a single order, meaning refering to one product only. An example would be:
*
* identifier: normalesbroetchen
* amount: 2
* price: 0.3
*/

import 'package:broetchenservice/order/product.dart';
import 'package:flutter/material.dart';

class SingleOrder extends Product {
  @override
  toString() {
    return ('-Preis: ' +
        this.price.toString() +
        '\n-Identifier: ' +
        this.identifier +
        '\n-Status: ' +
        this.status +
        '\n-StandingOrder: ' +
        this.standingOrder.toString() +
        '\n-Amount: ' +
        this.amount.toString());
  }

  bool standingOrder = false;
  String status = "o"; // o - open ; c - canceled ; p - processed
  int amount;

  SingleOrder(this.amount, this.standingOrder, Product product)
      : super(product.price, product.identifier);

  static List<DataColumn> DataTableColumnsGerman = const [
    DataColumn(
      label: Text('Brötchen'),
    ),
    DataColumn(
      label: Expanded(
          child: Text(
        'Menge',
        textAlign: TextAlign.center,
      )),
    ),
    DataColumn(
      label: Expanded(
          child: Text(
        'Preis',
        textAlign: TextAlign.center,
      )),
    ),
    DataColumn(
      label: Expanded(
          child: Text(
        'Summe',
        textAlign: TextAlign.center,
      )),
    ),
    DataColumn(
      label: Expanded(
          child: Text(
        'Dauerauftrag',
        textAlign: TextAlign.center,
      )),
    ),
    DataColumn(
      label: Expanded(
          child: Text(
        'Löschen',
        textAlign: TextAlign.center,
      )),
    ),
  ];
}

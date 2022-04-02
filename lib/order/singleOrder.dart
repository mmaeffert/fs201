/*
* This class represents a single order, meaning refering to one product only. An example would be:
*
* identifier: normalesbroetchen
* amount: 2
* price: 0.3
*/

import 'package:broetchenservice/order/product.dart';

class SingleOrder extends Product{
  bool standingOrder=false;
  String status = "o"; // o - open ; c - canceled ; p - processed
  int amount;


  SingleOrder(this.amount, Product product) : super(product.price, product.identifier);
}

/*
* This class represents a single order, meaning refering to one product only. An example would be:
*
* identifier: normalesbroetchen
* amount: 2
* price: 0.3
*/

class SingleOrder {
  String identifier;
  int amount;
  double price;

  SingleOrder(this.identifier, this.amount, this.price);
}

import 'package:broetchenservice/UI%20Kit/checkBoxKit.dart';
import 'package:broetchenservice/UI%20Kit/headerKit.dart';
import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/themes.dart';
import 'package:flutter/material.dart';
import '../../UI Kit/textKit.dart';
import '../../quantitySelector.dart';
import '../product.dart';

// ignore: must_be_immutable
class PurchaseOrder extends StatefulWidget with ChangeNotifier {
  PurchaseOrder({Key? key}) : super(key: key);
  QuantitySelector quantitySelector = new QuantitySelector(); //Ui for Amount
  bool _isStandingOrder = false; //Standing order = Dauerauftrag
  late Product chosenProduct;
  bool get isStandingOrder => _isStandingOrder;
  @override
  State<PurchaseOrder> createState() => _PurchaseOrderState();
}

class _PurchaseOrderState extends State<PurchaseOrder> {
  //Product from Dropdown
  List<Product> salableProducts = []; //this are our Products what we sale

  @override
  void initState() {
    currentTheme.addListener(() {
      setState(() {});
    });
    loadProducts();
    widget.quantitySelector.addListener(calculatePrice);
    //TODO: GET ProducList from DB
    salableProducts.add(Product(0.3, "Kaisersemmel"));
    salableProducts.add(Product(0.3, "Körnerbrötchen"));
    salableProducts.add(Product(0.3, "Kürbiskernbrötchen"));
    widget.chosenProduct = salableProducts.first;
    super.initState();
  }

  loadProducts() async {
    salableProducts = await ReadFromDB().getProductList();
    widget.chosenProduct = salableProducts.first;
    setState(() {});
  }

  //sum of an order
  double calculatePrice() {
    setState(() {});
    return widget.quantitySelector.getQuantity() * widget.chosenProduct.price;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        HeaderKit.header1("Bestellung aufgeben"),
        Container(
          constraints: BoxConstraints(maxWidth: 420),
          margin: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Product.DropDownProducts(
                    widget.chosenProduct, salableProducts, (value) {
                  setState(() {
                    widget.chosenProduct = value!;
                  });
                }),
              ),
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        "Anzahl: ",
                        style: TextStyle(fontSize: 16),
                      )),
                  widget.quantitySelector,
                ],
              ),
              CheckBoxKit.checkbox1(
                widget.isStandingOrder,
                "Dauerauftrag",
                (value) {
                  setState(() {
                    widget._isStandingOrder = value!;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 20, right: 20),
                child: Text(
                  "Summe: " + TextKit.textwithEuro(calculatePrice()),
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 20, bottom: 10, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    widget.notifyListeners();
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

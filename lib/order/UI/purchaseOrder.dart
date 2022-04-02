import 'package:broetchenservice/themes.dart';
import 'package:flutter/material.dart';
import 'package:broetchenservice/appbar.dart' as ab;
import "package:intl/intl.dart";
import '../../quantitySelector.dart';
import '../product.dart';
import 'package:broetchenservice/themes.dart';

class PurchaseOrder extends StatefulWidget {
  const PurchaseOrder({Key? key}) : super(key: key);

  @override
  State<PurchaseOrder> createState() => _PurchaseOrderState();
}

class _PurchaseOrderState extends State<PurchaseOrder> {

  final _formKey = GlobalKey<FormState>();
  String anzahl = '1';
  late Product chosenProduct;
  bool isDauerauftrag = false;
  bool _passwordVisible = false;
  List<Product> salableProducts = []; //this are our Products what we sale


  bestellungaufgeben() async {
    if (_formKey.currentState!.validate()) {
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
    }
  }
  
  @override
  void initState() {
    salableProducts.add(Product(0.3,"Kaisersemmel"));
    salableProducts.add(Product(0.3,"Körnerbrötchen"));
    salableProducts.add(Product(0.3,"Kürbiskernbrötchen"));
    chosenProduct = salableProducts.first;
    super.initState();
  }


  QuantitySelector QuantitySelector1 = new QuantitySelector();

 double calculatePrice(){
   setState(() {});
   return QuantitySelector1.getQuantity()*chosenProduct.price;
  }

  @override
  Widget build(BuildContext context) {
    QuantitySelector1.addListener(calculatePrice);

    double _screenwidth = MediaQuery.of(context).size.width;

      return Scaffold(
        appBar: ab.Appbar.MainAppBar(context),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 420),
                margin: EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 25, bottom: 20),
                      child: const Text("Bestellung aufgeben",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),

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
                            dropdownColor: CustomTheme.isDarkTheme?CustomTheme.darkTheme.backgroundColor:CustomTheme.lightTheme.backgroundColor,
                            items: salableProducts.map((Product product) {
                              return DropdownMenuItem<Product>(
                                value: product,
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: product.identifier+ "\n",
                                          style: CustomTheme.isDarkTheme?TextStyle(color: CustomTheme.darkTheme.textTheme.bodyText2?.color?.withOpacity(0.8)):TextStyle(color: CustomTheme.lightTheme.textTheme.bodyText1?.color?.withOpacity(0.6)),
                                        ),
                                        TextSpan(
                                          text: NumberFormat.currency(locale: 'eu').format(product.price),
                                          style: CustomTheme.isDarkTheme?TextStyle(color: CustomTheme.darkTheme.textTheme.bodyText2?.color):TextStyle(color: CustomTheme.lightTheme.textTheme.bodyText1?.color?.withOpacity(0.8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            value: chosenProduct,
                            style: TextStyle(fontSize: 16),
                            onChanged: (value) {
                              setState(() {
                                chosenProduct = value!;
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

                            QuantitySelector1,

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

                                child: Text("Dauerauftrag:", style: TextStyle(fontSize: 16),),),

                              Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 20),
                                child: Checkbox(
                                  //checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(getColor),
                                  value: isDauerauftrag,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isDauerauftrag = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                    Container(
                      margin: EdgeInsets.only(top: 20, right: 20),
                    child: Text("Preis: "+ NumberFormat.currency(locale: 'eu').format(calculatePrice()).toString(),
                          style: TextStyle(fontSize: 18),),

                    ),

                    Container(
                      //height: 75,
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(top: 15, bottom: 15, right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          bestellungaufgeben();
                        },
                        child: Text("Kostenpflichtig bestellen",
                          style: TextStyle(fontSize: 18),),
                      ),
                    ),
                  ],
                ),
              ),
              /*
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: bekleyen_is_emri(),
                  ),
                ],
              )

              */
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
            });
          },
        ),
      );
    }
  }


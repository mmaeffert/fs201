/*
* This class represents a product, meaning refering to one product only. An example would be:
*
* identifier: normalesbroetchen
* amount: 2
* price: 0.3
*/
import "package:intl/intl.dart";
import 'package:flutter/material.dart';

import '../themes.dart';

class Product {
  String identifier;
  double price = 0;

  Product(this.price, this.identifier) {
    this.identifier = identifier;
    this.price = price;
  }


 static DropDownProducts(Product chosenProduct,List<Product> salableProducts, ValueChanged onChanged){
    return Row(
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
            value: chosenProduct,
            style: TextStyle(fontSize: 16),
            onChanged: onChanged,
        ),
      ],
    );

  }

}


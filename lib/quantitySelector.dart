import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({Key? key}) : super(key: key);

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  var counter = 1;

  decrementCounter() {
    if (counter > 0) {
      counter--;
      setState(() {});
    }
  }

  incrementCounter() {
    if (counter < 99) {
      counter++;
    }
    setState(() {});
  }

  getQuantity() {
    return counter;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      children: [
        IconButton(
          alignment: Alignment.centerLeft,
          onPressed: decrementCounter,
          icon: Icon(Icons.arrow_left),
          color: Colors.yellowAccent,
          splashRadius: 14,
        ),
        Container(
          child: Center(
            child: Text(
              counter.toString(),
            ),
            widthFactor: 5,
          ),
          constraints: BoxConstraints(maxWidth: 20),
        ),
        IconButton(
          alignment: Alignment.centerRight,
          onPressed: incrementCounter,
          icon: Icon(Icons.arrow_right),
          color: Colors.yellowAccent,
          splashRadius: 14,
        )
      ],
    ));
  }
}

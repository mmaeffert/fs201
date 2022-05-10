import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget with ChangeNotifier{
   QuantitySelector({Key? key}) : super(key: key);

 int _counter = 1;
  int getQuantity() {
    return _counter;
  }
  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {


  decrementCounter() {
    if ( widget._counter > 1) {
      widget._counter--;
      widget.notifyListeners();
      setState(() {});
    }
  }

  incrementCounter() {
    if ( widget._counter < 99) {
      widget._counter++;
      widget.notifyListeners();
    }
    setState(() {});
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
              widget._counter.toString(),
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

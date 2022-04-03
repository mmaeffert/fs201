import 'package:flutter/material.dart';
import 'dividerKit.dart';




class HeaderKit {
  static header1(String header) {
    return
      Column(
        children: [
          DividerKit.Divider1(),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 0),
            child: Text(header,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
          DividerKit.Divider1(),
        ],
      );
  }
}
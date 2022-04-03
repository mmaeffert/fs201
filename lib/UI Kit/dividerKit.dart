import 'package:flutter/material.dart';
import '../themes.dart';




class DividerKit {
  static Divider1() {
    return
      Container(
          margin: EdgeInsets.only(top: 0, bottom: 0),
          child: Divider(color: CustomTheme.isDarkTheme
              ? Colors.white24 : Colors.black26));
  }
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';

/*
Example to use this Kit:
 bestellungaufgeben() {
    AlertDialogKit.alertDialog1(context, "alertText", "buttontext");
  }
 */

class AlertDialogKit {
  static alertDialog1(
      BuildContext context, String alertText, String buttontext) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertText),
          actions: <Widget>[
            TextButton(
              child: Text(buttontext),
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

import 'package:flutter/material.dart';
import './main.dart';
import './dauerauftrag.dart';
import './account.dart';
import './realTimeDatabaseExample.dart';
import 'order/UI/OrderLayout.dart';
import 'order/UI/purchaseOrder.dart';

class drawer {
  test(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: Text(
                "Bestellen ✍️",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
    MaterialPageRoute(builder: (context) => OrderLayout()));
              },

            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: Text(
                "Daueraufträge 📅",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dauerauftrag()));
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: Text(
                "Guthaben 💰",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: Text(
                "Konto 🔒",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Account()));
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: Text(
                "Database Beispiel",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RTDatabase()));
              },
            ),
          ],
        ));
  }
}

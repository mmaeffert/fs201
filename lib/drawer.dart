import 'package:broetchenservice/balancePage.dart';
import 'package:broetchenservice/orderList.dart';
import 'package:flutter/material.dart';
import './dauerauftrag.dart';
import './account.dart';
import './realTimeDatabaseExample.dart';
import 'appbar.dart';
import 'order/UI/ordersTable.dart';
import 'themes.dart';
import './balancePage.dart';

class drawer {
  test(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        child: ListView(
          children: [
            GetCurrentUser().getUser() != null
                ? UserAccountsDrawerHeader(
                    accountName: Text(
                        GetCurrentUser().getUser()!.displayName.toString()),
                    accountEmail:
                        Text(GetCurrentUser().getUser()!.email.toString()),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          GetCurrentUser().getUser()!.photoURL.toString()),
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.white,
                      child: NetworkImage(GetCurrentUser()
                                  .getUser()!
                                  .photoURL
                                  .toString()) ==
                              null
                          ? Text(
                              GetCurrentUser()
                                  .getUser()!
                                  .displayName!
                                  .substring(0, 1),
                              style: TextStyle(fontSize: 40.0),
                            )
                          : Container(),
                    ),
                  )
                : UserAccountsDrawerHeader(
                    accountName: Text("Gast"),
                    accountEmail: Text("gast@gmail.com"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: CustomTheme.isDarkTheme
                          ? CustomTheme.darkTheme.backgroundColor
                              .withOpacity(0.8)
                          : CustomTheme.lightTheme.backgroundColor
                              .withOpacity(0.8),
                      child: Text(
                        "G",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: Text(
                "Bestellen ✍️",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrdersTable()));
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: Text(
                "Bestellungen 📅",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderList()));
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: Text(
                "💰 Guthaben",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BalancePage()));
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

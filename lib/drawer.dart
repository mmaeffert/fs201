import 'package:broetchenservice/balancePage.dart';
import 'package:broetchenservice/orderList.dart';
import 'package:flutter/material.dart';
import './account.dart';
import 'appbar.dart';
import 'order/UI/order.dart';
import 'themes.dart';
import './balancePage.dart';
import './feedback.dart';

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
                              style: const TextStyle(fontSize: 40.0),
                            )
                          : Container(),
                    ),
                  )
                : UserAccountsDrawerHeader(
                    accountName: const Text("Gast"),
                    accountEmail: const Text("gast@gmail.com"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: CustomTheme.isDarkTheme
                          ? CustomTheme.darkTheme.backgroundColor
                              .withOpacity(0.8)
                          : CustomTheme.lightTheme.backgroundColor
                              .withOpacity(0.8),
                      child: const Text(
                        "G",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: const Text(
                " ✍️ Bestellen",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Order()));
              },
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: const Text(
                " 📅 Bestellungen",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderList(
                              openTiles: [],
                            )));
              },
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: const Text(
                " 💰 Guthaben",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BalancePage()));
              },
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: const Text(
                " 🔒 Konto",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Account()));
              },
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              title: const Text(
                " 🐛 Feedback",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserFeedback()));
              },
            ),
          ],
        ));
  }
}

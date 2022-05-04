import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/googleSignInProvider.dart';
import 'package:broetchenservice/db/writeToDB.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import './appbar.dart' as ab;
import './googleSignInProvider.dart';
import 'order/UI/order.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  double userBalance = 0.0;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    setUserBalance();
    super.initState();
  }

  setUserBalance() async {
    if (await ReadFromDB().userAlreadyExists()) {
      // userBalance =
      //     double.parse(await ReadFromDB().getUserBalance().toString());
      ReadFromDB().getUserBalance().then((value) => userBalance = value);
    }
    print(userBalance);
    this.userBalance = (userBalance == null) ? 0.0 : userBalance.toDouble();
    setState(() {});
  }

  assignClass() async {
    bool userHasAssignedClass = await ReadFromDB().userHasAssignedClass();
    if (!userHasAssignedClass) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Herzlich willkommen :) Damit ich weiß wohin die Brötchen gehen, gib bitte deine Klasse an"),
                actions: [
                  TextFormField(
                    maxLength: 10,
                    maxLines: 1,
                    controller: textController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(3)))),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (textController.text != '') {
                          await writeToDB().assignClass(textController.text);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Order()));
                        }
                      },
                      child: Icon(Icons.send))
                ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ab.Appbar.MainAppBar(context),
      body: Center(
          child: Column(
        children: [
          ElevatedButton.icon(
              label: Text("Sign in with Google"),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin().then((value) => assignClass());
              },
              icon: FaIcon(
                FontAwesomeIcons.google,
                color: Colors.red,
              )),
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, AsyncSnapshot) {
              if (AsyncSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (AsyncSnapshot.hasError) {
                return Text("Something went wrong :(");
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          renderLogOutButton(context),
          Text("Guthaben: " + userBalance.toString()),
          ElevatedButton.icon(
              label: Text("Refresh"),
              onPressed: () {
                setUserBalance();
              },
              icon: FaIcon(
                FontAwesomeIcons.google,
                color: Color.fromARGB(255, 150, 133, 131),
              )),
        ],
      )),
    );
  }

  renderLogOutButton(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return ElevatedButton.icon(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            if (this.mounted) {
              setState(() {});
            }
          },
          icon: Icon(Icons.logout),
          label: Text("Log out"));
    } else {
      return SizedBox.shrink();
    }
  }
}

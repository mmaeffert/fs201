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
    userBalance = userBalance.toDouble();
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
                title: const Text(
                    "Herzlich willkommen :) Damit ich weiß wohin die Brötchen gehen, gib bitte deine Klasse an"),
                actions: [
                  TextFormField(
                    maxLength: 10,
                    maxLines: 1,
                    controller: textController,
                    decoration: const InputDecoration(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Order()));
                        }
                      },
                      child: const Icon(Icons.send))
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
              label: const Text("Sign in with Google"),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin().then((value) => assignClass());
              },
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.red,
              )),
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, AsyncSnapshot) {
              if (AsyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (AsyncSnapshot.hasError) {
                return const Text("Something went wrong :(");
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          renderLogOutButton(context),
          Text("Guthaben: " + userBalance.toString()),
          ElevatedButton.icon(
              label: const Text("Refresh"),
              onPressed: () {
                setUserBalance();
              },
              icon: const FaIcon(
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
            if (mounted) {
              setState(() {});
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text("Log out"));
    } else {
      return const SizedBox.shrink();
    }
  }
}

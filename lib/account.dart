import 'package:broetchenservice/db/readFromDB.dart';
import 'package:broetchenservice/googleSignInProvider.dart';
import 'package:broetchenservice/db/writeToDB.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import './appbar.dart' as ab;
import './googleSignInProvider.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  double userBalance = 0.6;

  @override
  void initState() {
    setUserBalance().then((value) {
      if (value) {
        setState(() {});
      }
    });
    super.initState();
  }

  Future<bool> setUserBalance() async {
    var userBalance = await ReadFromDB().getUserBalance();
    print(userBalance);
    this.userBalance = (userBalance == null) ? 0.0 : userBalance.toDouble();
    return (userBalance == null) ? false : true;
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
                provider.googleLogin();
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
              } else if (AsyncSnapshot.hasData) {
                return Center(child: Text(AsyncSnapshot.data.toString()));
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
                setState(() {});
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

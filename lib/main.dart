import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './themes.dart';
import './drawer.dart';
import './appbar.dart' as ab;
import 'package:firebase_core/firebase_core.dart';
import './googleSignInProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBCCcWHUfnVD6dMAm_hNv6_yAWMoO5XkRY",
        authDomain: "fs201-f4013.firebaseapp.com",
        databaseURL:
            "https://fs201-f4013-default-rtdb.europe-west1.firebasedatabase.app",
        projectId: "fs201-f4013",
        storageBucket: "fs201-f4013.appspot.com",
        messagingSenderId: "557669744446",
        appId: "1:557669744446:web:5508584d8e59b60f03b66f",
        measurementId: "G-ZPY0F32Z07",
      ),
    );
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }

  runApp(const MyAPp());
}

class MyAPp extends StatefulWidget {
  const MyAPp({Key? key}) : super(key: key);

  @override
  State<MyAPp> createState() => _MyAPpState();
}

class _MyAPpState extends State<MyAPp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  /*
MaterialApp(
      home: MyHome(),
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
    )
  */

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        home: MyHome(),
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: currentTheme.currentTheme,
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  drawer test22 = drawer();

  MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: test22.test(context),
      appBar: ab.Appbar.MainAppBar(context),
      body: Image.network(
        "https://fs201.de/logo.png",
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

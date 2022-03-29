import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './themes.dart';
import './drawer.dart';
import './appbar.dart' as ab;
import './bestellen.dart';
import 'package:firebase_core/firebase_core.dart';
import './googleSignInProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
  drawer test22 = new drawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: test22.test(context),
      appBar: ab.Appbar.MainAppBar(context),
      body: Center(child: Bestellen()),
    );
  }
}

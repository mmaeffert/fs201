import 'package:flutter/material.dart';
import './appbar.dart' as ab;

class Dauerauftrag extends StatefulWidget {
  const Dauerauftrag({Key? key}) : super(key: key);

  @override
  State<Dauerauftrag> createState() => _DauerauftragState();
}

class _DauerauftragState extends State<Dauerauftrag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ab.Appbar.MainAppBar(context),
      body: const Text("Hans"),
    );
  }
}

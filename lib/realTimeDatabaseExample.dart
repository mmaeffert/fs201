import 'package:broetchenservice/readExample.dart';
import 'package:broetchenservice/writeExample.dart';
import 'package:flutter/material.dart';
import './appbar.dart' as ab;

class RTDatabase extends StatefulWidget {
  const RTDatabase({Key? key}) : super(key: key);

  @override
  State<RTDatabase> createState() => _RTDatabaseState();
}

class _RTDatabaseState extends State<RTDatabase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ab.Appbar.MainAppBar(context),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Text(
            "Hier kannst du dich mit der Realtime Database auseinandersetzen"),
        SizedBox(
          height: 16,
          width: MediaQuery.of(context).size.width,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ReadExample()));
            },
            child: const Text("Lese Beispiel")),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WriteExample()));
            },
            child: const Text("Schreibe Beispiel"))
      ]),
    );
  }
}

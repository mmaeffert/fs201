import 'package:broetchenservice/db/writeToDB.dart';
import 'package:broetchenservice/themes.dart';
import 'package:flutter/material.dart';
import './appbar.dart' as ab;

class UserFeedback extends StatefulWidget {
  const UserFeedback({Key? key}) : super(key: key);

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ab.Appbar.MainAppBar(context),
      body: Column(children: [
        TextFormField(
          style: TextStyle(color: currentTheme.getTextColor()),
          controller: textController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)))),
        ),
        ElevatedButton(
            onPressed: () {
              if (textController.text != '') {
                writeToDB().sendFeedback(textController.text).then((value) => {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                  "Dein Feedback wurde eingereicht. Ich weiß deine Mitarbeit zu schätzen :*"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"))
                              ],
                            );
                          })
                    });
              }
            },
            child: const Icon(Icons.send))
      ]),
    );
  }
}

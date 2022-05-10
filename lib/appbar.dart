import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './themes.dart';

class GetCurrentUser {
  var user = FirebaseAuth.instance.currentUser;
  User? getUser() {
    return user;
  }
}

class Appbar {
  static MainAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text("🍞 Brötchenservice"),
      actions: [
        showUserProfile(),
        IconButton(
            onPressed: () => {currentTheme.toggleTheme()},
            icon: Icon(Icons.sunny))
      ],
    );
  }

  static TabAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text("🍞 Brötchenservice"),
      bottom: TabBar(tabs: [
        Tab(
          text: "Bestellungen",
        ),
        Tab(
          text: "Dauerauftrag",
        )
      ]),
      actions: [
        showUserProfile(),
        IconButton(
            onPressed: () => {currentTheme.toggleTheme()},
            icon: Icon(Icons.brush)),
      ],
    );
  }

  static showUserProfile() {
    if (GetCurrentUser().getUser() == null) {
      return SizedBox.shrink();
    } else {
      return CircleAvatar(
        radius: 21,
        backgroundImage:
            NetworkImage(GetCurrentUser().getUser()!.photoURL.toString()),
      );
    }
  }
}

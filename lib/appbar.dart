import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './themes.dart';

class GetCurrentUser {
  var user = FirebaseAuth.instance.currentUser;
  getUser() {
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
        test(context),
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
        backgroundImage: NetworkImage(GetCurrentUser().getUser().photoURL),
      );
    }
  }

  static test(BuildContext context) {
    if (Navigator.canPop(context)) {
      return (IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new),
      ));
    } else {
      return SizedBox.shrink();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:guess_the_song/model/user.dart';

getAppBar(BuildContext context, User user) {
  return AppBar(
    title: Text("Area do jogador"),
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
    automaticallyImplyLeading: false,
    actions: <Widget>[
      PopupMenuButton(
        onSelected: (selection) {
          if(selection == 'logout') {
            user.signOut();
            Navigator.pop(context);
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: "logout",
              child: Text("Sair"),
            )
          ];
        },
      )
    ],
  );
}
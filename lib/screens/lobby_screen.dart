import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guess_the_song/components/appbar.dart';
import 'package:guess_the_song/model/player.dart';
import 'package:guess_the_song/model/user.dart';
import 'package:guess_the_song/screens/new_game.dart';
import 'package:scoped_model/scoped_model.dart';

class LobbyScreen extends StatefulWidget {
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
      builder: (context, child, model){
        return Scaffold(
          appBar: getAppBar(context, model),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {

              DocumentSnapshot doc = await Firestore.instance.collection("players").document(model.firebaseUser.uid).get();
              Player player = Player.fromMap(doc.data);
              player.id = doc.documentID;

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewGame(player)
              ));
            },
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
    );
  }
}

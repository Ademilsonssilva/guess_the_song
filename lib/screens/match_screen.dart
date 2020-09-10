import 'package:flutter/material.dart';
import 'package:guess_the_song/model/match.dart';
import 'package:guess_the_song/model/match_item.dart';

class MatchScreen extends StatefulWidget {

  Match match;

  MatchScreen(this.match);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {

  @override
  Widget build(BuildContext context) {

    print(widget.match.game.player_game);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.match.repository.getTitle()),
        centerTitle: true,
      ),

    );
  }
}

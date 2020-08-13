import 'package:flutter/material.dart';
import 'package:guess_the_song/components/appbar.dart';
import 'package:guess_the_song/model/match.dart';
import 'package:guess_the_song/model/player.dart';
import 'package:guess_the_song/model/user.dart';
import 'package:guess_the_song/tabs/new_game_choose_match_configs.dart';
import 'package:guess_the_song/tabs/new_game_choose_music_repository_tab.dart';
import 'package:guess_the_song/tabs/new_game_choose_oponent_tab.dart';
import 'package:guess_the_song/utils/session.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:guess_the_song/utils/session.dart';

class NewGame extends StatefulWidget {

  Player player;

  NewGame(this.player);

  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {

  final _pageController = PageController();

  Match new_match = Match();

  @override
  Widget build(BuildContext context) {

    Session.new_match = new_match;

    Session.new_match.hostPlayer = widget.player.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Novo jogo"),
        centerTitle: true,
        leading: PopupMenuButton(
          child: Icon(
            Icons.arrow_back
          ),
          onSelected: (value) {
            if(value == "back") {
              print(_pageController.previousPage(
                duration: Duration(seconds: 1),
                curve: Curves.ease
              ));
            }
            else {
              Navigator.pop(context);
            }
          },
          itemBuilder: (context) {
            return[
              PopupMenuItem(
                value: "back",
                child: Text("Voltar à tela anterior"),
              ),
              PopupMenuItem(
                value: "close",
                child: Text("Cancelar criação de partida"),
              )
            ];
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          NewGameChooseOpponentTab(_pageController),
          NewGameChooseMusicRepositoryTab(_pageController),
          NewGameChooseMatchConfigs(_pageController),
        ],
      ),
    );
//      }
//    );
  }
}

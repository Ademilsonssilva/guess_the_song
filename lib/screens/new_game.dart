import 'package:flutter/material.dart';
import 'package:guess_the_song/components/appbar.dart';
import 'package:guess_the_song/model/user.dart';
import 'package:guess_the_song/tabs/new_game_choose_oponent_tab.dart';
import 'package:scoped_model/scoped_model.dart';

class NewGame extends StatefulWidget {
  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Novo jogo"),
            centerTitle: true,
          ),
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              NewGameChooseOpponentTab(_pageController),
              Scaffold(
                body: Container(child: Text('tela 2'),),
              )
            ],
          ),
        );
      }
    );
  }
}

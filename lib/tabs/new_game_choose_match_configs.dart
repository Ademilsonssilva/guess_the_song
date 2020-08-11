import 'package:flutter/material.dart';
import 'package:guess_the_song/model/match.dart';
import 'package:guess_the_song/model/track.dart';
import 'package:guess_the_song/utils/deezer.dart';
import 'package:guess_the_song/utils/session.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NewGameChooseMatchConfigs extends StatefulWidget {

  PageController _pageController;

  NewGameChooseMatchConfigs(this._pageController);

  static final tabNumber = 3;

  @override
  _NewGameChooseMatchConfigsState createState() => _NewGameChooseMatchConfigsState();
}

class _NewGameChooseMatchConfigsState extends State<NewGameChooseMatchConfigs> {

  String game_mode = Match.GAME_MODE_ONLY_SONG;

  int number_of_used_tracks = 0;

  @override
  Widget build(BuildContext context) {

    Deezer.getTrackList(Session.new_match.repository_type, Session.new_match.repository.getId().toString()).then((tracklist) {
      Session.new_match.repository.track_count = tracklist.length;

      Session.new_match.repository.tracklist = tracklist;

      setState(() {
        Session.new_match.track_count = tracklist.length;
      });
    });

    return SingleChildScrollView(
      child: Form(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    "Criando sua partida...",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: LinearPercentIndicator(
                    progressColor: Theme.of(context).primaryColor,
                    percent: 0.95,
                    padding: EdgeInsets.all(30),
                    lineHeight: 20,
                    center: Text("50%", style: TextStyle(color: Colors.black, fontSize: 20),),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Quantas musicas: (MAX ${Session.new_match.track_count})"
                  ),
                ),
              ),
              Slider(

                onChanged: (value) {
                  setState(() {
                    number_of_used_tracks = value.toInt();
                  });
                },
                label: "${number_of_used_tracks}",
                value: number_of_used_tracks+0.0,
                max: number_of_used_tracks+0.0,
                min: number_of_used_tracks+0.0,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: "Tipo de jogo: "
                ),
                value: game_mode,
                items: [
                  DropdownMenuItem(
                    child: Text("Adivinhar a música"),
                    value: Match.GAME_MODE_ONLY_SONG,
                  ),
                  DropdownMenuItem(
                    child: Text("Adivinhar musica e Artista"),
                    value: Match.GAME_MODE_SONG_AND_ARTIST,
                  )
                ],
                onChanged: (value) {

                },
              )

            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:guess_the_song/model/match.dart';
import 'package:guess_the_song/model/repository.dart';
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

  int number_of_used_tracks = Session.new_match.track_count;

  String track_draw_type = Match.TRACK_DRAW_TYPE_SAME_DRAW;

  int number_of_attempts = 1;

  bool is_screen_loading = false;

  @override
  Widget build(BuildContext context) {

    return is_screen_loading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(

      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              padding: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                    "Número de musicas: ${number_of_used_tracks}"
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Slider(
                onChanged: (value) {
                  setState(() {
                    number_of_used_tracks = value.toInt();
                  });
                },
                divisions: Session.new_match.track_count,
                label: "${number_of_used_tracks}",
                value: number_of_used_tracks+0.0,
                max: Session.new_match.track_count+0.0,
                min: 0,
              ),
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                  labelText: "Tipo de jogo: "
              ),
              value: game_mode,
              items: getDropDownGameModeOptions(),
              onChanged: (value) {

              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                    "Número máximo de tentativas: ${number_of_attempts}"
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Slider(
                onChanged: (value) {
                  setState(() {
                    number_of_attempts = value.toInt();
                  });
                },
//                divisions: 3,
                label: "${number_of_attempts}",
                value: number_of_attempts + 0.0,
                max: 3+0.0,
                min: 1+0.0,
              ),
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                  labelText: "Selecione o modo de sorteio de música: "
              ),
              value: track_draw_type,
              items: getDropDownTrackDrawOptions(),
              onChanged: (value) {
                setState(() {
                  track_draw_type = value;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 45),
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("Criar partida",
                    style: TextStyle(
                        color:Colors.white,
                        fontSize: 18
                    ),
                  ),
                ),
                onPressed: () async {
                  Session.new_match.game_songs_count = number_of_used_tracks;
                  Session.new_match.game_mode = game_mode;
                  Session.new_match.number_of_attempts = number_of_attempts;
                  Session.new_match.track_draw_type = track_draw_type;

                  setState(() {
                    is_screen_loading = true;
                  });

                  bool result = await Session.new_match.createMatchFirebase();
                  setState(() {
                    is_screen_loading = false;

                    if (result) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Sucesso"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Partida criada com sucesso!\nAguarde o oponente!"),
                                FlatButton(
                                  child: Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        }
                      ).then((value) {
                        Navigator.pop(context);
                      });
                    }
                  });

                },
              ),
            )

          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> getDropDownGameModeOptions() {

    List<DropdownMenuItem> options = List<DropdownMenuItem>();

    options.add(DropdownMenuItem(
      child: Text("Adivinhar a música"),
      value: Match.GAME_MODE_ONLY_SONG,
    ));

    if (Session.new_match.repository_type == Repository.REPOSITORY_TYPE_PLAYLIST) {
      options.add(DropdownMenuItem(
        child: Text("Adivinhar musica e Artista"),
        value: Match.GAME_MODE_SONG_AND_ARTIST,
      ));
    }

    return options;

  }

  List<DropdownMenuItem> getDropDownTrackDrawOptions() {

    List<DropdownMenuItem> options = List<DropdownMenuItem>();

    options.add(DropdownMenuItem(
      child: Text("Músicas e ordem iguais"),
      value: Match.TRACK_DRAW_TYPE_SAME_DRAW,
    ));

    options.add(DropdownMenuItem(
      child: Text("Músicas iguals, ordem diferente"),
      value: Match.TRACK_DRAW_TYPE_DIFF_SORT,
    ));

    options.add(DropdownMenuItem(
      child: Text("Músicas diferentes"),
      value: Match.TRACK_DRAW_TYPE_DIFF_GAME,
    ));

    return options;

  }
}

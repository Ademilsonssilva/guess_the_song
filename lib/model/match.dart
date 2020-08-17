import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guess_the_song/model/player.dart';
import 'package:guess_the_song/model/repository.dart';

class Match{

  List<Player> players;
  String hostPlayer;
  String visitorPlayer;

  String repository_type;
  Repository repository;

  int track_count;

  int game_songs_count;
  String game_mode;

  int number_of_attempts;
  String track_draw_type;

  static const GAME_MODE_ONLY_SONG = "only_song";
  static const GAME_MODE_SONG_AND_ARTIST = "song_and_artist";

  static const TRACK_DRAW_TYPE_SAME_DRAW = "same_draw"; // O jogo dos dois jogadores será exatamente igual
  static const TRACK_DRAW_TYPE_DIFF_SORT = "diff_sort"; // As mesmas musicas serao mostradas para os dois jogadores, mas não necessariamente na mesma ordem
  static const TRACK_DRAW_TYPE_DIFF_GAME = "diff_game"; // Cada player receberá musicas diferentes, de dentro do mesmo repositório

  Match();

  @override
  String toString() {
    // TODO: implement toString
    return "\n---NEW LOG\n - host player: ${hostPlayer}\n - visitor player: ${visitorPlayer}\n - repository type: ${repository_type}\n - repository: ${repository}\n - track count: ${track_count}";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["hostPlayer"] = hostPlayer;
    map["visitorPlayer"] = visitorPlayer;
    map["repository_type"] = repository_type;
//    map["repository"] = repository.toMap(); // adicionar como um objeto
    map["track_count"] = track_count;
    map["game_songs_count"] = game_songs_count;
    map["game_mode"] = game_mode;
    map["number_of_attempts"] = number_of_attempts;
    map["track_draw_type"] = track_draw_type;

    return map;
  }

  Future<bool> createMatchFirebase() async {
    final match_path = Firestore.instance.collection("matches");

    try {
      await match_path.add(this.toMap()).then((value) {
        String id = value.documentID;

        match_path.document(id).collection("repository").add(this.repository.toMap());

      });

      return Future.value(true);
    }
    catch(e) {
      return Future.value(false);
    }


  }

}
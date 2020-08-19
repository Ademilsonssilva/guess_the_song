import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guess_the_song/model/album.dart';
import 'package:guess_the_song/model/artist.dart';
import 'package:guess_the_song/model/player.dart';
import 'package:guess_the_song/model/playlist.dart';
import 'package:guess_the_song/model/repository.dart';
import 'package:guess_the_song/utils/firebase.dart';

class Match{

  List<String> players;
  String hostPlayer;
  String hostPlayerName;
  String visitorPlayer;
  String visitorPlayerName;

  bool invite;
  String status;

  String repository_type;
  Repository repository;

  int track_count;

  int game_songs_count;
  String game_mode;

  int number_of_attempts;
  String track_draw_type;

  String firebaseID;

  static const STATUS_INVITE_OPEN = "invite_open";

  static const GAME_MODE_ONLY_SONG = "only_song";
  static const GAME_MODE_SONG_AND_ARTIST = "song_and_artist";

  static const TRACK_DRAW_TYPE_SAME_DRAW = "same_draw"; // O jogo dos dois jogadores será exatamente igual
  static const TRACK_DRAW_TYPE_DIFF_SORT = "diff_sort"; // As mesmas musicas serao mostradas para os dois jogadores, mas não necessariamente na mesma ordem
  static const TRACK_DRAW_TYPE_DIFF_GAME = "diff_game"; // Cada player receberá musicas diferentes, de dentro do mesmo repositório

  Match();

  Match.fromMap(Map<String, dynamic> map){
    players = map["players"].cast<String>();
    hostPlayer = map["hostPlayer"];
    hostPlayerName = map["hostPlayerName"];
    visitorPlayer = map["visitorPlayer"];
    visitorPlayerName = map["visitorPlayerName"];
    repository_type = map["repository_type"];
    repository = Repository.create(map["repository_type"], map["repository"]);
    track_count = map["track_count"];
    game_songs_count = map["game_songs_count"];
    game_mode = map["game_mode"];
    number_of_attempts = map["number_of_attempts"];
    track_draw_type = map["track_draw_type"];
    invite = map["invite"];
    status = map["status"];
  }

  @override
  String toString() {
    // TODO: implement toString
    return "\n---NEW LOG\n - host player: ${hostPlayer}\n - visitor player: ${visitorPlayer}\n - repository type: ${repository_type}\n - repository: ${repository}\n - track count: ${track_count}";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["hostPlayer"] = hostPlayer;
    map["hostPlayerName"] = hostPlayerName;
    map["visitorPlayer"] = visitorPlayer;
    map["visitorPlayerName"] = visitorPlayerName;
    map["repository_type"] = repository_type;
    map["repository"] = repository.toMap(); // adicionar como um objeto
    map["track_count"] = track_count;
    map["game_songs_count"] = game_songs_count;
    map["game_mode"] = game_mode;
    map["number_of_attempts"] = number_of_attempts;
    map["track_draw_type"] = track_draw_type;

    map["invite"] = invite;
    map["status"] = status;

    map["players"] = players;

    return map;
  }

  Future<bool> createMatchFirebase() async {
    try {
      await Firestore.instance.collection("matches").add(this.toMap());

      return Future.value(true);
    }
    catch(e) {
      return Future.value(false);
    }

  }

  Future<bool> deleteFromFirebase () async {
    try {
      await FirebaseHelper.match_path_firebase.document(this.firebaseID).delete();
      print('conseguiu excluir');
      return Future.value(true);
    }
    catch(e) {
      print('nao conseguiu');
      return Future.value(false);
    }

  }

}
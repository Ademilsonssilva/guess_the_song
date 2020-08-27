import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guess_the_song/model/album.dart';
import 'package:guess_the_song/model/artist.dart';
import 'package:guess_the_song/model/game.dart';
import 'package:guess_the_song/model/match_item.dart';
import 'package:guess_the_song/model/player.dart';
import 'package:guess_the_song/model/playlist.dart';
import 'package:guess_the_song/model/repository.dart';
import 'package:guess_the_song/model/track.dart';
import 'package:guess_the_song/utils/firebase.dart';

class Match{

  List<String> players;
  String hostPlayer;
  String hostPlayerName;
  String visitorPlayer;
  String visitorPlayerName;

  Game game = Game();

  bool invite;
  String status;

  String repository_type;
  Repository repository;

  int track_count; // quantidade de musicas no repositorio

  int game_songs_count; // quantidade de musicas que serão usadas na partida
  String game_mode; // modo de jogo (adivinhar só musica ou musica e artista)

  int number_of_attempts; // numero de pausas na musica
  String track_draw_type; // Forma de sorteio das musicas

  String firebaseID;

  static const STATUS_INVITE_OPEN = "invite_open";
  static const STATUS_INVITE_REJECTED = "invite_rejected";
  static const STATUS_MATCH_ACTIVE = "match_active";

  static const STATUS_DETAILS = {
    STATUS_INVITE_OPEN: {
      "description": "Convite aguardando resposta",
    },
    STATUS_INVITE_REJECTED: {
      "description": "Convite recusado",
    },
    STATUS_MATCH_ACTIVE: {
      "description": "Partida em andamento",
    }
  };



  static const GAME_MODE_ONLY_SONG = "only_song";
  static const GAME_MODE_SONG_AND_ARTIST = "song_and_artist";

  static const GAME_MODE_DETAILS = {
    GAME_MODE_ONLY_SONG: {
      "description": "Adivinhar a música",
    },
    GAME_MODE_SONG_AND_ARTIST: {
      "description": "Adivinhar música e artista"
    }
  };

  static const TRACK_DRAW_TYPE_SAME_DRAW = "same_draw"; // O jogo dos dois jogadores será exatamente igual
  static const TRACK_DRAW_TYPE_DIFF_SORT = "diff_sort"; // As mesmas musicas serao mostradas para os dois jogadores, mas não necessariamente na mesma ordem
  static const TRACK_DRAW_TYPE_DIFF_GAME = "diff_game"; // Cada player receberá musicas diferentes, de dentro do mesmo repositório

  static const TRACK_DRAW_DETAILS = {
    TRACK_DRAW_TYPE_SAME_DRAW: {
      "description": 'Músicas e ordem iguais',
    },
    TRACK_DRAW_TYPE_DIFF_SORT: {
      "description": 'Músicas iguais, ordem diferente',
    },
    TRACK_DRAW_TYPE_DIFF_GAME: {
      "description": 'Músicas diferentes',
    },
  };

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

    if(game != null) {
      map["game"] = game.toMap();
    }

    return map;
  }

  Future<bool> acceptMatchFirebase() async
  {
    this.status = STATUS_MATCH_ACTIVE;

    List<MatchItem> p1List = generateRandomTrackList();
    List<MatchItem> p2List;

    if(track_draw_type == TRACK_DRAW_TYPE_SAME_DRAW) {
      p2List = []..addAll(p1List);
    }
    else if (track_draw_type == TRACK_DRAW_TYPE_DIFF_SORT) {
      p2List = []..addAll(p1List);
      p2List.shuffle();
    }
    else if (track_draw_type == TRACK_DRAW_TYPE_DIFF_GAME) {
      p2List = generateRandomTrackList();
    }

    game.player_game[hostPlayer] = p1List;
    game.player_game[visitorPlayer] = p2List;

    this.invite = false;

    await Firestore.instance.collection("matches").document(firebaseID).updateData(toMap());

  }

  List<MatchItem> generateRandomTrackList()
  {

    Random rdn = Random();

    List<int> usedIndexes = List<int>();

    List<MatchItem> list = List<MatchItem>();

    for(int i = 0; i < game_songs_count; i++) {

      int index = rdn.nextInt(track_count);
//      print(index);
      if (!usedIndexes.contains(index)) {
        Track selectedTrack = repository.tracklist[index];
        MatchItem item = MatchItem.create(selectedTrack.title);
//        print ("index $index adicionado");
        usedIndexes.add(index);
//        print(usedIndexes);
        list.add(item);
      }
      else {
        i--;
      }

    }

    return list;
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
  
  Future<bool> updateMatchFirebase(Match match) async {
    try {
      await Firestore.instance.collection("matches").document(match.firebaseID).updateData(match.toMap());
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
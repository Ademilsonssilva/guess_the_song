import 'package:guess_the_song/model/player.dart';
import 'package:guess_the_song/model/repository.dart';

class Match{

  List<Player> players;
  String hostPlayer;
  String visitorPlayer;

  String repository_type;
  Repository repository;

  int track_count;

  static const GAME_MODE_ONLY_SONG = "only_song";
  static const GAME_MODE_SONG_AND_ARTIST = "song_and_artist";

  Match();

  @override
  String toString() {
    // TODO: implement toString
    return "\n---NEW LOG\n - host player: ${hostPlayer}\n - visitor player: ${visitorPlayer}\n - repository type: ${repository_type}\n - repository: ${repository}\n - track count: ${track_count}";
  }

}
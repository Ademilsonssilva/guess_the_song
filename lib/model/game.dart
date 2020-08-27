import 'package:guess_the_song/model/match_item.dart';

class Game {
  int totalScore;

  Map<String, List<MatchItem>> player_game = Map<String, List<MatchItem>>();

  @override
  String toString() {
    return player_game.toString();
  }

  Map<String, List<Map<String, dynamic>>> toMap () {
    Map<String, List<Map<String, dynamic>>> map = Map<String, List<Map<String, dynamic>>>();

    player_game.forEach((String key, List<MatchItem> list) {
      List<Map<String, dynamic>> newList = List<Map<String, dynamic>>();
      list.forEach((MatchItem match_item) {
        newList.add(match_item.toMap());
      });
      map[key] = newList;
    });

    return map;

  }

  Map<String, dynamic> toMap2 () {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["game"] = toMap();

    return map;
  }
}
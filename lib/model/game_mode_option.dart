import 'package:guess_the_song/model/album.dart';

import 'model.dart';

class GameModeOption extends Model{

  GameModeOption();

  static GameModeOption create(String type, Map map) {
    switch (type) {
      case 'album':
        return new Album.fromMap(map);
        break;
      default:
        return new GameModeOption();
    }
  }

}
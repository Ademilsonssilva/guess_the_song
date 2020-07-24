import 'package:flutter/material.dart';
import 'package:guess_the_song/model/album.dart';
import 'artist.dart';
import 'playlist.dart';

import 'model.dart';

class GameModeOption extends Model{

  GameModeOption();

  String type;

  static GameModeOption create(String type, Map map) {
    switch (type) {
      case 'album':
        return new Album.fromMap(map);
        break;
      case 'artist':
        return new Artist.fromMap(map);
        break;
      case 'playlist':
        return new Playlist.fromMap(map);
      default:
        return new GameModeOption();
    }
  }

  AlertDialog getAlertDialogDetails(){
    return AlertDialog();
  }

  void showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this.getAlertDialogDetails();
      }
    );
  }

}
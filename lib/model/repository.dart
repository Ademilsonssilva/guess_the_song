import 'package:flutter/material.dart';
import 'package:guess_the_song/model/album.dart';
import 'package:guess_the_song/model/track.dart';
import 'artist.dart';
import 'playlist.dart';

import 'model.dart';

class Repository extends Model{

  Repository();

  List<Track> tracklist;
  int track_count;

  String firebaseID;
  int id; // deezer_id

  static const REPOSITORY_TYPE_ALBUM = "album";
  static const REPOSITORY_TYPE_ARTIST = "artist";
  static const REPOSITORY_TYPE_PLAYLIST = "playlist";

  String type;

  Repository.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    track_count = map["track_count"];
  }

  static Repository create(String type, Map map) {
    switch (type) {
      case REPOSITORY_TYPE_ALBUM:
        return new Album.fromMap(map);
        break;
      case REPOSITORY_TYPE_ARTIST:
        return new Artist.fromMap(map);
        break;
      case REPOSITORY_TYPE_PLAYLIST:
        return new Playlist.fromMap(map);
      default:
        return new Repository();
    }
  }

  Map<String, dynamic> toMap() {
    Map <String, dynamic> map = Map<String, dynamic>();

    map["id"] = id;
    map["type"] = type;
    map["track_count"] = track_count;
    map["tracklist"] = List<Map<String, dynamic>>();

    tracklist.forEach((Track track) {
      map["tracklist"].add(track.toMap());
    });

    return map;
  }

  String getTitle() {
    return "";
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
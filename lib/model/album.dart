import 'package:flutter/material.dart';
import 'model.dart';
import 'game_mode_option.dart';

class Album extends GameModeOption {

  int _id;
  String _title;
  String _link;
  String _cover_url;
  int _genre_id;
  int _nb_tracks;
  int _artist_id;
  String _artist_name;

  Album.fromMap(Map<String, dynamic> map) {
    print(map);
    _id = map['id'];
    _title = map['title'];
    _link = map['link'];
    _cover_url = map['cover'];
    _genre_id = map['genre_id'];
    _nb_tracks = map['nb_tracks'];
    _artist_id = map['artist']['id'];
    _artist_name = map['artist']['name'];
  }

  Widget getListTile(){
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.network(
                  _cover_url,
                  width: 70,
                  height: 70,
                ),
              ),
              Column(
                children: <Widget>[
                  Text(this.toString()),
                  Text("Number of tracks" + _nb_tracks.toString())
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        print(this.toString());
      },
    );
  }

  @override
  toString () {
    return '${_id}: ${_title}';
  }

}
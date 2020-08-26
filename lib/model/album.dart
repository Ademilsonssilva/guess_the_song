import 'package:flutter/material.dart';
import 'model.dart';
import 'repository.dart';

class Album extends Repository {

  String _title;
  String _link;
  String _cover_url;
  int _genre_id;
  int _nb_tracks;
  int _artist_id;
  String _artist_name;

  Album.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    if (image == null) {
      image = map['cover'];
    }
    image_big = map["image_big"] ?? map["cover_big"];
    _title = map['title'];
    _link = map['link'];
    _cover_url = map['cover'];
    _genre_id = map['genre_id'];
    _nb_tracks = map['nb_tracks'];
    _artist_id = map["artist_id"] ?? map['artist']['id'];
    _artist_name = map["artist_name"] ?? map['artist']['name'];
    type = map['type'];
  }

  String getTitle(){
    return _title;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map["title"] = _title;
    map["link"] = _link;
    map["cover_url"] = _cover_url;
    map["genre_id"] = _genre_id;
    map["nb_tracks"] = _nb_tracks;
    map["artist_id"] = _artist_id;
    map["artist_name"] = _artist_name;

    return map;
  }

  Widget getListTile(BuildContext context){

    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Image.network(
            _cover_url,
            width: 80,
            height: 80,
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Album: " + _title,
                style: TextStyle(
                    fontSize: 16
                ),
              ),
              Text("Artist: " + _artist_name,
                style: TextStyle(
                    fontSize: 14
                ),
              ),
              Text("Number of tracks: " + _nb_tracks.toString(),
                  style: TextStyle(
                      fontSize: 12
                  )
              )
            ],
          ),
        )
      ],
    );

  }

  @override
  AlertDialog getAlertDialogDetails(){
    return AlertDialog(
      title: Text('Playlist ' + _title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(_cover_url),
                radius: 65,
              ),
            ),
          ),
          Text('Title: ' + _title),
          Text('Number of tracks: ' + _nb_tracks.toString()),
          Text('Artist: ' + _artist_name),
        ],
      ),
    );
  }

  @override
  toString () {
    return '${id}: ${_title} - ${track_count}';
  }

}
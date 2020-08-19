import 'package:flutter/material.dart';
import 'package:guess_the_song/model/repository.dart';

class Playlist extends Repository{

  String _title;
  bool _public;
  int _nb_tracks;
  String _link;
  String _picture_path;
  String _tracklist;
  int _user_id;
  String _user_name;


  Playlist.fromMap(Map<String, dynamic> map) : super.fromMap(map) {

    if (image == null) {
      image = map['picture'];
    }

    _title = map['title'];
    _public = map['public'];
    _nb_tracks = map['nb_tracks'];
    _link = map['link'];
    _picture_path = map['picture'];
    _tracklist = map['tracklist'];
    _user_id = map["user_id"] ?? map['user']['id'];
    _user_name = map["user_name"] ?? map['user']['name'];
    type = map['type'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map["title"] = _title;
    map["link"] = _link;
    map["public"] = _public;
    map["tracklist"] = _tracklist;
    map["nb_tracks"] = _nb_tracks;
    map["user_id"] = _user_id;
    map["user_name"] = _user_name;

    return map;
  }

  String getTitle(){
    return _title;
  }

  Widget getListTile(BuildContext context){
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Image.network(
            _picture_path,
            width: 80,
            height: 80,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("" + (_title.length <= 30 ? _title : _title.substring(0, 29) + '...'),
              style: TextStyle(
                  fontSize: 16
              ),
            ),
            Text("Number of tracks: " + _nb_tracks.toString(),
              style: TextStyle(
                  fontSize: 14
              ),
            ),
          ],
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
                backgroundImage: NetworkImage(_picture_path),
                radius: 65,
              ),
            ),
          ),
          Text('Title: ' + _title),
          Text('Public: ' + (_public ? 'Yes' : 'No')),
          Text('Number of tracks: ' + _nb_tracks.toString()),
          Text('User: ' + _user_name),
        ],
      ),
    );
  }

  @override
  toString () {
    return '${id}: ${_title}';
  }

}
import 'package:flutter/material.dart';
import 'package:guess_the_song/model/game_mode_option.dart';

class Artist extends GameModeOption{

  int _id;
  String _name;
  String _link;
  String _picture_path;
  int _nb_fans;
  int _nb_album;
  String _tracklist_path;

  Artist.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _link = map['link'];
    _picture_path = map['picture'];
    _nb_fans = map['nb_fans'];
    _nb_album = map['nb_album'];
    _tracklist_path = map['tracklist'];
    type = map['type'];
  }

  Widget getListTile(BuildContext context){
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Row(
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
                  Text("Artist: " + _name,
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                  Text("Number of albuns: " + _nb_album.toString(),
                    style: TextStyle(
                        fontSize: 14
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        print(this.toString());
      },
      onLongPress: () {
        this.showDetails(context);
      },
    );
  }

  @override
  AlertDialog getAlertDialogDetails(){
    return AlertDialog(
      title: Text('Artist ' + _name),
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
          Text('Artist: ' + _name),
          Text('Link: ' + _link),
          Text('Number of albuns: ' + _nb_album.toString()),
        ],
      ),
    );
  }

  @override
  toString () {
    return '${_id}: ${_name}';
  }

}
import 'package:flutter/material.dart';
import 'package:guess_the_song/model/repository.dart';

class Artist extends Repository{

  String _name;
  String _link;
  String _picture_path;
  int _nb_fans;
  int _nb_album;

  Artist.fromMap(Map<String, dynamic> map) : super.fromMap(map) {

    if(image == null) {
      image = map['picture'];
    }
    image_big = map["image_big"] ?? map["picture_big"];
    _name = map['name'];
    _link = map['link'];
    _picture_path = map['picture'];
    _nb_fans = map['nb_fans'];
    _nb_album = map['nb_album'];
    type = map['type'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    map["name"] = _name;
    map["link"] = _link;
    map["picture_path"] = _picture_path;
    map["nb_fans"] = _nb_fans;
    map["nb_album"] = _nb_album;

    return map;
  }

  String getTitle() {
    return _name;
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
        Flexible(
          child: Column(
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
          ),
        )
      ],
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
    return '${id}: ${_name}';
  }

}
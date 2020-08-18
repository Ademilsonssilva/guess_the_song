class Track {

  int id;
  String title;
  String title_short;
  int artist_id;
  String preview;

  Track.fromMap(Map<String, dynamic> map) {

    id = map["id"];
    title = map["title"];
    title_short = map["title_short"];
    artist_id = map["artist_id"] ?? map["artist"]["id"];
    preview = map["preview"];
  }

  Map<String, dynamic> toMap () {
    Map <String, dynamic> map = Map<String, dynamic>();

    map["id"] = id;
    map["title"] = title;
    map["title_short"] = title_short;
    map["artist_id"] = artist_id;
    map["preview"] = preview;

    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "\n----- Song Log\n - id: ${id}\n - title: ${title}\n - title_short: ${title_short}\n - artist_id: ${artist_id}\n - preview: ${preview}";
  }
}
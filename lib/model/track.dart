class Track {

  int id;
  String title;
  String title_short;
  int artist_id;
  String preview;

  Track.fromMap(Map map) {
    id = map["id"];
    title = map["title"];
    title_short = map["title_short"];
    artist_id = map["artist"]["id"];
    preview = map["preview"];
  }

  @override
  String toString() {
    // TODO: implement toString
    return "\n----- Song Log\n - id: ${id}\n - title: ${title}\n - title_short: ${title_short}\n - artist_id: ${artist_id}\n - preview: ${preview}";
  }
}
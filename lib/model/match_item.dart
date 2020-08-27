class MatchItem {

  String song;
  int startedTime;
  String response;
  int score;

  MatchItem.create(this.song);

  MatchItem.fromMap(Map<String, dynamic> map){

  }

  Map<String, dynamic> toMap () {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["song"] = song;
    map["startedTime"] = startedTime;
    map["response"] = response;
    map["score"] = score;

    return map;
  }

  @override
  String toString() {
    return "$song";
  }
}
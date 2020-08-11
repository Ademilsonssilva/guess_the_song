import 'package:guess_the_song/model/track.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Deezer {

  static final String _deezer_api_base_path = "https://api.deezer.com/";
  static final String _deezer_api_search_path = _deezer_api_base_path + "search/";

  static Future<List<Track>> getTrackList (String repository_type, String repository_id) async
  {
    String search_path = _deezer_api_base_path + "${repository_type}/${repository_id}";

    List<Track> tracklist = new List<Track>();

    final response = await http.get(search_path);

    if (response.statusCode == 200) {
      List raw_tracklist = json.decode(response.body)["tracks"]["data"];
      raw_tracklist.forEach((raw_track) {
        Track track = Track.fromMap(raw_track);
        tracklist.add(track);
      });
    }

    return tracklist;

  }

}
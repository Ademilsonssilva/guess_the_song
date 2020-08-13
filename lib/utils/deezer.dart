import 'package:guess_the_song/model/repository.dart';
import 'package:guess_the_song/model/track.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Deezer {

  static final String _deezer_api_base_path = "https://api.deezer.com/";
  static final String _deezer_api_search_path = _deezer_api_base_path + "search/";

  static Future<List<Track>> getTrackList (String repository_type, String repository_id) async
  {
    String search_path;

    if (repository_type == Repository.REPOSITORY_TYPE_ARTIST) { // Quando é buscado por artista, a rota da API é diferente. Na normal não tem o array tracks
      search_path = _deezer_api_base_path + "${repository_type}/${repository_id}/top?limit=100";
    }
    else {
      search_path = _deezer_api_base_path + "${repository_type}/${repository_id}";
    }

    print(search_path);

    List<Track> tracklist = new List<Track>();

    final response = await http.get(search_path);

    if (response.statusCode == 200) {

      List raw_tracklist;

      if (repository_type == Repository.REPOSITORY_TYPE_ARTIST) { //Quando a busca é por artista, não tem o objeto tracks, então temos que buscar o top de musicas do artista, o que muda o retorno
        raw_tracklist = json.decode(response.body)["data"];
      }
      else {
        raw_tracklist = json.decode(response.body)["tracks"]["data"];
      }

      raw_tracklist.forEach((raw_track) {
        Track track = Track.fromMap(raw_track);
        tracklist.add(track);
      });
    }

    return tracklist;

  }

}
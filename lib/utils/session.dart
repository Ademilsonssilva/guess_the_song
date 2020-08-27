import 'package:guess_the_song/model/match.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guess_the_song/model/player.dart';

class Session {

  static Match new_match;

  static FirebaseUser firebaseUser = null;

  static Player player;

}
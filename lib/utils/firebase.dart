import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static final match_path_firebase = Firestore.instance.collection("matches");
}
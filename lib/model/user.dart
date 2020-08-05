import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class User extends Model {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();

  static User of(BuildContext context) => ScopedModel.of<User>(context);

  bool isLoading = false;

  @override
  void addListener(listener) {
    // TODO: implement addListener
    super.addListener(listener);

    _loadCurrentUser();
  }

  bool isLoggedIn()
  {
    return firebaseUser != null;
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) {
      isLoading = true;
      notifyListeners();
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance.collection("players").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  void signUp({@required Map<String, dynamic> userData, @required String password, @required VoidCallback onSuccess, @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
      email: userData['email'],
      password: password
    ).then(
        (user) async {
          firebaseUser = user.user;

          await _saveUserData(userData);

          onSuccess();
          isLoading = false;
          notifyListeners();
        }
    ).catchError(
        (error) {
          onFail();
          isLoading = false;
          notifyListeners();
        }
    );
  }

  void signIn({@required String email, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: pass).then((user ) async {
      firebaseUser = user.user;

      await _loadCurrentUser();

      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      print(e);
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("players").document(firebaseUser.uid).setData(userData);
  }

}
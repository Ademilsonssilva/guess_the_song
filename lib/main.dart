import 'package:flutter/material.dart';
import 'package:guess_the_song/components/create_match_selection.dart';
import 'package:guess_the_song/model/user.dart';
import 'package:guess_the_song/screens/home_screen.dart';
import 'package:guess_the_song/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<User>(
      model: User(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 71, 73, 115)
        ),
        title: "Guess the song - The game",
        home: HomeScreen(),
      ),
//      title: "Guess the song - The game",
//      home: ScopedModel<User>(
//        model: User(),
//        child: LoginScreen(),
//      ),
    );
  }
}

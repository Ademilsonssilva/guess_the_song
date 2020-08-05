import 'package:flutter/material.dart';
import 'package:guess_the_song/components/create_match_selection.dart';
import 'package:guess_the_song/screens/login_screen.dart';

void main()
{
  runApp(MaterialApp(
    title: "Guess the song - The game",
    home: LoginScreen(),
  ));
}
import 'package:flutter/material.dart';
import 'package:guess_the_song/components/create_match_selection.dart';

void main()
{
  runApp(MaterialApp(
    title: "Guess the song - The game",
    home: Scaffold(
      appBar: AppBar(
        title: Text("Guess the song - The game"),
        centerTitle: true,
      ),
      body: CreateMatchSelection(),
//
    ),
  ));
}
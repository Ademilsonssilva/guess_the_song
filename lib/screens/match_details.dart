import 'dart:ui';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:guess_the_song/model/match.dart';
import 'package:guess_the_song/utils/session.dart';

class MatchDetails extends StatelessWidget {

  Match match;

  MatchDetails(this.match);

  @override
  Widget build(BuildContext context) {

    String textoCancelarDesafio = match.status == Match.STATUS_INVITE_REJECTED ? "Desafio rejeitado\nExcluir convite" : 'Cancelar desafio';

    return Scaffold(
//      appBar: ,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            snap: false,
            elevation: 2,
            stretch: true,
            expandedHeight:250,

            flexibleSpace: BackgroundFlexibleSpaceBar(
              background: ClipRect(
                child: Container(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1)
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        match.repository.image_big ?? match.repository.image
                      ),
                      fit: BoxFit.fill
                    )
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Column(
                  children: <Widget>[

                    Session.firebaseUser.uid == match.hostPlayer ? Padding( //Jogador é o criador. Nesse caso só pode cancelar
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: FlatButton(
                                color: Colors.red,
                                onPressed: () {
                                  match.deleteFromFirebase();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  textoCancelarDesafio,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                    :
                    Padding( // jogador é o desafiado. pode cancelar ou aceitar
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
//                            alignment: Alignment.topLeft,
                            child: FlatButton(
                              color: Colors.green,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Aceitar desafio",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
//                            alignment: Alignment.topRight,
                            child: FlatButton(
                              color: Colors.red,
                              onPressed: () {
                                match.status = Match.STATUS_INVITE_REJECTED;
                                match.updateMatchFirebase(match);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Recusar desafio",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(match.repository.getTitle(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Tipo de repositório: " + match.repository_type,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Jogador desafiante: " + match.hostPlayerName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text( match.visitorPlayer != "open" ? "Jogador convidado: " + match.visitorPlayerName : "Sala aberta",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Status: " + Match.STATUS_DETAILS[match.status]["description"],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Configurações da partida:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 4,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Quantidade de músicas no desafio:" + match.game_songs_count.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Modo de jogo: " + Match.GAME_MODE_DETAILS[match.game_mode]["description"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Número de tentativas: " + match.number_of_attempts.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Tipo de sorteio: " + Match.TRACK_DRAW_DETAILS[match.track_draw_type]["description"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )


                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Voltar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    )

                  ],
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}

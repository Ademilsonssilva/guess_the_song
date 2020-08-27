import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guess_the_song/components/appbar.dart';
import 'package:guess_the_song/model/match.dart';
import 'package:guess_the_song/model/player.dart';
import 'package:guess_the_song/model/repository.dart';
import 'package:guess_the_song/model/track.dart';
import 'package:guess_the_song/model/user.dart';
import 'package:guess_the_song/screens/match_details.dart';
import 'package:guess_the_song/screens/new_game.dart';
import 'package:guess_the_song/utils/session.dart';
import 'package:scoped_model/scoped_model.dart';

class LobbyScreen extends StatefulWidget {
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
//    return ScopedModelDescendant<User>(
//      builder: (context, child, model){
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Area do jogador"),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              automaticallyImplyLeading: false,
              actions: <Widget>[
                PopupMenuButton(
                  onSelected: (selection) {
                    if(selection == 'logout') {
                      User.of(context).signOut();
                      Navigator.pop(context);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: "logout",
                        child: Text("Sair"),
                      )
                    ];
                  },
                )
              ],
              bottom: TabBar(
                indicatorColor: Colors.blueAccent,
                tabs: [
                  Tab(child: Text("Convites"),),
                  Tab(child: Text("Encontrar partida"),),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                StreamBuilder(
                  stream: Firestore.instance.collection("matches").where(
                    "players",
                    arrayContains: Session.firebaseUser.uid
                  ).snapshots() , // Retorna todos os matches relacionados ao jogador
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);

                    if(snapshot.connectionState == ConnectionState.active) {

                      List<Widget> cards = List<Widget>();

                      for (int i = 0; i < snapshot.data.documents.length; i++) {

//                        if (snapshot.data.documents[i].data["visitorPlayer"] != "open") {

                        Match match = Match.fromMap(snapshot.data.documents[i].data);
                        match.firebaseID = snapshot.data.documents[i].documentID;

                        String visitorPlayerString = match.visitorPlayer == "open" ? "Sala aberta" : "Você desafiou " + match.visitorPlayerName;
                        String buttonString = match.status == Match.STATUS_INVITE_REJECTED ? "Convite recusado\nExcluir convite" : 'Cancelar desafio';

                        Color buttonColor;
                        Function buttonAction;

                        Widget card;
                        if(snapshot.data.documents[i].data["hostPlayer"] == Session.firebaseUser.uid) { //Convites que o jogador criou



                          if(match.invite == false) {
                            buttonString = "Jogar!";
                            buttonColor = Theme.of(context).primaryColor;
                             buttonAction = () {
                                print('oi gente');
                            };
                          }
                          else {
                            buttonColor = Colors.red;
                            buttonAction = () {
                              match.deleteFromFirebase();
                            };
                          }

                          card = matchCard(
                              buttonText: buttonString,
                              buttonColor: buttonColor,
                              match: match,
                              context: context,
                              cardTitle: visitorPlayerString,
                              buttonAction: buttonAction
                          );

                          cards.add(card);
                        }
                        else { // Convites que o jogador recebeu
                          if(match.status != Match.STATUS_INVITE_REJECTED) {

                            visitorPlayerString = snapshot.data.documents[i]["hostPlayerName"] + " desafiou você";
                            Widget floatingMenuPrefixButton;

                            if(match.invite == true) {
                              buttonColor = Colors.green;
                              buttonString = "Aceitar desafio";
                              buttonAction = () {
                                match.acceptMatchFirebase();
                              };

                              floatingMenuPrefixButton = FlatButton(
                                onPressed: () {
                                  setState(() {
                                    match.status = Match.STATUS_INVITE_REJECTED;
                                  });
                                  Navigator.pop(context);
                                  match.updateMatchFirebase(match);
                                },
                                color: Colors.red,
                                child: Text(
                                  "Recusar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              );
                            }
                            else {
                              buttonString = "Jogar";
                              buttonColor = Theme.of(context).primaryColor;
                              buttonAction = () {
                                print('oi gente bora jogar');
                              };
                            }

                            card = matchCard(
                                buttonText: buttonString,
                                buttonColor: buttonColor,
                                match: match,
                                context: context,
                                cardTitle: visitorPlayerString,
                                buttonAction: buttonAction,
                                floatingMenuPrefixButton: floatingMenuPrefixButton
                            );

                            cards.add(card);
                          }
                        }

                      }
                      return ListView(
                        children: cards
                      );
                    }
                    else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                ),

                //SEGUNDA TAB
                StreamBuilder(
                  stream: Firestore.instance.collection("matches").where(
                      "players",
                      arrayContains: "open"
                  ).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.connectionState == ConnectionState.active) {
                      List<Widget> cards = List<Widget>();

                      for (int i = 0; i < snapshot.data.documents.length; i++) { //Convites abertos de outros jogadores

                        Match match = Match.fromMap(snapshot.data.documents[i].data);
                        match.firebaseID = snapshot.data.documents[i].documentID;

                        if(snapshot.data.documents[i].data["hostPlayer"] != Session.firebaseUser.uid) {

                          Widget card;
                          String buttonString = "Entrar na partida";
                          Color buttonColor = Colors.green;
                          String visitorPlayerString = "Partida criada por " + match.hostPlayerName;
                          Function buttonAction = () {
                            print('entrou aqui');
                            setState(() {
                              match.visitorPlayer = Session.firebaseUser.uid;
                              match.visitorPlayerName = Session.player.name;
                              match.players[match.players.indexOf("open")] = Session.firebaseUser.uid;
                            });

                            match.acceptMatchFirebase();
                          };

                          card = matchCard(
                            buttonText: buttonString,
                            buttonColor: buttonColor,
                            match: match,
                            context: context,
                            cardTitle: visitorPlayerString,
                            buttonAction: buttonAction
                          );

                          cards.add(card);
                        }

                      }

                      return ListView(
                        children: cards
                      );
                    }
                    else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {

                DocumentSnapshot doc = await Firestore.instance.collection("players").document(Session.firebaseUser.uid).get();
                Player player = Player.fromMap(doc.data);
                player.id = doc.documentID;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewGame(player)
                ));
              },
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        );
//      }
//    );
  }

  Widget matchCard ({
    @required String buttonText,
    @required Color buttonColor,
    @required Match match,
    @required BuildContext context,
    @required String cardTitle,
    @required Function buttonAction,
    Widget floatingMenuPrefixButton
  }) {

    List<Widget> floatingMenuActions = List<Widget>();
    if(floatingMenuPrefixButton != null) {


      floatingMenuActions.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2),
            child: floatingMenuPrefixButton,
          ),
        )
      );
    }
    floatingMenuActions.add(
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(2),
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MatchDetails(match)
              ));
            },
            child: Text('Detalhes',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Row(
                    children: floatingMenuActions
                  ),
                );
              }
          );
        },
        child: Card(

            elevation: 15,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Session.firebaseUser.uid == match.hostPlayer ? Alignment.topLeft : Alignment.topRight,
                    child: Text(cardTitle),
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      match.hostPlayer == Session.firebaseUser.uid ? Image.network(
                        match.repository.image,
                        width: 80,
                        height: 80,
                      ) : Container(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Session.firebaseUser.uid == match.hostPlayer ? Alignment.topLeft : Alignment.topRight,
                                child: Text(match.repository.type + ' ' + match.repository.getTitle()) ,
                              ),
                              Align(
                                alignment: Session.firebaseUser.uid == match.hostPlayer ? Alignment.topLeft : Alignment.topRight,
                                child: Text("Quantidade de músicas: " + match.game_songs_count.toString()) ,
                              ),
                              Align(
                                alignment: Session.firebaseUser.uid == match.hostPlayer ? Alignment.bottomRight : Alignment.bottomLeft,
                                child: FlatButton(
                                  onPressed: buttonAction,
                                  color: buttonColor,
                                  child: Text(
                                    buttonText,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      match.hostPlayer != Session.firebaseUser.uid ? Image.network(
                        match.repository.image,
                        width: 80,
                        height: 80,
                      ) : Container(),
                    ],
                  ),

                ],
              ),
            )
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guess_the_song/components/appbar.dart';
import 'package:guess_the_song/model/match.dart';
import 'package:guess_the_song/model/player.dart';
import 'package:guess_the_song/model/repository.dart';
import 'package:guess_the_song/model/track.dart';
import 'package:guess_the_song/model/user.dart';
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

                        if (snapshot.data.documents[i].data["visitorPlayer"] != "open") {

                          Match match = Match.fromMap(snapshot.data.documents[i].data);
                          match.firebaseID = snapshot.data.documents[i].documentID;

                          Widget card;
                          if(snapshot.data.documents[i].data["hostPlayer"] == Session.firebaseUser.uid) {
                             card = Padding(
                               padding: EdgeInsets.all(10),
                               child: Card(

                                 elevation: 15,
                                 child: Padding(
                                   padding: EdgeInsets.all(10),
                                   child: Column(
                                     children: <Widget>[
                                       Align(
                                         alignment: Alignment.topLeft,
                                         child: Text("Você desafiou " + snapshot.data.documents[i]["visitorPlayerName"]),
                                       ),
                                       Divider(),
                                       Row(
                                         children: <Widget>[
                                           Image.network(
                                             match.repository.image,
                                             width: 80,
                                             height: 80,
                                           ),
                                           Expanded(
                                             child: Padding(
                                               padding: EdgeInsets.all(15),
                                               child: Column(
                                                 children: <Widget>[
                                                   Align(
                                                     alignment: Alignment.topLeft,
                                                     child: Text(match.repository.type + ' ' + match.repository.getTitle()) ,
                                                   ),
                                                   Align(
                                                     alignment: Alignment.topLeft,
                                                     child: Text("Quantidade de músicas: " + match.game_songs_count.toString()) ,
                                                   ),
                                                   Align(
                                                     alignment: Alignment.bottomRight,
                                                     child: FlatButton(
                                                       onPressed: () {
                                                         match.deleteFromFirebase();
                                                       },
                                                       color: Colors.red,
                                                       child: Text(
                                                         "Cancelar desafio",
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
                                           )
                                         ],
                                       ),

                                     ],
                                   ),
                                 )
                               ),
                             );
                          }
                          else {
                            card = Padding(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text("oi"),
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
                                            alignment: Alignment.topRight,
                                            child: Text(snapshot.data.documents[i]["hostPlayerName"] + " desafiou você"),
                                          ),
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: Text(match.repository.type + ' ' + match.repository.getTitle()) ,
                                                      ),
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: Text("Quantidade de músicas: " + match.game_songs_count.toString()) ,
                                                      ),
                                                      Align(
                                                        alignment: Alignment.bottomLeft,
                                                        child: FlatButton(
                                                          onPressed: () {
//                                                          match.deleteFromFirebase();
                                                          },
                                                          color: Colors.green,
                                                          child: Text(
                                                            "Aceitar desafio",
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
                                              Image.network(
                                                match.repository.image,
                                                width: 80,
                                                height: 80,
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    )
                                ),
                              ),
                            );
                          }

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
                  }
                ),
                Container(color: Colors.blue,)
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
}

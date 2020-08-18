import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guess_the_song/components/appbar.dart';
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
                          Map<String, dynamic> matchData = snapshot.data.documents[i].data;
                          final repository = Repository.fromMap(matchData["repository"]);

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
                                         child: Text("Convidou: " + snapshot.data.documents[i]["visitorPlayerName"]),
                                       ),
                                       Divider(),
                                       Row(
                                         children: <Widget>[
                                           CircleAvatar(
                                             backgroundImage: NetworkImage(repository.image),
                                             radius: 40,
                                           ),
                                           Expanded(
                                             child: Padding(
                                               padding: EdgeInsets.all(15),
                                               child: Column(
                                                 children: <Widget>[
                                                   Align(
                                                     alignment: Alignment.topLeft,
                                                     child: Text(repository.type + repository.getTitle()) ,
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

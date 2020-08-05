import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guess_the_song/model/user.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class NewGameChooseOpponentTab extends StatefulWidget {

  final PageController controller;

  static final tabNumber = 1;

  NewGameChooseOpponentTab(this.controller);

  @override
  _NewGameChooseOpponentTabState createState() => _NewGameChooseOpponentTabState();
}

class _NewGameChooseOpponentTabState extends State<NewGameChooseOpponentTab> {

  String selectedPlayerDropdown;
  String selectedPlayer;

  Color buttonColor = Colors.transparent;
  Color fontColor = null;

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<User>(
      builder: (context, child, model){
        return ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 60),
                child: Center(
                  child: Text(
                    "Criando sua partida...",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
              ),
              Center(
                child: LinearPercentIndicator(
                  progressColor: Theme.of(context).primaryColor,
                  percent: 0,
                  padding: EdgeInsets.all(30),
                  lineHeight: 20,
                  center: Text("50%", style: TextStyle(color: Colors.black, fontSize: 20),),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text("Desafiar um amigo:",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
              ),
              Center(
                child: StreamBuilder(
                  stream: Firestore.instance.collection("players").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<DropdownMenuItem> players = [];
                    for(int i = 0; i < snapshot.data.documents.length; i++) {

                      if(!model.isLoading) {
                        if (model.firebaseUser.uid != snapshot.data.documents[i].documentID) {
                          players.add(DropdownMenuItem(
                            child: Text(
                              snapshot.data.documents[i]["name"],
                            ),
                            value: snapshot.data.documents[i].documentID,
                          ));
                        }
                      }

                    }

                    return DropdownButton(
                      items: players,
                      onChanged: (val) {
                        setState(() {
                          selectedPlayerDropdown = val;
                          selectedPlayer = val;
                          buttonColor = Colors.transparent;
                          fontColor = Theme.of(context).primaryColor;
                        });
                      },
                      value: selectedPlayerDropdown,
                    );

                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 20),
                child: Center(
                  child: Text("Ou", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24),),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedPlayerDropdown = null;
                        selectedPlayer = "open";
                        buttonColor = Colors.greenAccent;
                        fontColor = Colors.green;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(
                            color: Colors.grey[500],
                            width: 1
                        )
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Criar sala aberta",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: fontColor == null ? Theme.of(context).primaryColor : fontColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              selectedPlayer == null ? Container() : Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Proximo >>",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () {
                      widget.controller.jumpToPage(1);
                    },
                  ),
                ),
              )
            ]
        );
      }
    );
  }
}

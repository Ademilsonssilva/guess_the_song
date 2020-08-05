import 'package:flutter/material.dart';
import 'package:guess_the_song/components/create_match_selection.dart';
import 'package:guess_the_song/model/user.dart';
import 'package:guess_the_song/screens/lobby_screen.dart';
import 'package:guess_the_song/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Color primaryColor = Color.fromARGB(255, 71, 73, 115);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            centerTitle: true,
            title: Text("Home"),
            actions: <Widget>[
              !User.of(context).isLoggedIn() ? Container() :
              PopupMenuButton(
                onSelected: (selection) {
                  if(selection == 'logout') {
                    model.signOut();
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
          ),
          body: model.isLoading
            ? Center(child: CircularProgressIndicator(),)
            : ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    bottom: 200
                ),
                child: Text("Regras"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: FlatButton(
                  child: Text(model.isLoggedIn() ? "Jogar!" : "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                  onPressed: model.isLoggedIn()
                    ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LobbyScreen()
                      ));
                    }
                    : () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()
                      ));
                    }
                  ,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

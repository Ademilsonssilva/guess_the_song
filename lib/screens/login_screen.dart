import 'package:flutter/material.dart';
import 'package:guess_the_song/components/create_match_selection.dart';
import 'package:guess_the_song/model/user.dart';
import 'package:guess_the_song/screens/lobby_screen.dart';
import 'package:guess_the_song/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:guess_the_song/components/create_match_selection.dart.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Color primaryColor = Color.fromARGB(255, 71, 73, 115);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("ACESSAR"),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignUpScreen())
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: primaryColor,
        onPressed: () {
          fazLogin(User.of(context));
        },
      ),
      body: ScopedModelDescendant<User>(
        builder: (context, child, model) {
          if(model.isLoading) {
            return Center(child: CircularProgressIndicator(),);
          }
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 80, left: 30, right: 30),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if(val.isEmpty || !val.contains("@")) {
                            return "Informe um email válido";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Email"
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40, left: 30, right: 30),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (String val) {
                          if (val.isEmpty || val.length < 6) {
                            return "Informe uma senha válida";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Senha"
                        ),
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40, left: 50, right: 50),
                      child: SizedBox(
                        height: 50,
                        child: FlatButton(

                          onPressed: () {
                            fazLogin(model);
                          },
                          color: primaryColor,
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20, top: 30),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => SignUpScreen())
                            );
                          },
                          child: Text(
                            "Clique aqui para criar uma conta",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

  }

  void fazLogin(User user)
  {
    if (_formKey.currentState.validate()) {
      user.signIn(
        email: _emailController.text,
        pass: _passwordController.text,
        onSuccess: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LobbyScreen()
          ));
        },
        onFail: () {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Não foi possível logar!\nTente novamente"),
            backgroundColor: Colors.red,
          ));
        }
      );
    }
  }
}

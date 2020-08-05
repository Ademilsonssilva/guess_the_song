import 'package:flutter/material.dart';
import 'package:guess_the_song/model/user.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  Color primaryColor = Color.fromARGB(255, 71, 73, 115);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("NOVO JOGADOR"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: ScopedModelDescendant<User>(
        builder: (context, child, model){
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
                      padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintText: "Nome"
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Preencha um nome!";
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (val) {
                          if (val.isEmpty || !val.contains("@")) {
                            return "Informe um email válido";
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Email"
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (val) {
                          if (val.isEmpty || val.length < 6) {
                            return "A senha deve ter no mínimo 6 caracteres";
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
                            if (_formKey.currentState.validate()) {
                              Map<String, dynamic> userData = {
                                "name": _nameController.text,
                                "email": _emailController.text,
                              };

                              model.signUp(
                                userData: userData,
                                password: _passwordController.text,
                                onSuccess: () {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text("Usuário criado com sucesso. \nEm instantes será direcionado..."),
                                    backgroundColor: Colors.greenAccent,
                                  ));

                                  Future.delayed(Duration(seconds: 4)).then((value) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });

                                },
                                onFail: () {
                                  print("caiu no erro hein");
                                }
                              );

                              print(userData);
                            }
                          },
                          color: primaryColor,
                          child: Text(
                            "Cadastrar",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
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
        }
      ),
    );
  }
}

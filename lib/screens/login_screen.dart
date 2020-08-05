import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Color primaryColor = Color.fromARGB(68, 113, 67, 173);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 80, left: 30, right: 30),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Login"
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40, left: 30, right: 30),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Password"
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

                  },
                  color: primaryColor,
                  child: Text(
                    "Enter",
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
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:pirapp/API/auth.dart';
import 'package:pirapp/pages/courses.dart';

final storage = new FlutterSecureStorage();


class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _isLoggedIn();
    super.initState();
  }

  _isLoggedIn() async {
    var email = await storage.read(key: 'email');
    var password = await storage.read(key: 'password');
    if(email!=null && password!=null) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
      });
    }
  }


  _signIn() async {
    var email = _emailController.text;
    var password = _passwordController.text;
    var res = await signIn(email, password);
    if(res) {
      Navigator.push(context,
        CupertinoPageRoute(builder: (context) => new Courses())
      );
    }
  }

  /*@override
  void dispose() async {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    TextStyle style = new TextStyle(fontSize: 20.0);

    final emailField = new TextField(
      obscureText: false,
      style: style,
      decoration: new InputDecoration(
        contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        prefixIcon: new Icon(
          Icons.email,
          color: Color(0xffB51E3A),
        ),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(32.0),
        ),
        focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(32.0),
            borderSide: new BorderSide(
                color: Color(0xffB51E3A),
                width: 2.5
            )
        ),
        prefixStyle: TextStyle(
            color: Color(0xffB51E3A)
        ),
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: true,
    );

    final passwordField = new TextField(
      obscureText: true,
      style: style,
      decoration: new InputDecoration(
        contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        prefixIcon: new Icon(
          Icons.lock,
          color: Color(0xffB51E3A),
        ),
        hintText: "Password",
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(32.0),
        ),
        focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(32.0),
            borderSide: new BorderSide(
                color: Color(0xffB51E3A),
                width: 2.5
            )
        ),
      ),
      autocorrect: false,
      controller: _passwordController,
    );

    final loginButton = new Material(
      elevation: 5.0,
      borderRadius: new BorderRadius.circular(30.0),
      color: Color(0xffB51E3A),
      child: new MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        child: new Text(
          "Login",
          textAlign: TextAlign.center,
          style: style.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold
          ),
        ),
        onPressed: () {
          _signIn();
        },
      ),
    );

    return new Container(
      color: Colors.white,
      child: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            child: new Padding(
              padding: const EdgeInsets.all(36.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SizedBox(
                      height: 155.0,
                      child: new Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(30.0),
                          boxShadow: [
                            new BoxShadow(
                                blurRadius: 13.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(0.0,0.0)
                            ),
                          ],
                        ),
                        child: new Image.asset(
                          "images/logo.png",
                          fit: BoxFit.contain,
                        ),
                      )
                  ),
                  new SizedBox(height: 45.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(height: 35.0),
                  loginButton,
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



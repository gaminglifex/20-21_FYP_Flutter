import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/AppRoutes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool isSubmitting = true;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final emailField = TextFormField(
      enabled: isSubmitting,
      controller: _emailController,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email_outlined,
          color: Colors.black,
        ),
        hintText: 'JohnDoe@example.com',
        labelText: 'Email',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );

    final passwordField = Column(
      children: <Widget>[
        TextFormField(
          enabled: isSubmitting,
          controller: _passwordController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outlined, color: Colors.black),
            hintText: 'Password',
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(2.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MaterialButton(
              child: Text(
                "Forget Password",
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.grey, decoration: TextDecoration.underline),
              ),
              onPressed: () {
                //TODO: Create forgot password.
              },
            ),
          ],
        ),
      ],
    );

    final fields = Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          emailField,
          passwordField,
        ],
      ),
    );

    final loginButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: mq.size.height / 15.0,
          width: mq.size.width / 2.0,
          child: RaisedButton(
            color: Colors.white,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              try {
                UserCredential userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              } catch (e) {
                print(e);
              }
            },
          ),
        ),
      ],
    );

    final bottom = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Not a member?",
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Colors.grey),
        ),
        MaterialButton(
          child: Text(
            'Sign Up',
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.authRegister);
          },
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          key: _formKey,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  height: mq.size.height / 1.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      fields,
                      loginButton,
                    ],
                  ),
                ),
              ),
            ),
            bottom,
          ],
        ),
      ),
    );
  }
}

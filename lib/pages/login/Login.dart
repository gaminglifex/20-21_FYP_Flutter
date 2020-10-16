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
      //keyboardType: TextInputType.visiblePassword,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
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

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: mq.size.width / 2.0,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
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
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        loginButton,
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.authRegister);
              },
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: Container(
            height: mq.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                fields,
                bottom,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

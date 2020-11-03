import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_uiprototype/AppRoutes.dart';
// import 'package:fyp_uiprototype/FirebaseAuthentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_uiprototype/common_widget/alert_dialog.dart';
import 'package:fyp_uiprototype/pages/login/FirebaseAuthService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final valid = await emailCheck(_emailController.text.trim());
    final valid2 = await passwordCheck(_passwordController.text.trim());
    if (!_formKey.currentState.validate()) {
      AlertDialogBuilder.alertBuilder("Please check your input!", context);
      return null;
    } else if (valid) {
      // print('Email does not exist');
      AlertDialogBuilder.alertBuilder("Email does not exist!", context);
      return null;
    } else if (valid2) {
      // print('Email does not exist');
      AlertDialogBuilder.alertBuilder("Password does not match!", context);
      return null;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
      Navigator.of(context).pushNamed(AppRoutes.homePage);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> emailCheck(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isEmpty;
  }

  Future<bool> passwordCheck(String password) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('password', isEqualTo: password)
        .get();
    return result.docs.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final emailField = TextFormField(
      controller: _emailController,
      onFieldSubmitted: (value) {
        _passwordFocusNode.requestFocus();
      },
      keyboardType: TextInputType.emailAddress,
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Email cannot be empty!';
        }
        return null;
      },
    );

    final passwordField = Column(
      children: <Widget>[
        TextFormField(
          focusNode: _passwordFocusNode,
          controller: _passwordController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outlined, color: Colors.black),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility),
            ),
            hintText: 'Password',
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
          obscureText: _obscureText,
          validator: (value) {
            if (value.isEmpty) {
              return 'Password cannot be empty!';
            }
            return null;
          },
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
              _login();
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
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}

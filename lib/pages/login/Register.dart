import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/AppRoutes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  bool isSubmitting = true;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final usernameField = TextFormField(
      enabled: isSubmitting,
      controller: _usernameController,
      //keyboardType: TextInputType.visiblePassword,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: 'John Doe',
        labelText: 'Username',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );

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
          obscureText: true,
          //keyboardType: TextInputType.emailAddress,
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
      ],
    );

    final repasswordField = Column(
      children: <Widget>[
        TextFormField(
          enabled: isSubmitting,
          controller: _repasswordController,
          obscureText: true,
          //keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Password',
            labelText: 'Re-enter Password',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );

    final fields = Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          usernameField,
          emailField,
          passwordField,
          repasswordField,
        ],
      ),
    );

    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
          minWidth: mq.size.width / 2.0,
          padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: Text(
            'Register',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            try {
              UserCredential userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim());
              print('DLLM');
              User user = userCredential.user;
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print('The password provided is too weak.');
              } else if (e.code == 'email-already-in-use') {
                print('The account already exists for that email.');
              }
            } catch (e) {
              print(e);
            }
          }),
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        signupButton,
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Got an account?",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.grey),
            ),
            MaterialButton(
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.authLogin);
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

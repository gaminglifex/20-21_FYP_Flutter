import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_uiprototype/common_widget/alert_dialog.dart';
import 'package:fyp_uiprototype/auth_service/FirebaseAuthService.dart';

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
  //FocusNode _usernameFocusNode;
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _repasswordFocusNode = FocusNode();
  //Password visibility
  bool _obscureText = true;
  bool _obscureText2 = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repasswordFocusNode.dispose();
    super.dispose();
  }

  //final _dobController = TextEditingController();
  Future<bool> fieldCheck(String field, String text) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where(field, isEqualTo: text)
        .get();
    return result.docs.isEmpty;
  }

  Future<void> _createAccount() async {
    final valid = await fieldCheck("usernme", _usernameController.text.trim());
    final valid2 = await fieldCheck("email", _emailController.text.trim());
    if (!_formKey.currentState.validate()) {
      AlertDialogBuilder.alertBuilder("Please check your input!", context);
      return null;
    } else if (!valid) {
      AlertDialogBuilder.alertBuilder("Username alreasdy exist!", context);
      return null;
    } else if (!valid2) {
      AlertDialogBuilder.alertBuilder("Email already exist!", context);
      return null;
    }
    createUserWithEmailAndPassword(_usernameController.text.trim(),
        _emailController.text.trim(), _passwordController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final usernameField = TextFormField(
      controller: _usernameController,
      //keyboardType: TextInputType.visiblePassword,
      onFieldSubmitted: (value) {
        _emailFocusNode.requestFocus();
      },
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle_outlined),
        hintText: 'John Doe',
        labelText: 'Username',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Username cannot be empty.';
        }
        return null;
      },
    );

    final emailField = TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      onFieldSubmitted: (value) {
        _passwordFocusNode.requestFocus();
      },
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email_outlined),
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
          return 'Email is required';
        }
        if (!RegExp(
                "^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*")
            .hasMatch(value)) {
          return 'Enter a valid emil address';
        }
        return null;
      },
    );

    final passwordField = Column(
      children: <Widget>[
        TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          onFieldSubmitted: (value) {
            _repasswordFocusNode.requestFocus();
          },
          obscureText: _obscureText,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outlined),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_rounded),
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
          validator: (value) {
            if (value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 8) {
              return 'Password length should greater than 8';
            }
            return null;
          },
        ),
      ],
    );

    final repasswordField = Column(
      children: <Widget>[
        TextFormField(
          controller: _repasswordController,
          focusNode: _repasswordFocusNode,
          obscureText: _obscureText2,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outlined),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText2 = !_obscureText2;
                });
              },
              child: Icon(_obscureText2
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_rounded),
            ),
            hintText: 'Password',
            labelText: 'Confirm Password',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Password is required';
            }
            if (value != _passwordController.text) {
              return 'The confirm password does not match';
            }
            return null;
          },
        ),
      ],
    );

    final fields = Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          usernameField,
          //dobField,
          emailField,
          passwordField,
          repasswordField,
        ],
      ),
    );

    final signupButton = Row(
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
              'Register',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              _createAccount();
            },
          ),
        ),
      ],
    );

    final bottom = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
              ),
              onPressed: () {
                Get.toNamed('/authLogin');
              },
            ),
          ],
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
                child: Container(
                  height: mq.size.height / 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5.0,
                        blurRadius: 7.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      fields,
                      signupButton,
                    ],
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

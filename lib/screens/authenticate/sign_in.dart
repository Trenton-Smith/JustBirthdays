import 'package:flutter/material.dart';
import 'package:just_birthdays/services/auth.dart';
import 'package:just_birthdays/shared/constants.dart';
import 'package:just_birthdays/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        title: Text('Sign in to JustBirthdays!'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'email',
                ),
                validator: (val) => val.isEmpty ? 'Please enter a valid email address' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                // decoration: textInputDecoration.copyWith(hintText: 'password'),
                decoration: InputDecoration(
                  hintText: 'password',
                ),
                validator: (val) => val.length < 6 ? 'Please enter a password 6+ chars long' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: Colors.lightBlue,
                    child: Text(
                      'Need to Register?',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      widget.toggleView();
                    },
                  ),
                  RaisedButton(
                    color: Colors.green,
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        print(email);
                        print(password);
                        dynamic credential = await _auth
                            .signInWithEmailAndPassword(email, password);
                        if (credential == null) {
                          setState(() {
                            error = 'Incorrect email or password';
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
              TextButton(
                child: Text(
                  'skip for now',
                  style: TextStyle(color: Colors.black54),
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  dynamic result = await _auth.signInAnon();
                  if(result == null) {
                    print('error signing in');
                  } else {
                    // print('signed in');
                    // print(result.uid);
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),

        // ***Sign in anon*** //
        // child: RaisedButton(
        //   child: Text('Sign in anonymously'),
        //   onPressed: () async {
        //     dynamic result = await _auth.signInAnon();
        //     if(result == null) {
        //       print('error signing in');
        //     } else {
        //       print('signed in');
        //       print(result.uid);
        //     }
        //   },
        // )
      )
    );
  }
}

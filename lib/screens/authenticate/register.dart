import 'package:flutter/material.dart';
import 'package:just_birthdays/services/auth.dart';
import 'package:just_birthdays/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email ='';
  String password = '';
  String passwordMatch = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          elevation: 0.0,
          title: Text('Register with JustBirthdays!'),
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
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'verify password',
                  ),
                  validator: (val) => val != password ? 'Passwords do not match' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => passwordMatch = val);
                  },
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      color: Colors.red[400],
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        widget.toggleView();
                      },
                    ),
                    RaisedButton(
                      color: Colors.green,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          // print(email);
                          // print(password);
                          setState(() {
                            loading = true;
                          });
                          dynamic credential = await _auth
                              .registerWithEmailAndPassword(email, passwordMatch);
                          if (credential == null) {
                            setState(() {
                              error = 'Please provide a valid email and password';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                  ],
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
        )
    );
  }
}

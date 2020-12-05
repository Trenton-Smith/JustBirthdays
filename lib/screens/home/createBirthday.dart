import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_birthdays/models/birthday.dart';
import 'package:just_birthdays/models/superUser.dart';
import 'package:just_birthdays/screens/home/home.dart';
import 'package:just_birthdays/services/database.dart';
import 'package:just_birthdays/shared/birthday_list.dart';

import '../../main.dart';

class CreateBirthday extends StatefulWidget {

  @override
  _CreateBirthdayState createState() => _CreateBirthdayState();
}

class _CreateBirthdayState extends State<CreateBirthday> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  void inputData(Birthday newBirthday) {
    final User user = auth.currentUser;
    final uid = user.uid;
    // print('this is a test: ' + uid);
    DatabaseService(uid: uid).updateUserBirthday(newBirthday);
    // DatabaseService(uid: uid).sortBirthdays();
  }
  void deleteData(Birthday newBirthday) {
    final User user = auth.currentUser;
    final uid = user.uid;
    // print('this is a test: ' + uid);
    DatabaseService(uid: uid).deleteUserBirthday(newBirthday);
  }

  String _selectedDate = 'Select a birthdate:';
  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // firstDate: DateTime.now().subtract(new Duration(days: 365)),
      firstDate: DateTime(1800),
      lastDate: DateTime.now().add(new Duration(days: 365)),
    );
    if (d != null)
      setState(() {
        date = d;
        _selectedDate = new DateFormat.MMMd("en_US").format(d);
        if (d.month < DateTime.now().month) {
          age = DateTime.now().year - d.year + 1;
        } else if (d.month == DateTime.now().month && d.day <= DateTime.now().day) {
          age = DateTime.now().year - d.year + 1;
        } else {
          age = DateTime.now().year - d.year;
        }
      });
  }

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String firstName ='';
  String lastName = '';
  String sortName = '';
  String notes = '';
  String error = '';
  int age = 0;
  bool twoWeeks = false;
  bool oneWeek = false;
  bool twoDays = false;
  bool oneDay = false;
  bool favorite = false;
  DateTime date;
  // List<Birthday> birthdayList = [];

  final fieldTextFirstName = TextEditingController();
  final fieldTextLastName = TextEditingController();
  final fieldTextNotes = TextEditingController();

  void clearText() {
    fieldTextFirstName.clear();
    fieldTextLastName.clear();
    fieldTextNotes.clear();
    setState(() {
      _selectedDate = 'Select a birthdate:';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // SizedBox(height: 5.0),
            TextFormField(
              controller: fieldTextFirstName,
              maxLength: 16,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                hintText: 'first name',
              ),
              validator: (val) => val.isEmpty ? 'Please enter a first name' : null,
              onChanged: (val) {
                setState(() => firstName = val);
              },
            ),
            // SizedBox(height: 5.0),
            TextFormField(
              controller: fieldTextLastName,
              maxLength: 16,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                hintText: 'last name (optional)',
              ),
              // validator: (val) => val.length < 6 ? 'Please enter a password 6+ chars long' : null,
              // obscureText: true,
              onChanged: (val) {
                setState(() => lastName = val);
              },
            ),
            // SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_selectedDate, style: TextStyle(fontSize: 16),),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {_selectDate(context);},
                ),
              ]
            ),
            // SizedBox(height: 5.0),
            TextFormField(
              controller: fieldTextNotes,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 3,
              maxLength: 200,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                hintText: 'notes:',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
              onChanged: (val) {
                setState(() => notes = val);
              },
            ),
            // SizedBox(height: 15.0),
            Text('Reminders: ', style: TextStyle(fontSize: 16),),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(value: this.twoWeeks, onChanged: (bool value) {
                    setState(() {
                      this.twoWeeks = value;
                    });
                  }),
                  Text('2wk', style: TextStyle(fontSize: 14),),
                  Checkbox(value: this.oneWeek, onChanged: (bool value) {
                    setState(() {
                      this.oneWeek = value;
                    });
                  }),
                  Text('1wk', style: TextStyle(fontSize: 14),),
                  Checkbox(value: this.twoDays, onChanged: (bool value) {
                    setState(() {
                      this.twoDays = value;
                    });
                  }),
                  Text('2dy', style: TextStyle(fontSize: 14),),
                  Checkbox(value: this.oneDay, onChanged: (bool value) {
                    setState(() {
                      this.oneDay = value;
                    });
                  }),
                  Text('1dy', style: TextStyle(fontSize: 14),),
                ],
            ),
            // InputDatePickerFormField(firstDate: DateTime.utc(1800,01,01), lastDate: DateTime.utc(2100,01,01)),
            // TextFormField(
            //   decoration: InputDecoration(
            //     hintText: 'verify password',
            //   ),
            //   validator: (val) => val != password ? 'Passwords do not match' : null,
            //   obscureText: true,
            //   onChanged: (val) {
            //     setState(() => passwordMatch = val);
            //   },
            // ),
            // SizedBox(height: 20.0),
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
                    clearText();
                    // inputData();
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  color: Colors.green,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // print(email);
                      // print(password);
                      Birthday bday = new Birthday(
                        firstName: firstName,
                        lastName: lastName,
                        sortName: firstName.toLowerCase() + lastName.toLowerCase(), // *********************************
                        birthdate: _selectedDate,
                        age: age,
                        notes: notes,
                        twoWeeks: twoWeeks,
                        oneWeek: oneWeek,
                        twoDays: twoDays,
                        oneDay: oneDay,
                        favorite: favorite,
                        date: date,
                      );
                      setState(() {
                        loading = true;
                        inputData(bday);
                        // deleteData(bday);
                        Navigator.pop(context);
                      });
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

    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_birthdays/models/birthday.dart';
import 'package:just_birthdays/models/superUser.dart';
import 'package:just_birthdays/screens/home/home.dart';
import 'package:just_birthdays/services/database.dart';
import 'package:just_birthdays/shared/birthday_list.dart';

class EditBirthday extends StatefulWidget {

  Birthday _bday;
  EditBirthday(Birthday bday) {
    this._bday = bday;
  }

  @override
  _EditBirthdayState createState() => _EditBirthdayState();
}

class _EditBirthdayState extends State<EditBirthday> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  void deleteData(Birthday bday) {
    final User user = auth.currentUser;
    final uid = user.uid;
    // print('this is a test: ' + uid);
    DatabaseService(uid: uid).deleteUserBirthday(bday);
  }
  void editData(Birthday newBirthday) {
    final User user = auth.currentUser;
    final uid = user.uid;
    // print('this is a test: ' + uid);
    DatabaseService(uid: uid).editUserBirthday(newBirthday);
  }

  String _selectedDate = 'Reselect if needed: ';
  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now().add(new Duration(days: 365)),
    );
    if (d != null)
      setState(() {
        date = d;
        selectedDate = new DateFormat.MMMd("en_US").format(d);
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
  String firstName = '';
  String lastName = '_@!';
  String selectedDate = '';
  String notes = '_@!';
  int age = 0;
  bool twoWeeks = false;
  bool oneWeek = false;
  bool twoDays = false;
  bool oneDay = false;
  String error = '';
  bool favorite;
  DateTime date;


  @override
  Widget build(BuildContext context) {

    Birthday oldBDay = Birthday().copyBirthday(widget._bday);
    Birthday bdayToDelete = Birthday().copyBirthday(widget._bday);
    bdayToDelete.date = bdayToDelete.dateStamp.toDate();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.0),
            TextFormField(
              maxLength: 16,
              maxLengthEnforced: true,
              initialValue: oldBDay.firstName,
              // controller: fieldTextFirstName,
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
              initialValue: oldBDay.lastName,
              maxLength: 16,
              maxLengthEnforced: true,
              // controller: fieldTextLastName,
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
              initialValue: oldBDay.notes,
              // controller: fieldTextNotes,
              keyboardType: TextInputType.multiline,
              maxLength: 200,
              maxLengthEnforced: true,
              minLines: 3,
              maxLines: 3,
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
            Text('Reselect reminders: ', style: TextStyle(fontSize: 16),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(value: twoWeeks, onChanged: (bool value) {
                  setState(() {
                    // oldBDay.twoWeeks = value;
                    twoWeeks = value;
                  });
                }),
                Text('2wk', style: TextStyle(fontSize: 14),),
                Checkbox(value: oneWeek, onChanged: (bool value) {
                  setState(() {
                    // oldBDay.oneWeek = value;
                    oneWeek = value;
                  });
                }),
                Text('1wk', style: TextStyle(fontSize: 14),),
                Checkbox(value: twoDays, onChanged: (bool value) {
                  setState(() {
                    // oldBDay.twoDays = value;
                    twoDays = value;
                  });
                }),
                Text('2dy', style: TextStyle(fontSize: 14),),
                Checkbox(value: oneDay, onChanged: (bool value) {
                  setState(() {
                    // oldBDay.oneDay = value;
                    oneDay = value;
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
                    // clearText();
                    // inputData();
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  color: Colors.green,
                  child: Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // print(email);
                      // print(password);
                      if(firstName == ""){
                        firstName = oldBDay.firstName;
                      }
                      if(lastName == "_@!"){
                        lastName = oldBDay.lastName;
                      }
                      if(notes == "_@!"){
                        notes = oldBDay.notes;
                      }
                      if(selectedDate == ""){
                        selectedDate = oldBDay.birthdate;
                      }
                      if(age == 0){
                        age = oldBDay.age;
                      }
                      if(date == null){
                        date = oldBDay.dateStamp.toDate();
                      }
                      // if(twoWeeks == false && twoWeeks != oldBDay.twoWeeks){
                      //   twoWeeks = oldBDay.twoWeeks;
                      // }
                      // if(oneWeek == false && oneWeek != oldBDay.oneWeek){
                      //   oneWeek = oldBDay.oneWeek;
                      // }
                      // if(twoDays == false && twoDays != oldBDay.twoDays){
                      //   twoDays = oldBDay.twoDays;
                      // }
                      // if(oneDay == false && oneDay != oldBDay.oneDay){
                      //   oneDay = oldBDay.oneDay;
                      // }
                      Birthday newbday = new Birthday(
                        firstName: firstName,
                        lastName: lastName,
                        sortName: firstName.toLowerCase() + lastName.toLowerCase(), // *********************************
                        birthdate: selectedDate,
                        notes: notes,
                        age: age,
                        twoWeeks: twoWeeks,
                        oneWeek: oneWeek,
                        twoDays: twoDays,
                        oneDay: oneDay,
                        favorite: oldBDay.favorite,
                        date: date,
                      );
                      // this should have max length of 2 for trial accounts
                      // need to add to database list here
                      setState(() {
                        loading = true;
                        if (Home.birthdayList.contains(widget._bday)) {
                          Home.birthdayList.remove(widget._bday);
                          Home.birthdayList.add(newbday);
                        }
                        try {
                          bdayToDelete.dateStamp = null;
                          deleteData(bdayToDelete);
                        } catch (e) {
                          print('original birthday is not in database');
                        }
                        editData(newbday);
                        Navigator.pop(context);
                      });
                      // dynamic credential = await _auth
                      //     .registerWithEmailAndPassword(email, passwordMatch);
                      // if (credential == null) {
                      //   setState(() {
                      //     error = 'Please provide a valid email and password';
                      //     loading = false;
                      //   });
                      // }
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

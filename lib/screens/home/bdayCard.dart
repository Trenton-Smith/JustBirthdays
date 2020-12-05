import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_birthdays/models/birthday.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:just_birthdays/screens/home/home.dart';
import 'package:just_birthdays/services/database.dart';
import 'package:just_birthdays/shared/birthday_list.dart';
import 'package:just_birthdays/shared/loading.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'createBirthday.dart';
import 'editBirthday.dart';

class BdayCard extends StatefulWidget {

  final Birthday bday;
  BdayCard({ this.bday });

  @override
  _BdayCardState createState() => _BdayCardState();
}

class _BdayCardState extends State<BdayCard> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void deleteData(Birthday bday) {
    final User user = auth.currentUser;
    final uid = user.uid;
    // print('this is a test: ' + uid);
    DatabaseService(uid: uid).deleteUserBirthday(bday);
  }

  void editData(Birthday bday) {
    final User user = auth.currentUser;
    final uid = user.uid;
    // print('this is a test: ' + uid);
    DatabaseService(uid: uid).editUserBirthday(bday);
  }

  Icon _favorite = new Icon(Icons.favorite_border, color: Colors.red,);
  bool loading = false;

  Icon fav(Birthday bday) {
    if(bday.favorite == false) {
      return _favorite = new Icon(Icons.favorite_border, color: Colors.grey);
    } else {
      return _favorite = new Icon(Icons.favorite, color: Colors.red,);
    }
  }

  String daysCalc(Timestamp time) {
    var age;
    if (time.toDate().month < DateTime.now().month) {
      age = DateTime.now().year - time.toDate().year + 1;
    } else if (time.toDate().month == DateTime.now().month && time.toDate().day <= DateTime.now().day) {
      age = DateTime.now().year - time.toDate().year + 1;
    } else {
      age = DateTime.now().year - time.toDate().year;
    }

    var dayCalc = time.toDate();
    var newDayCalc;
    var calc;

    if(time.toDate().month < DateTime.now().month){
      // dayCalc.add(DateTime); = DateTime.now().year + 1;
      newDayCalc = new DateTime(DateTime.now().year + 1, dayCalc.month, dayCalc.day);
    } else if (time.toDate().month == DateTime.now().month && time.toDate().day <= DateTime.now().day) {
      // assert(dayCalc.year == DateTime.now().year + 1);
      newDayCalc = new DateTime(DateTime.now().year + 1, dayCalc.month, dayCalc.day);
    } else {
      // assert(dayCalc.year == DateTime.now().year);
      newDayCalc = new DateTime(DateTime.now().year, dayCalc.month, dayCalc.day);
    }
    // calc = DateTime.now().difference(newDayCalc).inDays;
    calc = newDayCalc.difference(DateTime.now()).inDays + 1;
    // calc = 1;

    if ( age == 0 ) {
      if ( calc == 365 ) {
        return 'was born today!';
      } else if ( calc == 1 ){
        return 'exp. d.o.b tomorrow!';
      } else {
        return 'exp. d.o.b. in ' + calc.toString() + ' days!';
      }
    }

    if ( calc == 1 ) {
      return 'turns $age tomorrow!';
    } else if ( calc == 365 ) {
      age = age - 1;
      if ( age == 0 ) {
        return 'was born today!';
      }
      return 'turns $age today!';
    } else {
      return 'turns $age in ' + calc.toString() + ' days!';
    }
  }

  @override
  Widget build(BuildContext context) {
    Birthday oldBDay = Birthday().copyBirthday(widget.bday);
    Birthday newBDay = Birthday().copyBirthday(widget.bday);
    newBDay.date = newBDay.dateStamp.toDate();
    oldBDay.date = oldBDay.dateStamp.toDate();

    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Container(
        height: 75,
        // margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Card(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
            elevation: 4.0,
            child: loading ? Loading() :ListTile(
              leading: Container(
                width: 55,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    )
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,0.0,15.0,0.0),
                  child: Text(widget.bday.birthdate, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                ),
              ),
              title: Text(widget.bday.firstName + ' ' + widget.bday.lastName, overflow: TextOverflow.fade, softWrap: false, style: TextStyle(fontSize: 20),),
              subtitle: Text(daysCalc(widget.bday.dateStamp), style: TextStyle(fontSize: 16),),
              trailing: TextButton.icon(
                icon: fav(widget.bday),
                label: Text(''),
                onPressed: () {
                  setState(() {
                    loading = true;
                    if (this._favorite.icon == Icons.favorite_border) {
                      // Home.loadHome = true;
                      this._favorite = new Icon(Icons.favorite, color: Colors.red,);
                      newBDay.favorite = true;
                      newBDay.date = newBDay.dateStamp.toDate();
                      oldBDay.date = oldBDay.dateStamp.toDate();
                      oldBDay.dateStamp = null;
                      // editData(newBDay);
                      deleteData(oldBDay);
                      // loading = true;

                      editData(newBDay);
                      // loading = true;

                    } else {
                      // Home.loadHome = true;
                      this._favorite = new Icon(Icons.favorite_border, color: Colors.red,);
                      newBDay.favorite = false;
                      newBDay.date = newBDay.dateStamp.toDate();
                      oldBDay.date = oldBDay.dateStamp.toDate();
                      oldBDay.dateStamp = null;
                      // editData(newBDay);
                      deleteData(oldBDay);
                      // loading = true;

                      editData(newBDay);
                      // loading = true;

                    }
                    Future.delayed(const Duration(milliseconds: 200), () {
                      // editData(newBDay);
                      // deleteData(oldBDay);
                      setState(() {
                        loading = false;
                      });
                      // editData(newBDay);
                      // deleteData(oldBDay);
                    });
                  });
                },
              ),
          ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete_forever,
              onTap: () {
                if (Home.birthdayList.contains(widget.bday)) {
                  Home.birthdayList.remove(widget.bday);
                } else {
                  print('birthday was not in the base array');
                }
                try {
                  oldBDay.dateStamp = null;
                  deleteData(oldBDay);
                  // deleteData(widget.bday);
                } catch (e) {
                  print('not in database');
                }
                // Home.birthdayList.remove(bday);
              },
            ),
            IconSlideAction(
              caption: 'Edit',
              color: Colors.black45,
              icon: Icons.edit,
              onTap: () {
                Navigator.of(context).push(
                    PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, __, ___) {
                          return new Scaffold(
                            backgroundColor: Colors.black45,
                            body: new Container(
                              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  children: <Widget> [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget> [
                                          IconButton(
                                            onPressed: () {Navigator.pop(context);},
                                            icon: Icon(Icons.close),
                                          ),
                                        ]
                                    ),
                                    Container(
                                      height: 30.0,
                                        child: Text('Edit ' + widget.bday.firstName + "'s Birthday!", textAlign: TextAlign.center, style: TextStyle(fontSize: 28),),
                                    ),
                                    EditBirthday(widget.bday),
                                  ]
                              ),
                            ),
                          );
                        }
                    )
                );
              }
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Expand',
              color: Colors.green,
              icon: Icons.more_horiz,
                onTap: () {
                  Navigator.of(context).push(
                      PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, __, ___) {
                            return new Scaffold(
                              backgroundColor: Colors.black45,
                              body: new Container(
                                margin: EdgeInsets.fromLTRB(12.0, 90.0, 12.0, 65.0),
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                    children: <Widget> [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget> [
                                            IconButton(
                                              onPressed: () {Navigator.pop(context);},
                                              icon: Icon(Icons.close),
                                            ),
                                          ]
                                      ),
                                      // Text(widget.bday.firstName + "'s Notes!", textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0),),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 80.0,
                                              child: Text(widget.bday.firstName + "'s Notes!", textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0), overflow: TextOverflow.fade,)),
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                            height: 270.0,
                                            child: Text(widget.bday.notes, style: TextStyle(fontSize: 20.0), overflow: TextOverflow.fade,),
                                          ),
                                        ],
                                      )
                                    ]
                                ),
                              ),
                            );
                          }
                      )
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}

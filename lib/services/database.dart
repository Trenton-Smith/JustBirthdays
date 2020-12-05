import 'dart:convert';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_birthdays/models/birthday.dart';
import 'package:just_birthdays/models/superUser.dart';
import 'package:just_birthdays/screens/home/bdayCard.dart';
import 'package:just_birthdays/screens/home/home.dart';
import 'package:just_birthdays/shared/birthday_list.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  //collection reference
  final CollectionReference birthdayProfiles = FirebaseFirestore.instance.collection('birthdays');


  //initial registration - add Birthday array to private document
  Future updateUserData(List<Birthday> birthdayList) async {
    return await birthdayProfiles.doc(uid).set({
      'birthdayList': birthdayList,
    });
  }
  // Future updateUserData(Birthday birthday) async {
  //   return await birthdayProfiles.doc(uid).collection('birthdaycoll').add({
  //     'first name': birthday.firstName,
  //     'last name': birthday.lastName,
  //     'birthdate': birthday.birthdate,
  //     'notes': birthday.notes,
  //     'twoWeeks': birthday.twoWeeks,
  //     'oneWeek': birthday.oneWeek,
  //     'twoDays': birthday.twoDays,
  //     'oneDay': birthday.oneDay,
  //   });
  // }

  //add birthday profiles after creation to user's private document
  Future updateUserBirthday(Birthday bday) async {
    var bdayJson = bday.toJson();
    try {
      return await birthdayProfiles.doc(uid).update({
        'birthdayList': FieldValue.arrayUnion([bdayJson]),
      });
    } catch(e) {
      print('User is not registered!');
      if (Home.birthdayList.length < 3) {
        Home.birthdayList.add(bday);
        print('Birthday added to in-app memory');
      } else {
        print('User must register to add any further birthdays');
      }
    }
  }
  // Future updateUserBirthday(Birthday birthday) async {
  //   return await birthdayProfiles.doc(uid).collection('birthdaycoll').add({
  //     'first name': birthday.firstName,
  //     'last name': birthday.lastName,
  //     'birthdate': birthday.birthdate,
  //     'notes': birthday.notes,
  //     'twoWeeks': birthday.twoWeeks,
  //     'oneWeek': birthday.oneWeek,
  //     'twoDays': birthday.twoDays,
  //     'oneDay': birthday.oneDay,
  //   });
  // }

  //deleting an already existing birthday
  Future deleteUserBirthday(Birthday bday) async {
    var bdayJson = bday.toJson();
    try {
      return await birthdayProfiles.doc(uid).update({
        'birthdayList':  FieldValue.arrayRemove([bdayJson])
      });
    } catch (e) {
      print('birthday was not stored in database');
    }
  }

  //editing an already existing birthday
  Future editUserBirthday(Birthday bday) async {
    var bdayJson = bday.toJson();
    try {
      return await birthdayProfiles.doc(uid).update({
        'birthdayList': FieldValue.arrayUnion([bdayJson])
      });
    } catch (e) {
      print('error editing birthday');
    }
  }

  //sorting the list
  // sortBirthdays() {
  //   print('here');
  //   print(birthdayProfiles.doc(uid).get().toString());
  //   return birthdayProfiles.doc(uid).orderBy()
  // }

  //
  // Look into adjusting this method below in terms of how we reconstruct the list
  // after we pull from the database. e.g. -> static variable gets set? do this for loop
  // i.e. var sortCategory = 1  ->  sort by alphabetical order  ->
  // for(var value in s){Birthday bday = Birthday().fromJson(value); list.add(bday); sort after OR sort before adding to lift
  //
  // static variables should be set
  //
  static int sortOption = 1;
  static String searchTerm = '';
  List _birthdayListFromSnapshot(DocumentSnapshot snapshot) {
    List<Birthday> list = [];
    // list.add(snapshot.data().values);
    // list.add(snapshot.get("birthdayList")[0]);
    List s = snapshot.get('birthdayList'); //array containing json objects
    // print('here: ' + s.toString());
    // print(s.length);
    for (var value in s) {
      Birthday bday = Birthday().fromJson(value);
      bday.days = bday.daysCalc(bday.dateStamp);
      if(searchTerm == '') {
        list.add(bday);
      } else {
        if (bday.firstName.contains(searchTerm) || bday.firstName.toLowerCase().contains(searchTerm)){
          list.add(bday);
          // print(bday.dateStamp.toDate());
        }
      }
    }
    if(sortOption == 1){
      print('Sort by alphabetical order');
      list.sort((a, b) =>
          // a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase())
        a.sortName.compareTo(b.sortName)
      );
    }else if (sortOption == 2){
      print('Sort by date');
      list.sort((a, b) =>
          a.days.compareTo(b.days)
      );
    }else if (sortOption == 3){
      print('Sort by favorites');
      list.removeWhere((element) => element.favorite.toString() == 'false');
      list.sort((a, b) =>
          a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase())
      );
    }else if (sortOption == 4) {
      print('Sort by age (high to low)');
      list.sort((a, b) =>
          a.dateStamp.compareTo(b.dateStamp)
      );
    }
    return list;
  }


  // static String searchTerm;
  // //sorting attempt
  // List _sortedBirthdayListFromSnapshot(DocumentSnapshot snapshot) {
  //   List list = [];
  //   // list.add(snapshot.data().values);
  //   // list.add(snapshot.get("birthdayList")[0]);
  //   List s = snapshot.get('birthdayList'); //array containing json objects
  //   // print('here: ' + s.toString());
  //   // print(s.length);
  //   for (var value in s) {
  //     Birthday bday = Birthday().fromJson(value);
  //     list.add(bday);
  //   }
  //   for (Birthday bday in list) {
  //     if (bday.firstName != searchTerm) {
  //       list.remove(bday);
  //     }
  //   }
  //   print('we are here');
  //   print(list);
  //   return list;
  // }


  // Stream<QuerySnapshot> get birthdaysSuper {
  //   return birthdayProfiles.snapshots();
  // }


  Stream<List> get birthdays {
    return birthdayProfiles.doc(uid).snapshots()
        .map(_birthdayListFromSnapshot);
  }

  // Stream<List> get birthdaySort {
  //   return birthdayProfiles.doc(uid).snapshots()
  //       .map(_sortedBirthdayListFromSnapshot);
  // }

}
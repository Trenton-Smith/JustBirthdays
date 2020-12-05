import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Birthday {

  String firstName;
  String lastName;
  String sortName;
  String birthdate; //for date on card
  String notes;
  int age; //to be replaced with DateTime but calculated the same way for card
  bool twoWeeks;
  bool oneWeek;
  bool twoDays;
  bool oneDay;
  bool favorite;
  DateTime date;
  Timestamp dateStamp;
  int days;

  Birthday({
    this.firstName, this.lastName, this.sortName, this.birthdate, this.notes, this.age,
    this.twoWeeks, this.oneWeek, this.twoDays, this.oneDay, this.favorite,
    this.date, this.dateStamp, this.days,
  });

  Birthday copyBirthday(Birthday bday) {
    Birthday bd = new Birthday();
    bd.firstName = bday.firstName;
    bd.lastName = bday.lastName;
    bd.sortName = bday.sortName;
    bd.notes = bday.notes;
    bd.age = bday.age;
    bd.birthdate = bday.birthdate;
    bd.twoWeeks = bday.twoWeeks;
    bd.twoDays = bday.twoDays;
    bd.oneDay = bday.oneDay;
    bd.oneWeek = bday.oneWeek;
    bd.favorite = bday.favorite;
    bd.date = bday.date;
    bd.dateStamp = bday.dateStamp;
    bd.days = bday.days;
    return bd;
  }

  fromJson(Map<String, dynamic> json) {
    return Birthday(
      firstName : json['firstName'] ?? '',
      lastName : json['lastName'] ?? '',
      sortName: json['sortName'] ?? '',
      birthdate : json['birthdate'] ?? '',
      notes : json['notes'] ?? '',
      age : json['age'] ?? '',
      twoWeeks : json['twoWeeks'] ?? '',
      oneWeek : json['oneWeek'] ?? '',
      twoDays : json['twoDays'] ?? '',
      oneDay : json['oneDay'] ?? '',
      favorite : json['favorite'] ?? '',
      // date : json['date'] ?? '',
      dateStamp: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'firstName': firstName,
      'lastName': lastName,
      'sortName': sortName,
      'birthdate': birthdate,
      'notes': notes,
      'age': age,
      'twoWeeks': twoWeeks,
      'oneWeek': oneWeek,
      'twoDays': twoDays,
      'oneDay': oneDay,
      'favorite': favorite,
      'date': date,
    };

  @override
  String toString() {
    // TODO: implement toString
    print(this.firstName);
    print(this.lastName);
    print(this.birthdate);
    // print(this.age);
  }

  int daysCalc(Timestamp time) {
    // var age;
    // if (time.toDate().month < DateTime.now().month) {
    //   age = DateTime.now().year - time.toDate().year + 1;
    // } else if (time.toDate().month == DateTime.now().month && time.toDate().day <= DateTime.now().day) {
    //   age = DateTime.now().year - time.toDate().year + 1;
    // } else {
    //   age = DateTime.now().year - time.toDate().year;
    // }

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
    if (calc == 365) {
      return 0;
    }
    return calc;
  }


}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_birthdays/models/birthday.dart';
import 'package:just_birthdays/screens/home/bdayCard.dart';
import 'package:just_birthdays/screens/home/home.dart';
import 'package:just_birthdays/services/database.dart';
import 'package:provider/provider.dart';
import 'package:just_birthdays/screens/home/createBirthday.dart';

import 'loading.dart';


class Birthday_List extends StatefulWidget {
  @override
  _BirthdayProfileState createState() => _BirthdayProfileState();
}

class _BirthdayProfileState extends State<Birthday_List> {
  List<Birthday> birthdayList = Home.birthdayList;

  @override
  Widget build(BuildContext context) {
    final birthdays = Provider.of<List>(context);

    // if(Birthday_List.load == true){
    //   Future.delayed(const Duration(milliseconds: 400), () {
    //     Birthday_List.load = false;
    //     return Loading();
    //   });
    // }

    if (birthdays != null && Home.anon == false) {
      //   // for (int i = 0; i < birthdays.length; i++) {
      //   //   birthdayList.add(birthdays[i]);
      //   // }
      //   // return ListView.builder(
      //   //   itemCount: birthdayList.length,
      //   //   itemBuilder: (context, index) {
      //   //     return BdayCard(bday: birthdayList[index]);
      //   //   },
      //   // );
      return ListView.builder(
        itemCount: birthdays.length,
        itemBuilder: (context, index) {
          return BdayCard(bday: birthdays[index]);
        },
      );
    } else {
      return ListView.builder(
        itemCount: birthdayList.length,
        itemBuilder: (context, index) {
          return BdayCard(bday: birthdayList[index]);
        },
      );
    }
  }
}




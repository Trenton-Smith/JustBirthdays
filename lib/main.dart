import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_birthdays/models/birthday.dart';
import 'package:just_birthdays/screens/home/home.dart';
import 'package:just_birthdays/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:just_birthdays/services/auth.dart';
import 'package:just_birthdays/services/database.dart';
import 'package:provider/provider.dart';
import 'package:just_birthdays/models/superUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<SuperUser>.value(
            value: AuthService().user,
          ),
          // StreamProvider<QuerySnapshot>.value(
          //   value: DatabaseService().birthdaysSuper,
          // ),
        ],
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
    // return StreamProvider<SuperUser>.value(
    //   value: AuthService().user,
    //   child: MaterialApp(
    //     home: Wrapper(),
    //   ),
    // );
  }
}

// class AppBuilder extends StatefulWidget {
//   final Function(BuildContext) builder;
//
//   const AppBuilder(
//       {Key key, this.builder})
//       : super(key: key);
//
//   @override
//   AppBuilderState createState() => new AppBuilderState();
//
//   static AppBuilderState of(BuildContext context) {
//     return context.ancestorStateOfType(const TypeMatcher<AppBuilderState>());
//   }
// }
//
// class AppBuilderState extends State<AppBuilder> {
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.builder(context);
//   }
//
//   void rebuild() {
//     setState(() {});
//   }
// }
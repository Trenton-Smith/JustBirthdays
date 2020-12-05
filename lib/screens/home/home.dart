import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_birthdays/models/birthday.dart';
import 'package:just_birthdays/models/superUser.dart';
import 'package:just_birthdays/screens/home/bdayCard.dart';
import 'package:just_birthdays/screens/home/createBirthday.dart';
import 'package:just_birthdays/services/auth.dart';
import 'package:just_birthdays/services/database.dart';
import 'package:just_birthdays/shared/birthday_list.dart';
import 'package:just_birthdays/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {

  static bool anon = false;
  static List<Birthday> birthdayList = [];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // bool loading = false;
  // void loadScreen () {
  //   setState(() {
  //     loading = true;
  //   });
  //   Future.delayed(Duration(milliseconds: 400), () {setState(() {
  //     loading = false;
  //   });});
  // }
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List> db () {
    final User user = auth.currentUser;
    // if (user != null && DatabaseService.searchTerm != ''){
    //   final uid = user.uid;
    //   print(DatabaseService.searchTerm);
    //   return DatabaseService(uid: uid).birthdaySort;
    // } else
    if (user != null) {
      final uid = user.uid;
      return DatabaseService(uid: uid).birthdays;
    } else {
      print('no user logged in');
      return DatabaseService().birthdays;
    }
    // print(uid);
  }

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search,);
  Widget _appBarTitle = new Text( 'JustBirthdays!' , style: TextStyle(fontSize: 24), );

  String dropdownValue = 'A-Z';
  final _formKey = GlobalKey<FormState>();
  Color _themeColor = Colors.lightBlue;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;
  Color _titleColor = Colors.white;
  Color _sortColor = Colors.black;
  List<Color> _colorSelection = [];
  Color _previousThemeColor;
  Color _previousBackgroundColor;
  Color _previousTextColor;
  Color _previousTitleColor;
  Color _previousSortColor;


  @override
  Widget build(BuildContext context) {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = '';
          DatabaseService.searchTerm = '';
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          DatabaseService.searchTerm = _searchText;
        });
      }
    });


    return StreamProvider<List>.value(
      value: db(),
      child:
        Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title: this._appBarTitle,
          backgroundColor: _themeColor,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: this._searchIcon,
              textColor: _textColor,
              padding: EdgeInsets.zero,
              label: Text(''),
              onPressed: () {
                setState(() {
                  if (this._searchIcon.icon == Icons.search) {
                    this._searchIcon = new Icon(Icons.close);
                    this._appBarTitle = new TextField(
                      controller: _filter,
                      style: TextStyle(fontSize: 18, color: _textColor),
                      decoration: new InputDecoration(
                        hintStyle: TextStyle(color: _textColor),
                          prefixIcon: new Icon(Icons.search, color: _textColor,),
                          hintText: 'Search...'
                      ),
                    );
                  } else {
                    this._searchIcon = new Icon(Icons.search);
                    this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24, color: _titleColor), );
                    // filteredNames = names;
                    _filter.clear();
                    // _filter.text = '';
                  }
                });
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 2.0, 10.0, 0.0),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.sort,), // look into _sortIconColor -> also clear databse and repopulate!!!
                iconSize: 24,
                dropdownColor: _backgroundColor,
                // elevation: 16,
                style: TextStyle(color: _sortColor, fontSize: 18,),
                underline: Container(
                  height: 2,
                  color: _sortColor,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    if (dropdownValue == 'A-Z'){
                      DatabaseService.sortOption = 1;
                    } else if (dropdownValue == 'Date'){
                      DatabaseService.sortOption = 2;
                    } else if (dropdownValue == 'Favs'){
                      DatabaseService.sortOption = 3;
                    } else if (dropdownValue == 'Age'){
                      DatabaseService.sortOption = 4;
                    }
                  });
                },
                items: <String>['A-Z', 'Date', 'Favs', 'Age']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            // FlatButton.icon(
            //   padding: EdgeInsets.zero,
            //   icon: Icon(Icons.sort),
            //   label: Text(''),
            //   onPressed: () async {
            //     setState((){
            //       DatabaseService.sortOption = 2;
            //     });
            //   },
            // ),
          ],
        ),
        body: Birthday_List(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, __, ___) {
                  return new Scaffold(
                    backgroundColor: Colors.black45,
                    body: new Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      color: _backgroundColor,
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
                          Text('Add a new birthday!', textAlign: TextAlign.center, style: TextStyle(fontSize: 28),),
                          CreateBirthday(),
                        ]
                      ),
                    ),
                  );
                }
              )
            );
          },
          child: Icon(Icons.add),
          backgroundColor: _themeColor,
        ),
        bottomNavigationBar: BottomAppBar(
          color: _themeColor,
          shape: CircularNotchedRectangle(),
          notchMargin: 5.0,
          child: Row(
            children: [
              Container(
                height: 50.0,
                alignment: AlignmentDirectional.centerStart,
                child: FlatButton.icon(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    icon: Icon(Icons.person, color: _textColor,),
                    label: Text('logout',style: TextStyle(color: _textColor),),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                ),
              ),
              Expanded(
                child: Container(
                  height: 50.0,
                  alignment: AlignmentDirectional.centerEnd,
                  child: FlatButton.icon(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    icon: Icon(Icons.settings, color: _textColor,),
                    label: Text(''),
                    onPressed: () async {
                      Navigator.of(context).push(
                          PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, __, ___) {
                                return new Scaffold(
                                  backgroundColor: Colors.black45,
                                  body: new Container(
                                    margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
                                    color: _backgroundColor,
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
                                          Text('Settings', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, color: _textColor),),
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 5.0),
                                              DropdownButtonFormField(
                                                style: TextStyle(color: _textColor),
                                                dropdownColor: _backgroundColor,
                                                hint: Text('Choose a color theme!', style: TextStyle(color: _textColor, fontSize: 22.0),),
                                                items: [
                                                  DropdownMenuItem(child: Text('Blue', style: TextStyle(color: _textColor, fontSize: 22.0),), value: Colors.lightBlue,),
                                                  DropdownMenuItem(child: Text('Dark Blue', style: TextStyle(color: _textColor, fontSize: 22.0),), value: Colors.blue[800],),
                                                  DropdownMenuItem(child: Text('Red', style: TextStyle(color: _textColor, fontSize: 22.0),), value: Colors.red,),
                                                  DropdownMenuItem(child: Text('Orange', style: TextStyle(color: _textColor, fontSize: 22.0),), value: Colors.deepOrange,),
                                                  DropdownMenuItem(child: Text('Yellow', style: TextStyle(color: _textColor, fontSize: 22.0),), value: Colors.yellow[400],),
                                                  DropdownMenuItem(child: Text('Green', style: TextStyle(color: _textColor, fontSize: 22.0),), value: Colors.green,),
                                                  DropdownMenuItem(child: Text('Pink', style: TextStyle(color: _textColor, fontSize: 22.0),), value: Colors.pinkAccent,),
                                                  DropdownMenuItem(child: Text('Purple', style: TextStyle(color: _textColor, fontSize: 22.0),), value: Colors.deepPurple,),
                                                  DropdownMenuItem(child: Text('Dark Mode', style: TextStyle(color: _textColor, fontSize: 22.0),), value: Colors.black87),
                                                ],
                                                onChanged: (Color value) {
                                                  setState(() {
                                                    _previousThemeColor = _themeColor;
                                                    _previousBackgroundColor = _backgroundColor;
                                                    _previousTitleColor = _titleColor;
                                                    _previousTextColor = _textColor;
                                                    _previousSortColor = _sortColor;

                                                    _colorSelection.add(_previousThemeColor); // [0]
                                                    _colorSelection.add(_previousBackgroundColor); // [1]
                                                    _colorSelection.add(_previousTitleColor); // [2]
                                                    _colorSelection.add(_previousTextColor); // [3]
                                                    _colorSelection.add(_previousSortColor); // [4]

                                                    _themeColor = value;
                                                    if (_themeColor == Colors.lightBlue){
                                                      _titleColor = Colors.white;
                                                      this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24.0, color: _titleColor),);
                                                      _textColor = Colors.black;
                                                      _sortColor = Colors.black;
                                                      _backgroundColor = Colors.white;
                                                    } else if (_themeColor == Colors.blue[800]){
                                                      _titleColor = Colors.white;
                                                      this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24.0, color: _titleColor),);
                                                      _textColor = Colors.black;
                                                      _sortColor = Colors.black;
                                                      _backgroundColor = Colors.white;
                                                    } else if (_themeColor == Colors.red){
                                                      _titleColor = Colors.white;
                                                      this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24.0, color: _titleColor),);
                                                      _textColor = Colors.black;
                                                      _sortColor = Colors.black;
                                                      _backgroundColor = Colors.white;
                                                    } else if (_themeColor == Colors.deepOrange){
                                                      _titleColor = Colors.white;
                                                      this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24.0, color: _titleColor),);
                                                      _textColor = Colors.black;
                                                      _sortColor = Colors.black;
                                                      _backgroundColor = Colors.white;
                                                    } else if (_themeColor == Colors.yellow[400]){
                                                      _titleColor = Colors.black;
                                                      this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24.0, color: _titleColor),);
                                                      _textColor = Colors.black;
                                                      _sortColor = Colors.black;
                                                      _backgroundColor = Colors.white;
                                                    } else if (_themeColor == Colors.green){
                                                      _titleColor = Colors.white;
                                                      this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24.0, color: _titleColor),);
                                                      _textColor = Colors.black;
                                                      _sortColor = Colors.black;
                                                      _backgroundColor = Colors.white;
                                                    } else if (_themeColor == Colors.pinkAccent){
                                                      _titleColor = Colors.white;
                                                      this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24.0, color: _titleColor),);
                                                      _textColor = Colors.black;
                                                      _sortColor = Colors.black;
                                                      _backgroundColor = Colors.white;
                                                    }else if (_themeColor == Colors.deepPurple){
                                                      _titleColor = Colors.white;
                                                      this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24.0, color: _titleColor),);
                                                      _textColor = Colors.black;
                                                      _sortColor = Colors.black;
                                                      _backgroundColor = Colors.white;
                                                    }else if (_themeColor == Colors.black87){
                                                      _titleColor = Colors.amber;
                                                      this._appBarTitle = new Text('JustBirthdays!', style: TextStyle(fontSize: 24.0, color: _titleColor),);
                                                      _textColor = Colors.grey[600];
                                                      _sortColor = Colors.amber;
                                                      _backgroundColor = Colors.grey[850];
                                                    }
                                                  });
                                                }
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
                                                      setState(() {
                                                        if ( _colorSelection.isNotEmpty ) {
                                                          _themeColor =
                                                          _colorSelection[0];
                                                          _backgroundColor =
                                                          _colorSelection[1];
                                                          _titleColor =
                                                          _colorSelection[2];
                                                          _textColor =
                                                          _colorSelection[3];
                                                          _sortColor =
                                                          _colorSelection[4];
                                                          _colorSelection
                                                              .clear();
                                                        }
                                                      });
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
                                                        setState(() {
                                                          _colorSelection.clear();
                                                          //settings for color here
                                                          Navigator.pop(context);
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                      )
                                        ]
                                    ),
                                  ),
                                );
                              }
                          )
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
      ),
    );
        // )
    // );
  }
}

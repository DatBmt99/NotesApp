import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notes/models/category_model.dart';
import 'package:notes/models/global.dart';
import 'package:notes/models/priority_model.dart';
import 'package:notes/models/status_model.dart';
import 'package:notes/screens/add_category/add_category.dart';
import 'package:notes/screens/add_note/add_note.dart';
import 'package:notes/screens/add_prioty/add_prioty.dart';
import 'package:notes/screens/add_status/add_status.dart';
import 'package:notes/screens/menu/draw_menu.dart';
import 'package:notes/screens/menu/notify.dart';
import 'package:notes/services/data.dart';
import 'package:notes/themes/colors.dart';
import 'components/list_view.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var _scaffoldKey = new GlobalKey<ScaffoldState>();

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0.0,
        title: Text(
          "Notes Manager",
          textAlign: TextAlign.right,
          style: TextStyle(color: textColor),
        ),
        leading: FlatButton(
            onPressed: () {
              print("click menu");
              _scaffoldKey.currentState.openDrawer();
            },
            child: Icon(Icons.menu)),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notify()),
                );
              },
              child: Icon(Icons.notifications),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: OptionMenu(),
      ),
      key: _scaffoldKey,
      body: SafeArea(
        child: FutureBuilder(
          future: data.fetchNotes(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return CustomListView(notes: snapshot.data);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        // backgroundColor: Colors.redAccent,
        children: [
          SpeedDialChild(
            child: Icon(Icons.event),
            label: "Add Note",
            backgroundColor: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNoteScreen()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.create_new_folder),
            label: "Add Category",
            backgroundColor: Colors.red,
            onTap: () {
              // newCategory = Category('Not Specified');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategory()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.create_sharp),
            label: "Add Prioty",
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPrioty()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.done_all),
            label: "Add Status",
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStatus()),
              );
            },
          ),
        ],
      ),
    );
  }
}

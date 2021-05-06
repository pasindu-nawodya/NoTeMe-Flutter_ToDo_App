import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoUi extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<TodoUi> {
  List<String> todos;
  String input;
  int check;

  createToDos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todos.add(input);
      check = todos.length;
      input = null;
    });
    await prefs.setStringList('todos', todos);
  }

  deleteToDos(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todos.removeAt(index);
      check = todos.length;
    });
    await prefs.setStringList('todos', todos);
  }

  _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> td = (prefs.getStringList('todos') ?? []);
    setState(() {
      todos = td;
      check = td.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Note Everything you Want",
          ),
          backgroundColor: Colors.blueAccent[700],
          backwardsCompatibility: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Add a Note"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    content: TextField(
                      onChanged: (String value) {
                        setState(() {
                          input = value;
                        });
                      },
                    ),
                    actions: <Widget>[
                      // ignore: deprecated_member_use
                      FlatButton(
                          onPressed: () {
                            // ignore: unnecessary_statements
                            input == null ? '' : createToDos();
                            Navigator.of(context).pop();
                          },
                          child: Text("Add"))
                    ],
                  );
                });
          },
          backgroundColor: Colors.blueAccent[700],
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: check == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/nodata.png',
                  ),
                ],
              )
            : ListView.builder(
                itemCount: todos != null ? todos.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(todos[index]),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.all(8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(todos[index]),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteToDos(index);
                          },
                        ),
                      ),
                    ),
                    // ignore: non_constant_identifier_names
                    onDismissed: ((DismissDirection) async =>
                        deleteToDos(index)),
                  );
                },
              ),
      ),
    );
  }
}

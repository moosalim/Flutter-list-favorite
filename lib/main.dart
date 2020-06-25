import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';


void main() {
  runApp(new MaterialApp(home: HomePage()));
}
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}


List data;
List<User> userlist = List();
List<User> usersavedlist = List();
int index;

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UserList Flutter',
      home: Scaffold(
        // drawer: new Drawer(
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(8,8,8,8),
        //     child: Column(
        //       children: <Widget>[
        //         Container(
        //           child: listView(),
        //         ),
        //         Container(
        //           child: Text("Click Mee 2"),
        //         ),
        //         Container(
        //           child: Text("Click Meee3"),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        appBar: AppBar(
          title: Text('UserList Flutter'),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: listView(),
      ),
    );
  }


  Future<String> fetchData() async {
    final url =
        'https://extendsclass.com/api/json-storage/bin/fcdedae';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('succesfull parse');

      this.setState(() {
        data = json.decode(response.body);
        data.forEach((element) => userlist.add(new User.fromJson(element)));
      });
    }

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  listView() {
    return ListView.builder(
      itemCount: userlist == null ? 0 : userlist.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[_buildRow(index, userlist), const Divider()],
        );
      },
    );
  }

  Widget _buildRow(index, userlist) {
    final bool alreadySaved = usersavedlist.contains(userlist[index]);

    return ListTile(
      title: Text(
        userlist[index].name
        //  + " " + userlist[index].surname
         ,
      ),
      trailing: Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.yellow : Colors.blue,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            usersavedlist.remove(userlist[index]);
          } else {
            usersavedlist.add(userlist[index]);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = usersavedlist.map(
            (User pair) {
              return ListTile(
                title: Text(
                  pair.name,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

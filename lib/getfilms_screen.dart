//Current screen to get Films

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sampleApp/modifyFilmScreen.dart';

class HomePage extends StatefulWidget {
  final String text;
  String token;
  HomePage({Key key, @required this.text}) : super(key: key);
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://192.168.1.187:8080/api/v1/films"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      data = json.decode(response.body);
    });
    print(data[1]["name"]);

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Listviews"),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new RaisedButton(
            child: new Text(data[index]["name"]),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => modifyScreen(
                            text: data[index]["name"],
                            token: widget.text,
                          )));
            },
          );
        },
      ),
    );
  }
}

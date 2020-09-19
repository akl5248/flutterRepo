import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String name, String authToken, rating) async {
  final http.Response response = await http.post(
    'http://192.168.1.187:8080/api/v1/films',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + authToken,
    },
    body: jsonEncode(<String, String>{
      'name': name + ", " + rating,
    }),
  );

  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

void deleteAlbum(String name) async {
  final client = http.Client();
  try {
    final response = await client.send(http.Request(
        "DELETE", Uri.parse("http://192.168.1.187:8080/api/v1/films/delete"))
      ..headers["Content-Type"] = "application/json"
      ..body = jsonEncode(<String, String>{
        'name': name,
      }));
  } finally {
    client.close();
  }
}

class Album {
  final String name;

  Album({this.name});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
    );
  }
}

class modifyScreen extends StatefulWidget {
  final String text;
  final String token;
  modifyScreen({Key key, @required this.text, @required this.token})
      : super(key: key);

  @override
  _modifyScreenState createState() {
    return _modifyScreenState();
  }
}

class _modifyScreenState extends State<modifyScreen> {
  String _name;
  String _rating;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<Album> _futureAlbum;

  Widget _buildName() {
    return TextFormField(
        readOnly: true, decoration: InputDecoration(labelText: widget.text));
  }

  Widget _builRating() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Rating'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int rating = int.tryParse(value);

        if (rating == null || rating < 1 || rating > 5) {
          return 'Film Rating Range 1-5';
        }

        return null;
      },
      onSaved: (String value) {
        _rating = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Demo")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _builRating(),
              SizedBox(height: 100),
              RaisedButton(
                child: Text('Change Rating'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    var fullFilmText = widget.text;
                    fullFilmText.split(",");
                    deleteAlbum(widget.text);
                    var stringToSplit = widget.text;
                    List<String> splitStrings = stringToSplit.split(',');
                    var splitString = splitStrings.first;
                    _formKey.currentState.save();
                    _futureAlbum =
                        createAlbum(splitString, widget.token, _rating);
                    Navigator.pushNamed(context, '/fourth');

                    return;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sampleApp/getfilms_screen.dart';

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

class Album {
  final String name;

  Album({this.name});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
    );
  }
}

class postScreen extends StatefulWidget {
  final String text;
  String _rating;
  postScreen({Key key, @required this.text}) : super(key: key);

  @override
  _postScreenState createState() {
    return _postScreenState();
  }
}

class _postScreenState extends State<postScreen> {
  String _name;
  String _rating;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<Album> _futureAlbum;

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Film Name'),
      // maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
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
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _futureAlbum = createAlbum(_name, widget.text, _rating);
                    //Navigator.pushNamed(context, '/fourth');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  text: widget.text,
                                )));
                    return;
                  }

                  print(_name);
                  print(_rating);

                  //Send to API
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

String validateRating(String value) {
  if (!(value == null)) {
    var intValue = int.parse(value);
    if (!(intValue > 5) && !(intValue < 1)) {
      return "Password should contains more then 5 character";
    }
    return null;
  }
}

void _showToast(BuildContext context) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: const Text('Added to favorite'),
      action: SnackBarAction(
          label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

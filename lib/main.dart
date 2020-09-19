import 'package:flutter/material.dart';
// import 'package:sampleApp/login.dart';
import 'package:sampleApp/getfilms_screen.dart';
import 'package:sampleApp/login_page.dart';
import 'package:sampleApp/httpFormScreen.dart';
import 'package:sampleApp/modifyFilmScreen.dart';

void main() {
  final appTitle = 'JavaSampleApproach HTTP-JSON';

  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => FirstScreen(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/second': (context) => LoginPage(),

      '/third': (context) => postScreen(text: accessToken),

      '/fourth': (context) => HomePage(text: accessToken),

      '/fifth': (context) => modifyScreen(),
    },
  ));
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen using a named route.
            Navigator.pushNamed(context, '/second');
          },
        ),
      ),
    );
  }
}

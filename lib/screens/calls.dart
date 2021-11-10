// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blather_app/styles/constants.dart';
import 'package:flutter/material.dart';

class Calls extends StatefulWidget {
  Calls({Key? key}) : super(key: key);

  @override
  _CallsState createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "Call Logs Screen",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ]),
    );
  }
}

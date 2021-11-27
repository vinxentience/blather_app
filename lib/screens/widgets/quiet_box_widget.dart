// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blather_app/screens/search.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:flutter/material.dart';

class QuiteBox extends StatelessWidget {
  const QuiteBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Container(
          color: separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "This is where all the contacts are listed",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Search for your friends and famility to start chatting with them.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search())),
                child: Text("Search..."),
              )
            ],
          ),
        ),
      ),
    );
  }
}

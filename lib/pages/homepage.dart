// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:blather_app/pages/signin.dart';
import 'package:blather_app/screens/calls.dart';
import 'package:blather_app/screens/chats.dart';
import 'package:blather_app/screens/friends.dart';
import 'package:blather_app/screens/profile.dart';
import 'package:blather_app/service/auth_service.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    Container(
      child: ChatListScreen(),
    ),
    Container(
      child: Calls(),
    ),
    Container(
      child: Friends(),
    ),
    Container(
      child: Profile(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: blackColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
            backgroundColor: blackColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: 'Friends',
            backgroundColor: blackColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: blackColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

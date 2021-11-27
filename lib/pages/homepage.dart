// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:blather_app/pages/signin.dart';
import 'package:blather_app/provider/user_provider.dart';
import 'package:blather_app/screens/calls.dart';
import 'package:blather_app/screens/chats.dart';
import 'package:blather_app/screens/friends.dart';
import 'package:blather_app/screens/profile.dart';
import 'package:blather_app/service/auth_service.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late PageController pageController;
  int _page = 0;

  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });

    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 10;

    return Scaffold(
      backgroundColor: blackColor,
      body: PageView(
        children: <Widget>[
          Container(
            child: ChatListScreen(),
          ),
          Center(
            child: Text(
              "Call Logs",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Center(
            child: Text(
              "Contact Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            child: Profile(),
          ),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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
        currentIndex: _page,
        onTap: navigationTapped,
        selectedItemColor: kPrimaryColor,
      ),
    );
  }
}

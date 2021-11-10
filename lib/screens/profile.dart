// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:blather_app/pages/signin.dart';
import 'package:blather_app/screens/edit.dart';
import 'package:blather_app/service/auth_service.dart';
import 'package:blather_app/service/firebase_repository.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () async {
                await _repository.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => Signin()),
                    (route) => false);
              },
              icon: Icon(Icons.logout_outlined),
              tooltip: 'Logout')
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Edit()),
          );
        },
        child: const Icon(Icons.edit),
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.lightBlue, Colors.blueAccent],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  margin: EdgeInsets.only(top: 125, left: 10),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: authClass.getProfilePicture(),
                  ),
                ),
                // Text(
                //   authClass.getName(),
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 20.0,
                //   ),
                // ),
                // IconButton(
                //   onPressed: () async {
                //     await authClass.logout();
                //     Navigator.pushAndRemoveUntil(
                //         context,
                //         MaterialPageRoute(builder: (builder) => Signin()),
                //         (route) => false);
                //   },
                //   icon: Icon(Icons.logout),
                // )
              ],
            ),
            // Text(
            //   authClass.getName(),
            //   style: TextStyle(
            //     color: blackColor,
            //     fontSize: 20.0,
            //   ),
            // ),
            Text(
              authClass.getName(),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)],
                                Colors.white
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: kPrimaryColor,
                            // image: DecorationImage(
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          height: 100,
                          width: 300,
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text("Featured $index"),
                          ),
                        ),
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    SizedBox(
                      child: ListView.builder(
                        itemCount: 3,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ListTile(
                          title: Text("List $index"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// IconButton(
//               onPressed: () async {
//                 await authClass.logout();
//                 Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (builder) => Signin()),
//                     (route) => false);
//               },
//               icon: Icon(Icons.logout))
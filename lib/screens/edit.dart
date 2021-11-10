// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:blather_app/screens/profile.dart';
import 'package:blather_app/service/auth_service.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:flutter/material.dart';

AuthClass authClass = AuthClass();

class Edit extends StatefulWidget {
  Edit({Key? key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save),
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
                      colors: [
                        Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        kPrimaryColorDarker
                      ],
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
                                Colors.white70
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

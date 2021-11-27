// ignore_for_file: prefer_const_constructors

import 'package:blather_app/cache/image_cache.dart';
import 'package:blather_app/customs/custom_tile.dart';
import 'package:blather_app/models/contact_model.dart';
import 'package:blather_app/models/user.dart';
import 'package:blather_app/provider/user_provider.dart';
import 'package:blather_app/screens/chat_main.dart';
import 'package:blather_app/service/firebase_methods.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactView extends StatelessWidget {
  Contact contact;
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  ContactView({required this.contact});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserDetails>(
      future: _firebaseMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserDetails user = snapshot.data as UserDetails;
          return ViewLayout(contact: user);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final UserDetails contact;
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  ViewLayout({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(receiver: contact),
        ),
      ),
      title: Text(
        (contact != null ? contact.name : null) != null
            ? contact.name as String
            : "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: Text(
        "Hello there friend!",
        style: TextStyle(
          color: greyColor,
          fontSize: 14,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto as String,
              radius: 80,
              isRound: true,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: onlineDotColor,
                    border: Border.all(color: blackColor, width: 2)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

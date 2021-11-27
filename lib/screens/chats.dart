// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:blather_app/customs/appbar.dart';
import 'package:blather_app/customs/custom_tile.dart';
import 'package:blather_app/models/contact_model.dart';
import 'package:blather_app/provider/user_provider.dart';
import 'package:blather_app/screens/widgets/contact_view.dart';
import 'package:blather_app/screens/widgets/new_chat.dart';
import 'package:blather_app/screens/widgets/quiet_box_widget.dart';
import 'package:blather_app/screens/widgets/user_circle.dart';
import 'package:blather_app/service/auth_service.dart';
import 'package:blather_app/service/firebase_methods.dart';
import 'package:blather_app/service/firebase_repository.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:blather_app/styles/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu_outlined,
          color: Colors.white,
        ),
        onPressed: () {
          userProvider.refreshUser();
        },
      ),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final FirebaseMethods _chatMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid as String,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data!.docs;
              // if (docList.isEmpty) {
              //   return QuiteBox();
              // }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(
                      docList[index].data() as Map<String, dynamic>);

                  return ContactView(
                    contact: contact,
                  );
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

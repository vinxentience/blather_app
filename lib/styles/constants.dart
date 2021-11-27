// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, constant_identifier_names

import 'package:flutter/material.dart';

const String MESSAGES_COLLECTION = "messages";
const String TIMESTAMP_FIELD = "timestamp";
const String USERS_COLLECTION = "users";
const String EMAIL_FIELD = "email";
const String MESSAGE_TYPE_IMAGE = "image";
const String MESSAGE_TYPE_GIF = "gif";
const CONTACTS_COLLECTION = "contacts";
const String CALL_COLLECTION = "call";

const kPrimaryColor = Color(0xFF5D66C3);
const kPrimaryColorDarker = Color(0xFF001220);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const blackColor = Color(0xff19191b);
const greyColor = Color(0xff8f8f8f);
const userCircleBackground = Color(0xff2b2b33);
const onlineDotColor = Color(0xff46dc64);
const lightBlueColor = Color(0xff0077d7);
const separatorColor = Color(0xff272c35);
const gradientColorStart = Color(0xff00b6f3);
const gradientColorEnd = Color(0xff0184dc);
const senderColor = Color(0xff2b343b);
const receiverColor = Color(0xff1e2225);

const headingStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  height: 1.5,
);

final Gradient fabGradient = LinearGradient(
    colors: [gradientColorStart, gradientColorEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);

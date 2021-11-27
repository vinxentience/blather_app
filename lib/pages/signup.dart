// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, avoid_single_cascade_in_expression_statements

import 'dart:io';

import 'package:blather_app/models/content_model.dart';
import 'package:blather_app/pages/homepage.dart';
import 'package:blather_app/pages/signin.dart';
import 'package:blather_app/service/firebase_repository.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formGlobalKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  final FirebaseRepository _repository = FirebaseRepository();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var previewImage;
  bool isLoginPressed = false;
  String _selectedItem = "";

  void performSignup(
      String fname, String lname, String email, String password) {
    String displayName = fname + " " + lname;
    _repository.signUpUsingEmail(email, password, displayName).then(
        (value) => {createAccount(value.uid, fname, lname, email, password)});
  }

  void createAccount(
      String uid, String fname, String lname, String email, String password) {
    _repository.getCurrentUser().then((user) {
      _repository.uploadProfilePicture(previewImage, user).then((value) {
        _repository.addUserUsingEmaill(uid, fname, lname, email, value!);
        showSuccess(context);
      });
    });
  }

  void showSuccess(BuildContext context) {
    Flushbar(
      shouldIconPulse: false,
      icon: Icon(
        Icons.check_circle_outlined,
        size: 20,
      ),
      message: 'Account successfully created.',
      duration: Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.BOTTOM,
      borderRadius: 15,
      backgroundColor: Colors.green[400],
    )..show(context).then((r) => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Signin();
        })));
  }

  void _onPressedSourcePicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera, color: Colors.black),
                  title: Text("Camera"),
                  onTap: () => _selectedSource('Camera'),
                ),
                ListTile(
                  leading: Icon(Icons.image, color: Colors.black),
                  title: Text("Gallery"),
                  onTap: () => _selectedSource('Gallery'),
                ),
              ],
            ),
          );
        });
  }

  void _selectedSource(String source) async {
    Navigator.pop(context);
    setState(() {
      _selectedItem = source;
    });

    if (_selectedItem == "Gallery") {
      final image =
          await ImagePicker().pickImage(source: ImageSource.gallery) as XFile;
      setState(() {
        previewImage = File(image.path);
      });
    } else {
      final image =
          await ImagePicker().pickImage(source: ImageSource.camera) as XFile;
      setState(() {
        previewImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: SizedBox(
          width: double.infinity,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Welcome to Blather',
                      style: headingStyle,
                    ),
                    Text(
                      'Sign up using your email and password to join our community!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Stack(
                      children: <Widget>[
                        previewImage != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: Image.file(
                                  previewImage,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(20),
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                                child: Image.asset(
                                  'assets/images/default_profile.png',
                                ),
                              ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              _onPressedSourcePicker();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: kPrimaryLightColor,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: TextFormField(
                              controller: _firstnameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Input is empty";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: kPrimaryColor,
                                ),
                                hintText: "First Name",
                                hintStyle: TextStyle(
                                  color: kPrimaryColorDarker,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: kPrimaryLightColor,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: TextFormField(
                              controller: _lastnameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Input is empty";
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Last Name",
                                hintStyle: TextStyle(
                                  color: kPrimaryColorDarker,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Input is empty";
                          } else if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return null;
                          } else {
                            return "Email is not valid";
                          }
                        },
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: kPrimaryColor,
                          ),
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: kPrimaryColorDarker,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Input is empty";
                          } else if (value.length < 8) {
                            return "Password is too short. Must be at least 8 characters.";
                          } else {
                            return null;
                          }
                        },
                        obscureText: _isObscure,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: kPrimaryColor,
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: kPrimaryColorDarker,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (_passwordController.text != value) {
                            return "Password does not match.";
                          } else if (value!.isEmpty) {
                            return "Input is empty";
                          } else {
                            return null;
                          }
                        },
                        obscureText: _isObscureConfirm,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscureConfirm
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: kPrimaryColor,
                            onPressed: () {
                              setState(() {
                                _isObscureConfirm = !_isObscureConfirm;
                              });
                            },
                          ),
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(
                            color: kPrimaryColorDarker,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: ElevatedButton(
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          performSignup(
                              _firstnameController.text,
                              _lastnameController.text,
                              _emailController.text,
                              _passwordController.text);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

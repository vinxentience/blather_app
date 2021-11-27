import 'dart:io';

import 'package:blather_app/models/message_model.dart';
import 'package:blather_app/models/user.dart';
import 'package:blather_app/provider/image_upload_provider.dart';
import 'package:blather_app/service/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<User> signIn() => _firebaseMethods.signIn();

  Future<User> signUpUsingEmail(
          String email, String password, String displayName) =>
      _firebaseMethods.signUpUsingEmail(email, password, displayName);

  Future<User> signInUsingEmail(String email, String password) =>
      _firebaseMethods.signInUsingEmail(email, password);

  Future<void> addUserUsingEmaill(String uid, String fname, String lname,
          String email, String profilePhoto) =>
      _firebaseMethods.addUserUsingEmaill(
          uid, fname, lname, email, profilePhoto);

  Future<bool> authenticateUser(User user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(User user) => _firebaseMethods.addDataToDb(user);

  ///responsible for signing out
  Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<UserDetails>> fetchAllUsers(User user) =>
      _firebaseMethods.fetchAllUsers(user);

  Future<void> addMessageToDb(
          MessageModel message, UserDetails sender, UserDetails receiver) =>
      _firebaseMethods.addMessageToDb(message, sender, receiver);

  void uploadImage(
          {required File image,
          required String receiverId,
          required String senderId,
          required ImageUploadProvider imageUploadProvider}) =>
      _firebaseMethods.uploadImage(
          image, receiverId, senderId, imageUploadProvider);

  void uploadGif(
          {required String gif,
          required String receiverId,
          required String senderId}) =>
      _firebaseMethods.setGifMessage(gif, receiverId, senderId);

  Future<String?> uploadProfilePicture(File image, User user) =>
      _firebaseMethods.uploadProfilePicture(image, user);
}

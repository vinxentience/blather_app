// ignore_for_file: prefer_final_fields, await_only_futures

import 'dart:async';
import 'dart:io';

import 'package:blather_app/models/contact_model.dart';
import 'package:blather_app/models/message_model.dart';
import 'package:blather_app/models/user.dart';
import 'package:blather_app/provider/image_upload_provider.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:blather_app/styles/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseMethods {
  //Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Reference _storageReference;
  //Firestore
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _messageCollection =
      _firestore.collection(MESSAGES_COLLECTION);
  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);
  //user class
  UserDetails user = UserDetails();

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser!;
    return currentUser;
  }

  Future<UserDetails> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();

    return UserDetails.fromMap(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<UserDetails> getUserDetailsById(id) async {
    DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
    return UserDetails.fromMap(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<User> signIn() async {
    GoogleSignInAccount? _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    User user = (await _auth.signInWithCredential(credential)).user!;
    return user;
  }

  Future<User> signUpUsingEmail(
      String email, String password, String displayName) async {
    UserCredential authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user;
    user = authResult.user!;
    user.updateDisplayName(displayName);
    return user;
  }

  Future<User> signInUsingEmail(String email, String password) async {
    UserCredential authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());
    User user = authResult.user!;
    return user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.isEmpty ? true : false;
  }

  Future<void> addUserUsingEmaill(String uid, String fname, String lname,
      String email, String profilePhoto) async {
    String username = Utils.getUsername(email);
    String name = fname + " " + lname;
    var user = UserDetails(
        uid: uid,
        email: email,
        name: name,
        username: username,
        profilePhoto: profilePhoto);

    firestore
        .collection(USERS_COLLECTION)
        .doc(uid)
        .set(user.toMap(user) as Map<String, dynamic>);
  }

  Future<void> addDataToDb(User currentUser) async {
    String username = Utils.getUsername(currentUser.email as String);

    var user = UserDetails(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoURL,
        username: username);

    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(user.toMap(user) as Map<String, dynamic>);
  }

  Future<void> signOut() async {
    for (UserInfo profile in _auth.currentUser!.providerData) {
      if (profile.providerId == "password") {
        await FirebaseAuth.instance.signOut();
      } else if (profile.providerId == "google.com") {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
      }
    }
    return await _auth.signOut();
  }

  Future<List<UserDetails>> fetchAllUsers(User currentUser) async {
    List<UserDetails> userList = <UserDetails>[];

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(UserDetails.fromMap(
            querySnapshot.docs[i].data() as Map<String, dynamic>));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(
      MessageModel message, UserDetails sender, UserDetails receiver) async {
    var map = message.toMap();
    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId as String)
        .add(map as Map<String, dynamic>);
    addToContacts(
        senderId: message.senderId as String,
        receiverId: message.receiverId as String);
    await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId as String)
        .add(map);
  }

  DocumentReference getContactsDocument(
          {required String of, required String forContact}) =>
      _userCollection.doc(of).collection(CONTACTS_COLLECTION).doc(forContact);

  addToContacts({required String senderId, required String receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSendersContact(senderId, receiverId, currentTime);
    await addToReceiversContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSendersContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();
    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiversContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();
    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  Future<String?> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      UploadTask _storageUploadTask = _storageReference.putFile(image);
      var url = await (await _storageUploadTask).ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadProfilePicture(File image, User user) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('user')
          .child(user.uid)
          .child('profile_picture');
      UploadTask _storageUploadTask = _storageReference.putFile(image);
      var url = await (await _storageUploadTask).ref.getDownloadURL();
      user.updatePhotoURL(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();
    String? url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    setImageMessage(url!, receiverId, senderId);
  }

  void setImageMessage(String url, String receiverId, String senderId) async {
    MessageModel _message;
    _message = MessageModel.imageMessage(
      message: "IMAGE",
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: 'image',
    );

    var map = _message.toImageMap();
    await _messageCollection
        .doc(_message.senderId)
        .collection(_message.receiverId as String)
        .add(map as Map<String, dynamic>);

    await _messageCollection
        .doc(_message.receiverId)
        .collection(_message.senderId as String)
        .add(map);
  }

  void setGifMessage(String url, String receiverId, String senderId) async {
    MessageModel _message;
    _message = MessageModel.imageMessage(
      message: "GIF",
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: 'gif',
    );

    var map = _message.toImageMap();
    await _messageCollection
        .doc(_message.senderId)
        .collection(_message.receiverId as String)
        .add(map as Map<String, dynamic>);

    await _messageCollection
        .doc(_message.receiverId)
        .collection(_message.senderId as String)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({required String userId}) =>
      _userCollection.doc(userId).collection(CONTACTS_COLLECTION).snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween(
          {required String senderId, required String receiverId}) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}

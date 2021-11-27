// ignore_for_file: prefer_const_constructors, unnecessary_const, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:blather_app/cache/image_cache.dart';
import 'package:blather_app/customs/appbar.dart';
import 'package:blather_app/customs/custom_tile.dart';
import 'package:blather_app/enum/view_state.dart';
import 'package:blather_app/models/message_model.dart';
import 'package:blather_app/models/user.dart';
import 'package:blather_app/provider/image_upload_provider.dart';
import 'package:blather_app/screens/giphyscreen.dart';
import 'package:blather_app/service/apikeys.dart';
import 'package:blather_app/service/firebase_methods.dart';
import 'package:blather_app/service/firebase_repository.dart';
import 'package:blather_app/styles/constants.dart';
import 'package:blather_app/styles/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserDetails receiver;

  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  final FirebaseMethods _authMethods = FirebaseMethods();
  final FirebaseRepository _repository = FirebaseRepository();
  ScrollController _listScrollController = ScrollController();
  late UserDetails sender;
  late String _currentUserId;
  late ImageUploadProvider _imageUploadProvider;
  bool isWriting = false;
  GiphyGif? _gif;
  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = UserDetails(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      backgroundColor: blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  child: CircularProgressIndicator(),
                  margin: EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                )
              : Container(),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(MESSAGES_COLLECTION)
          .doc(_currentUserId)
          .collection(widget.receiver.uid as String)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          _listScrollController.animateTo(
            _listScrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        });
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data!.docs.length,
          reverse: true,
          controller: _listScrollController,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    MessageModel _messageModel =
        MessageModel.fromMap(snapshot.data() as Map<String, dynamic>);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _messageModel.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _messageModel.senderId == _currentUserId
            ? senderLayout(_messageModel)
            : receiverLayout(_messageModel),
      ),
    );
  }

  Widget senderLayout(MessageModel message) {
    Radius messageRadius = Radius.circular(20);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  getMessage(MessageModel message) {
    return message.type != MESSAGE_TYPE_IMAGE &&
            message.type != MESSAGE_TYPE_GIF
        ? Text(
            message.message as String,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        : message.photoUrl != null
            ? CachedImage(
                message.photoUrl as String,
                height: 250,
                width: 250,
                radius: 10,
              )
            : Text("Image not found.");
  }

  Widget receiverLayout(MessageModel message) {
    Radius messageRadius = Radius.circular(30);

    return Container(
      margin: EdgeInsets.only(top: 10),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        child: Icon(
                          Icons.close,
                          color: kPrimaryColor,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                        onTap: () => pickImage(ImageSource.gallery),
                      ),
                      ModalTile(
                        title: "Giphy",
                        subtitle: "Share Gifs from Giphy",
                        icon: Icons.gif,
                        onTap: () async {
                          final gif = await GiphyPicker.pickGif(
                            context: context,
                            apiKey: GIPHY_API_KEY,
                            fullScreenDialog: false,
                            previewType: GiphyPreviewType.previewWebp,
                            decorator: GiphyDecorator(
                              showAppBar: false,
                              searchElevation: 4,
                              giphyTheme: ThemeData.dark().copyWith(
                                inputDecorationTheme: InputDecorationTheme(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          );
                          pickGif(gif!);
                          if (gif != null) {
                            setState(() => _gif = gif);
                          }
                        },
                      ),
                      // ModalTile(
                      //     title: "File",
                      //     subtitle: "Share files",
                      //     icon: Icons.tab),
                      // ModalTile(
                      //     title: "Contact",
                      //     subtitle: "Share contacts",
                      //     icon: Icons.contacts),
                      // ModalTile(
                      //     title: "Location",
                      //     subtitle: "Share a location",
                      //     icon: Icons.add_location),
                      // ModalTile(
                      //     title: "Schedule Call",
                      //     subtitle: "Arrange a skype call and get reminders",
                      //     icon: Icons.schedule),
                      // ModalTile(
                      //     title: "Create Poll",
                      //     subtitle: "Share polls",
                      //     icon: Icons.poll)
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: greyColor,
                ),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: separatorColor,
                // suffixIcon: GestureDetector(
                //   onTap: () {},
                //   child: Icon(Icons.emoji_emotions_outlined),
                // ),
              ),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.mic),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(ImageSource.camera),
                  child: Icon(Icons.camera_alt),
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: kPrimaryColor, shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container(),
        ],
      ),
    );
  }

  pickImage(ImageSource source) async {
    File selectedImage = await Utils.pickImage(source: source);
    _repository.uploadImage(
      image: selectedImage,
      receiverId: widget.receiver.uid as String,
      senderId: _currentUserId,
      imageUploadProvider: _imageUploadProvider,
    );
  }

  pickGif(GiphyGif source) {
    String type = source.type as String;
    String domainName = "https://i.giphy.com/media/";
    String imageId = source.id;
    String viewableUrl = domainName + imageId + "/200." + type;
    _repository.uploadGif(
      gif: viewableUrl,
      receiverId: widget.receiver.uid as String,
      senderId: _currentUserId,
    );
  }

  sendMessage() {
    var text = textFieldController.text;
    MessageModel _message = MessageModel(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: "text",
    );

    setState(() {
      isWriting = false;
    });

    textFieldController.text = "";

    _repository.addMessageToDb(_message, sender, widget.receiver);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name as String,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.videocam,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;
  const ModalTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        onTap: onTap as Function(),
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

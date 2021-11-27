// ignore_for_file: prefer_const_constructors

import 'package:blather_app/service/apikeys.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

class GiphyPage extends StatefulWidget {
  GiphyPage({Key? key}) : super(key: key);

  @override
  _GiphyPageState createState() => _GiphyPageState();
}

class _GiphyPageState extends State<GiphyPage> {
  late GiphyGif _giphyGif;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_giphyGif.title ?? 'Giphy'),
      ),
      body: SafeArea(
        child: Center(
          child: _giphyGif == null
              ? Text(
                  'Pick a Gif',
                  style: TextStyle(fontSize: 30.0),
                )
              : GiphyImage.original(gif: _giphyGif),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final gif = await GiphyPicker.pickGif(
            context: context,
            apiKey: GIPHY_API_KEY,
            fullScreenDialog: false,
            showPreviewPage: true,
            decorator: GiphyDecorator(
              showAppBar: false,
              searchElevation: 4,
              giphyTheme: ThemeData.dark(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.search),
      ),
    );
  }
}

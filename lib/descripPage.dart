import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DescripPage extends StatelessWidget {

  final Map _snapshot;

  DescripPage(this._snapshot);

  _launchURL() async {
    var id = _snapshot['id'];
    var url = Uri.parse("https://www.youtube.com/watch?v=$id");
    print(url);
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_snapshot['snippet']['title']),
        backgroundColor: Colors.black,
        actions: <Widget>[

        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  child: Image.network(_snapshot['snippet']['thumbnails']['maxres']['url']),
                ),
                onTap: _launchURL,
              ),
              Container(
                child: Text(_snapshot['snippet']['description'], style: TextStyle(color: Colors.white, fontSize: 25),),
              )
            ],
          ),
        ),
      )
    );
  }
}


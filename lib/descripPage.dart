import 'package:flutter/material.dart';

class DescripPage extends StatelessWidget {

  final Map _snapshot;

  DescripPage(this._snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_snapshot['title']),
        backgroundColor: Colors.black,
        actions: <Widget>[

        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                child: Image.network(_snapshot['thumbnails']['default']['url']),
              ),
              Container(
                child: Text(_snapshot['description'], style: TextStyle(color: Colors.white, fontSize: 25),),
              )
            ],
          ),
        ),
      )
    );
  }
}


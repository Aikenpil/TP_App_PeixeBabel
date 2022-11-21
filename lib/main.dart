import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:transparent_image/transparent_image.dart';


Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(MaterialApp(
    title: "Busca gifes",
    theme: ThemeData(hintColor: Colors.white),
    home: HomePage(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peixe Babel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _apiKey = dotenv.env['APIKEY'];
  var _search = "";
  var _offset = 1;

  int _getCount(List data){
    if (_search == null){
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets. all (10.0) ,
        gridDelegate : SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing : 10.0,
            mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data),
        itemBuilder: (context, index){
          if(_search == null || index < snapshot.data.length)
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data[index]["items"][index]["snippet"]["thumbnails"]["default"]["url"], height : 300.0, fit : BoxFit.cover,
              ),
              onTap: (){
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
                // );
              },
            );
          else return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0),
                  Text("More", style: TextStyle(color: Colors.white, fontSize: 22.0))
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 25;
                });
              },
            ),
          );
        }
    );
  }

  Future<List<dynamic>> _getTrending() async{
    http.Response response;
    if(_search == ''){
      response = await http.get(Uri.parse("https://www.googleapis.com/youtube/v3/search?key="+"$_apiKey"+"&channel_id=UCqB90BBr6eNRaJl-kl30Xxw&type=video&maxResults=$_offset"));
    } else {
      response = await http.get(Uri.parse("https://www.googleapis.com/youtube/v3/search?key="+"$_apiKey"+"&channel_id=UCqB90BBr6eNRaJl-kl30Xxw&type=video&maxResults=$_offset"));
    }

    var json = jsonDecode(response.body);
    List<dynamic> videoInfo = [];
    for(int i = 0; i < json['items'].length; i++){
      var videoId = json['items'][i]['id']['videoId'];
      var videoInfoRequest = await http.get(Uri.parse("https://www.googleapis.com/youtube/v3/videos?key="+"$_apiKey"+"&id="+"$videoId"+"&part=snippet"));
      videoInfo.add(jsonDecode(videoInfoRequest.body));
    }
    print(videoInfo);
    return videoInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network('https://serrapilheira.org/wp-content/uploads/2020/03/peixe-babel.jpg'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Search Here",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width:3, color: Colors.white))
              ),
              style: TextStyle(color: Colors.white, fontSize: 15.0),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getTrending(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return SingleChildScrollView(
                      child: Container(
                          width: 200.0,
                          height : 200.0,
                          alignment: Alignment.center,
                          child : CircularProgressIndicator (
                            valueColor : AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          )
                      ),
                    );
                  default:
                    if(snapshot.hasError) return Container();
                    else return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Tenor GIF API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();

  List<String> gifUrls = [];
  void getGifUrls(String word) async {
    print(word);
    var data = await http.get(
        'https://api.tenor.com/v1/search?q=$word&key=LIVDSRZULELA&limit=8');


    var dataParsed = jsonDecode(data.body);
    gifUrls.clear();
    for (int i = 0; i < 8; i++) {
      print(dataParsed['results'][i]['media'][0]['tinygif']['url']);
      gifUrls.add(dataParsed['results'][i]['media'][0]['tinygif']['url']);
    }

    setState(() {});
  }

  @override
  void initState() {
    getGifUrls('batman'); // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextField(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  controller: _controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              FlatButton(
                color: Colors.blueGrey.shade100,
                onPressed: () {
                  print('input text: ${_controller.text}');
                  getGifUrls(_controller.text);
                },
                child: Text('Gif Getir'),
              ),
              gifUrls.isEmpty
                  ? CircularProgressIndicator()
                  : Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.separated(
                    itemCount: 8,
                    itemBuilder: (_, int index) {
                      return GifCard(gifUrls[index]);
                    },
                    separatorBuilder: (_, __) {
                      return Divider(
                        color: Colors.blue,
                        thickness: 5,
                        height: 5,
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class GifCard extends StatelessWidget {
  final String gifUrl;

  GifCard(this.gifUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(gifUrl),
      ),
    );
  }
}
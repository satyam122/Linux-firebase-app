import 'dart:convert';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var fsc = FirebaseFirestore.instance;
  String x;
  var webdata;
  web(cmd) async {
    //print(cmd);
    var url = "http://192.168.1.12/cgi-bin/web.py?x=${cmd}";
    var r = await http.get(url);
    setState(() {
      webdata = r.body;
      var jdata = jsonDecode(webdata);
      print(jdata['output']);
      webdata = jdata['output'];
    });

    var d = fsc.collection("output").add({
      x: webdata,
    });

    print(webdata);
  }

  mybody() {
    return Container(
      child: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          width: 400,
          height: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: Colors.red,
                blurRadius: 20.0,
              ),
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.white, Colors.blueAccent]),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 700,
              width: 300,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Card(
                      child: TextField(
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Command ",
                        prefixIcon: Icon(Icons.adb)),
                    onChanged: (val) {
                      x = val;
                    },
                  )),
                  Card(
                    child: FlatButton(
                        onPressed: () {
                          web(x);
                        },
                        child: Text(
                          "OUTPUT:",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'CM Sans Serif',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                  ),
                  Container(
                    height: 100,
                    width: 300,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      gradient: FlutterGradient.fruitBlend(),
                    ),
                    child: Text(
                      webdata ?? "Output will be displayed here",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'CM Sans Serif',
                          fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            actions: <Widget>[Icon(Icons.home)],
            title: Text("Linux Firebase"),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.red, Colors.white])),
            ),
          ),
          body: mybody(),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue),
      home: const Contact(title: "Contact"),
    );
  }
}

class Contact extends StatefulWidget {
  const Contact({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Contact> createState() => _ContactState();
}

Future<List<Widget>> contactData() async {
  var endPoint = "https://mocki.io/v1/49698a5a-61eb-4ac8-9d40-cf93c6aa1923";
  var response = await http
      .get(Uri.parse(endPoint), headers: {'Content-Type': 'application/json'});
  String data = convert.utf8.decode(response.bodyBytes);
  List<dynamic> decodedData = convert.jsonDecode(data);
  List<Widget> contactPlaces = <Widget>[];

  for (var i = 0; i < decodedData.length; ++i) {
    var _customerName = decodedData[i]["name"];
    var _customerImage = decodedData[i]["avatar"];
    dynamic _customerAge = "";
    var _customerCity = "";

    if ("" == decodedData[i]["city"]) {
      _customerCity = "undefined";
    } else {
      _customerCity = decodedData[i]["city"];
    }

    if (null == decodedData[i]["age"] || 0 == decodedData[i]["age"]) {
      _customerAge = "No Information";
    } else {
      _customerAge = decodedData[i]["age"];
    }
    Widget contactPlace = Container(
        child: Row(children: <Widget>[
          Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(_customerImage)),
                  borderRadius: BorderRadius.circular(43))),
          const SizedBox(width: 17),
          Expanded(
              child: Column(children: <Widget>[
            Row(children: <Widget>[
              Text('$_customerName',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontFamily: "SF Pro Display",
                      fontWeight: FontWeight.w500)),
              const Expanded(child: SizedBox()),
              Text('$_customerAge',
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 104, 104, 104),
                      fontStyle: FontStyle.normal,
                      fontFamily: "SF Pro Display",
                      fontWeight: FontWeight.w400))
            ]),
            Row(children: <Widget>[
              Text(_customerCity,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 104, 104, 104),
                      fontStyle: FontStyle.normal,
                      fontFamily: "SF Pro Display",
                      fontWeight: FontWeight.w400))
            ])
          ]))
        ]),
        margin: const EdgeInsets.only(bottom: 29.5, top: 0));

    contactPlaces.add(contactPlace);
  }

  return contactPlaces;
}

class _ContactState extends State<Contact> {
  var _contactWidgets = <Widget>[];

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    List<Widget> contactWidgets = await contactData();

    setState(() {
      _contactWidgets = contactWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title,
                style: const TextStyle(
                    fontFamily: "SF Pro Display",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontStyle: FontStyle.normal)),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 19),
                onPressed: () => {}),
            centerTitle: true,
            backgroundColor: Colors.black),
        body: Container(
            child: Column(children: <Widget>[
              Container(
                  child: Column(children: <Widget>[
                    const Padding(
                        padding: EdgeInsets.only(top: 32, right: 20, left: 24),
                        child: Text("Contacts",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontFamily: "SF Pro Display",
                                fontWeight: FontWeight.w400))),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 33, right: 20, left: 18, bottom: 0),
                        child: Column(children: _contactWidgets))
                  ], crossAxisAlignment: CrossAxisAlignment.start),
                  decoration: BoxDecoration(
                      color: const Color(0x00282729),
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(top: 14))
            ]),
            decoration: const BoxDecoration(color: Colors.black)));
  }
}

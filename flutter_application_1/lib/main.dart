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
        primarySwatch: Colors.blue
      ),
      home: const Contact(title: "Contact"),
    );
  }
}




class Contact extends StatefulWidget {
  const Contact({Key? key, required this.title}): super(key: key);



  final String title;



  @override
  State<Contact> createState() => _ContactState();
}




Future<List<Widget>> contactData() async {
  var endPoint = "https://mocki.io/v1/49698a5a-61eb-4ac8-9d40-cf93c6aa1923";
  var response = await http.get(Uri.parse(endPoint));
  String data = response.body;
  List<dynamic> decodedData = convert.jsonDecode(data);
  List<Widget> contactPlaces = <Widget>[];
  
  
  
  for (var i = 0; i < decodedData.length; ++i) {


    
    var _customerName = decodedData[i]["name"];
    var _customerAge = decodedData[i]["age"];
    var _customerCity = decodedData[i]["city"];
    Widget contactPlace = Container(child: Row(children: <Widget>[ Text("customer", style: TextStyle(color: Colors.white)), SizedBox(width: 15), Expanded( child: Column(children: <Widget>[Row(children: <Widget>[Text('$_customerName', style: TextStyle(color: Colors.white, fontSize: 19)), Expanded(child: SizedBox()), Text('$_customerAge', style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)))]), Row(children: <Widget>[Text("place", style: TextStyle(color: Color.fromARGB(255, 83, 83, 83)))])]))]), margin: EdgeInsets.only(bottom: 11, top: 11));






    contactPlaces.add(contactPlace);
  }

  return contactPlaces;
}



class _ContactState extends State<Contact> {
  
  var _contactWidgets = <Widget>[];
  int _test = 5;



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
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {}
        ),
        centerTitle: true,
        backgroundColor: Colors.black
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(  
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 70,
                      right:20,
                      left: 20
                      ),
                    child: const Text(
                      "Contacts",
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      right: 20,
                      left: 20,
                      bottom: 30
                    ),
                    child: Column(
                      children: _contactWidgets
                    )
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 42, 43, 43),
                borderRadius: BorderRadius.circular(15)
              ),
              margin: EdgeInsets.only(
                top: 70
              ) 
            )
          ]
        ),
        decoration: BoxDecoration(
          color: Colors.black
        )
      )
    );
  }
}

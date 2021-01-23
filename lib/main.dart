import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    http.post('http://api.nessieisreal.com/customers?key=ff20c7789770dbd08b2b18467a84a68e',
      headers: {
        'Content-type' : 'application/json'
      },
      body: json.encode ({
        "first_name": "Michael",
        "last_name": "Dressner",
        "address": {
          "street_number": "5717",
          "street_name": "Elm Street",
          "city": "Washington",
          "state": "DC",
          "zip": "20817"
        }}
      )).then((Response r) {
        print(r.body);
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Start(),
    );
  }
}

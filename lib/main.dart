import 'dart:convert';

import 'package:boilermake/screens/start/start_screen.dart';
import 'package:boilermake/services/budget_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BudgetService bs = new BudgetService();

    // Clear all saved data
    // for (String type in ["Accounts", "Bills", "Customers", "Deposits" ,"Loans",
    //   "Purchases", "Transfers", "Withdrawals"])
    //   bs.deleteAllData(type).then((bool success) {
    //     if (success) print("Successfully deleted " + type);
    //     else print("No " + type + " to delete");
    //   });


    bs.getCustomerId().then((String id) {
      print("Customer ID: " + id);
      bs.getAccountIds(id).then((List<String> accountIds) {
        for (String s in accountIds)
          print("Account ID: " + s);
      });
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

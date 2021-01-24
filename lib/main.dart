import 'package:boilermake/models/api/api_models.dart';
import 'package:boilermake/models/budget_model.dart';
import 'package:boilermake/screens/budget/budget_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
        providers: [
          Provider<BudgetModel>(create: (_) => BudgetModel()),
          Provider<CustomerModel>(create: (_) => CustomerModel()),
        ],
        child: BudgetScreen(),
      ),
    );
  }
}

import 'package:boilermake/widgets/budget_display.dart';
import 'package:flutter/material.dart';

class Start extends StatefulWidget {
  const Start({Key key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar();
    final padding = EdgeInsets.all(20);
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              BudgetDisplay(),
            ],
          ),
        ),
      ),
    );
  }
}

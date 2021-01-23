import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Start extends StatefulWidget {
  const Start({Key key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  double _sliderValue = 0.0;

  void setSliderValue(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar();

    final callApiButton = new FloatingActionButton(
      onPressed: () => {},
      child: Icon(Icons.plus_one),
    );

    final padding = EdgeInsets.all(20);

    final progressBar = FAProgressBar(
      backgroundColor: Colors.white,
      border: Border.all(width: 1),
      currentValue: (_sliderValue * 100).toInt(),
      displayText: " ",
      maxValue: 100,
      verticalDirection: VerticalDirection.up,
      displayTextStyle: TextStyle(fontSize: 20),
    );

    final slider = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: LinearProgressIndicator(
        value: _sliderValue,
        backgroundColor: Colors.black,
        minHeight: 20,
      ),
    );

    final circleThing = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CircularProgressIndicator(
        value: _sliderValue,
        backgroundColor: Colors.black,
        strokeWidth: 10,
      ),
    );

    final rowSpacer = SizedBox(width: 10);

    final progressBarRow = Row(
      children: [
        Icon(Icons.home),
        rowSpacer,
        Text("Rent:", style: TextStyle(fontSize: 20)),
        rowSpacer,
        Flexible(child: progressBar),
        rowSpacer,
        Text("\$600", style: TextStyle(fontSize: 20)),
      ],
    );
    final progressBarRow2 = Row(
      children: [
        Icon(Icons.home),
        rowSpacer,
        Text("Rent:", style: TextStyle(fontSize: 20)),
        rowSpacer,
        Flexible(child: slider),
        rowSpacer,
        Text("\$600", style: TextStyle(fontSize: 20)),
      ],
    );

    final progressBarRow3 = Row(
      children: [
        Icon(Icons.home),
        rowSpacer,
        Text("Rent:", style: TextStyle(fontSize: 20)),
        rowSpacer,
        Flexible(child: circleThing),
        rowSpacer,
        Text("\$600", style: TextStyle(fontSize: 20)),
      ],
    );
    final sleekSlider = SleekCircularSlider(
      initialValue: _sliderValue * 100,
      appearance: CircularSliderAppearance(size: 100),
    );
    final progressBarRow4 = Row(
      children: [
        Icon(Icons.home),
        rowSpacer,
        Text("Rent:", style: TextStyle(fontSize: 20)),
        rowSpacer,
        Flexible(child: sleekSlider),
        rowSpacer,
        Text("\$600", style: TextStyle(fontSize: 20)),
      ],
    );
    final columnSpacer = SizedBox(height: 10);

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        columnSpacer,
        progressBarRow,
        columnSpacer,
        progressBarRow2,
        columnSpacer,
        progressBarRow3,
        columnSpacer,
        progressBarRow4,
        columnSpacer,
      ],
    );

    final expansionTile = Padding(
      padding: padding,
      child: ExpansionTile(
        title: Text(
          "Your Budget",
          style: TextStyle(fontSize: 32),
        ),
        children: [
          column,
        ],
        subtitle: Text("What does a subtitle look like?"),
      ),
    );

    final realSlider = Slider(
      value: _sliderValue * 100,
      max: 100,
      onChanged: (value) => setSliderValue(value / 100),
    );

    final stack = Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        expansionTile,
        Positioned(
          child: realSlider,
          bottom: 0,
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: padding,
        child: stack,
      ),
      floatingActionButton: callApiButton,
    );
  }
}

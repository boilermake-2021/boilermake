import 'package:boilermake/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BudgetCirclePanel extends StatefulWidget {
  BudgetCirclePanel({Key key}) : super(key: key);

  @override
  _BudgetCirclePanelState createState() => _BudgetCirclePanelState();
}

class _BudgetCirclePanelState extends State<BudgetCirclePanel> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = EdgeInsets.all(20);
    final header = Positioned(
      left: 0,
      child: Text(
        "Categories",
        style: TextStyle(
          fontSize: 32,
        ),
      ),
    );
    final calendarIcon = Positioned(
      right: 0,
      child: FaIcon(
        FontAwesomeIcons.calendarTimes,
        size: 32,
      ),
    );

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM y');
    final String formatted = formatter.format(now);
    final monthLabel = Positioned(
      top: 42,
      left: 0,
      child: Text(formatted),
    );

    final pieChart = Positioned(
      left: -50,
      bottom: -35,
      child: PieChartSample2(),
    );

    return Container(
      height: size.height * .4,
      width: size.width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: padding,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              header,
              calendarIcon,
              monthLabel,
              pieChart,
            ],
          ),
        ),
      ),
    );
  }
}

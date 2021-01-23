import 'package:boilermake/models/budget_category_model.dart';
import 'package:boilermake/service/budget_service.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class BudgetDisplay extends StatefulWidget {
  final BudgetService model;
  BudgetDisplay({
    @required this.model,
  });

  @override
  _BudgetDisplayState createState() => _BudgetDisplayState();
}

class _BudgetDisplayState extends State<BudgetDisplay> {
  List<Widget> buildItems() {
    Map<String, BudgetCategoryModel> categories = widget.model.categoryBudgets;
    List<Widget> children = [];
    final spacer = SizedBox(height: 10);
    for (MapEntry<String, BudgetCategoryModel> entry in categories.entries) {
      final categoryProgress = new Card(
        child: ListTile(
          title: Text(entry.key),
          subtitle: CategoryProgress(
            name: entry.key,
            model: entry.value,
          ),
          dense: true,
        ),
      );
      children.add(categoryProgress);
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: buildItems(),
    );
  }
}

class CategoryProgress extends StatefulWidget {
  final String name;
  final BudgetCategoryModel model;
  CategoryProgress({
    @required this.model,
    @required this.name,
  });

  @override
  _CategoryProgressState createState() => _CategoryProgressState();
}

class _CategoryProgressState extends State<CategoryProgress> {
  @override
  Widget build(BuildContext context) {
    final progressBarValue = (widget.model.amountSpent.minorUnits.toDouble() /
        widget.model.limit.minorUnits.toDouble());

    final progressBarLeading =
        Text("${widget.model.amountSpent}/${widget.model.limit}");

    MaterialColor progressColor =
        progressBarValue >= 1 ? Colors.red : Colors.green;

    final progressBar = Flexible(
      child: LinearProgressIndicator(
        value: progressBarValue,
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        minHeight: 10,
      ),
    );

    final rowSpacer = SizedBox(width: 5);

    final progressBarRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        progressBarLeading,
        rowSpacer,
        progressBar,
      ],
    );

    return progressBarRow;
  }
}

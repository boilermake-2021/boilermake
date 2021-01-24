import 'package:boilermake/models/api/api_models.dart';
import 'package:boilermake/models/budget_category_model.dart';
import 'package:boilermake/models/budget_model.dart';
import 'package:boilermake/services/budget_service.dart';
import 'package:boilermake/services/constants.dart';
import 'package:boilermake/widgets/budget_display.dart';
import 'package:boilermake/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatefulWidget {
  BudgetScreen({Key key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  BudgetModel budgetModel;
  CustomerModel customerModel;
  bool loading;

  void updateCustomerPurchases() async {
    BudgetService service = new BudgetService();
    CustomerModel model = await service.getCustomerObject();
    if (mounted) {
      setState(() {
        budgetModel.update(model);
        customerModel.update(model);
      });
    }
  }

  @override
  void initState() {
    loading = true;
    budgetModel = Provider.of<BudgetModel>(context, listen: false);
    customerModel = Provider.of<CustomerModel>(context, listen: false);
    updateCustomerPurchases();
    super.initState();
    loading = false;
  }

  Widget _buildItem(int index) {
    List<MapEntry<String, BudgetCategoryModel>> categories =
        budgetModel.categoryBudgets.entries.toList();

    String categoryName = categories[index].key;
    categoryName = categoryName.replaceAll("_", " ");
    categoryName =
        "${categoryName[0].toUpperCase()}${categoryName.substring(1)}";

    BudgetCategoryModel model = categories[index].value;
    double percentage = 100 *
        (model.amountSpent.minorUnits.toDouble() /
            model.limit.minorUnits.toDouble());
    String percentStr = percentage.toStringAsFixed(2);

    return loading == true
        ? Center(child: CircularProgressIndicator())
        : Card(
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.hamburger),
              title: Text(
                categoryName,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: CategoryProgress(name: categoryName, model: model),
              trailing: Text(
                "$percentStr%",
                style: TextStyle(
                  color: percentage >= 100.00 ? Colors.red : Colors.green,
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final budgetLeft = Text(
      "Budget Left",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
    );
    final budgetNumRow = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${budgetModel.totalBudget - budgetModel.totalSpending}",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: Constants.red,
          ),
        ],
      ),
    );
    final appBar = new SliverAppBar(
      elevation: 10,
      expandedHeight: 180.00,
      backgroundColor: Colors.white,
      centerTitle: true,
      floating: true,
      pinned: true,
      actionsIconTheme: IconThemeData(color: Colors.black),
      snap: true,
      iconTheme: IconThemeData(color: Colors.black),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          budgetLeft,
          budgetNumRow,
        ],
      ),
    );

    final drawer = Drawer(
      child: ListView(
        children: [
          FlatButton(
            child: Text("Print Map"),
            onPressed: () {
              budgetModel.categoryBudgets.forEach(
                (key, model) => {
                  print("Key $key Model ${model.amountSpent}, ${model.limit}")
                },
              );
            },
          ),
        ],
      ),
    );

    return Scaffold(
      drawer: drawer,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          appBar,
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildItem(index);
              },
              childCount: budgetModel.categoryBudgets.length,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:boilermake/models/api/api_models.dart';
import 'package:boilermake/models/budget_category_model.dart';
import 'package:boilermake/models/budget_model.dart';
import 'package:boilermake/services/budget_service.dart';
import 'package:boilermake/services/constants.dart';
import 'package:boilermake/widgets/budget_display.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  List<MapEntry<String, BudgetCategoryModel>> categories;
  int _currentIndex = 0;
  final Map<String, IconData> _categoryIcons = {
    'furniture_store': FontAwesomeIcons.couch,
    'tech': FontAwesomeIcons.laptop,
    'food': FontAwesomeIcons.hamburger,
    'bar': FontAwesomeIcons.beer,
    'restaurant': FontAwesomeIcons.wineGlass,
    'meal_delivery': FontAwesomeIcons.shippingFast,
    'health': FontAwesomeIcons.hospital,
    'grocery_or_supermarket': FontAwesomeIcons.store,
    'shoe_store': FontAwesomeIcons.shoePrints,
    'pharmacy': FontAwesomeIcons.pills,
    'car_dealer': FontAwesomeIcons.car,
    'shopping_mall': FontAwesomeIcons.shoppingBag,
    'book_store': FontAwesomeIcons.book,
    'finance': FontAwesomeIcons.bookOpen,
    'department_store': FontAwesomeIcons.tshirt,
    'meal_takeaway': FontAwesomeIcons.shippingFast,
    'store': FontAwesomeIcons.storeAlt,
    'post_office': FontAwesomeIcons.mailBulk,
  };

  void updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  void updateCustomerPurchases() async {
    loading = true;
    BudgetService service = new BudgetService();
    CustomerModel model = await service.getCustomerObject();
    if (mounted) {
      setState(() {
        budgetModel.update(model);
        customerModel.update(model);
      });
    }
    loading = false;
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

  String sanitizeCategoryNames(String categoryName) {
    categoryName = categoryName.replaceAll("_", " ");
    categoryName =
        "${categoryName[0].toUpperCase()}${categoryName.substring(1)}";
    return categoryName;
  }

  Widget _buildItem(int index) {
    index -= 1;
    if (loading) {
      return CircularProgressIndicator();
    }
    categories = budgetModel.categoryBudgets.entries.toList();
    String categoryName = sanitizeCategoryNames(categories[index].key);

    BudgetCategoryModel model = categories[index].value;
    double percentage = 100 *
        (model.amountSpent.minorUnits.toDouble() /
            model.limit.minorUnits.toDouble());
    String percentStr = percentage.toStringAsFixed(2);

    return loading == true
        ? Center(child: CircularProgressIndicator())
        : Card(
            child: ListTile(
              leading: Icon(
                _categoryIcons[categories[index].key],
              ),
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
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
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
    final budgetNumRow = Row(
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
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Budget Categories",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return _buildItem(index);
              },
              childCount: budgetModel.categoryBudgets.length + 1,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => updateIndex(value),
        selectedFontSize: 0,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.moneyBill),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidMoneyBillAlt),
            label: "",
          ),
        ],
      ),
    );
  }
}

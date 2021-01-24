import 'package:boilermake/models/api/api_models.dart';
import 'package:boilermake/models/budget_category_model.dart';
import 'package:boilermake/models/budget_model.dart';
import 'package:boilermake/services/budget_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetDisplay extends StatefulWidget {
  BudgetDisplay();

  @override
  _BudgetDisplayState createState() => _BudgetDisplayState();
}

class _BudgetDisplayState extends State<BudgetDisplay> {
  CustomerModel customerModel;
  BudgetModel budgetModel;
  bool loading;

  void updateCustomerPurchases() async {
    loading = true;
    BudgetService service = new BudgetService();
    CustomerModel model = await service.getCustomerObject();

    if (mounted) {
      budgetModel.update(model);
      customerModel.update(model);
      setState(() {
        loading = false;
        print('No longer loading');
      });
    }
    loading = false;
    print('Finished updating customer purchases');
  }

  Widget _buildItem(int index) {
    PurchaseModel purchaseModel = customerModel.purchases[index];

    return loading == true
        ? Center(child: CircularProgressIndicator())
        : Card(
            child: ListTile(
              title: Text(purchaseModel.categories.first),
              subtitle: CategoryProgress(
                name: purchaseModel.categories.first,
                model:
                    budgetModel.categoryBudgets[purchaseModel.categories.first],
              ),
              dense: true,
            ),
          );
  }

  @override
  void initState() {
    customerModel = Provider.of<CustomerModel>(context, listen: false);
    budgetModel = Provider.of<BudgetModel>(context, listen: false);

    updateCustomerPurchases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: budgetModel.categoryBudgets.length,
      itemBuilder: (context, index) => _buildItem(index),
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
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

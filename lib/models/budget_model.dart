import 'package:boilermake/models/api/api_models.dart';
import 'package:boilermake/models/budget_category_model.dart';
import 'package:money2/money2.dart';

class BudgetModel {
  Map<String, BudgetCategoryModel> categoryBudgets;
  Money totalSpending;
  Money totalBudget;

  BudgetModel() {
    totalSpending = Money.fromInt(0, CommonCurrencies().usd);
    categoryBudgets = new Map<String, BudgetCategoryModel>();
    totalBudget = Money.fromString("\$5000.00", CommonCurrencies().usd);
  }

  Future<void> update(CustomerModel model) async {
    BudgetModel newModel = new BudgetModel();
    for (PurchaseModel purchase in model.purchases) {
      newModel.totalSpending += purchase.amount;
      if (purchase.categories.first == null) continue;
      String key = purchase.categories.first.toLowerCase().trim();
      newModel.categoryBudgets.putIfAbsent(key, () {
        return new BudgetCategoryModel(
            amountSpent: purchase.amount,
            limit: Money.parse("\$400.00", CommonCurrencies().usd));
      });
    }
    categoryBudgets = newModel.categoryBudgets;
    totalSpending = newModel.totalSpending;
  }

  Money getSpendingInCategory(String category) {
    if (!categoryBudgets.containsKey(category))
      return Money.fromInt(0, CommonCurrencies().usd);
    else
      return categoryBudgets[category].amountSpent;
  }

  void addSpendingToCategories(Money amount, List<String> categories) {
    totalSpending += amount;

    for (String category in categories)
      _addSpendingInCategory(amount, category);
  }

  void _addSpendingInCategory(Money amount, String category) {
    if (!categoryBudgets.containsKey(category)) {
      categoryBudgets[category] = new BudgetCategoryModel();
      categoryBudgets[category].amountSpent = amount;
    } else
      categoryBudgets[category].amountSpent += amount;
  }

  bool isMaxxed(String category) {
    if (!categoryBudgets.containsKey(category))
      return false;
    else
      return categoryBudgets[category].amountSpent >=
          categoryBudgets[category].limit;
  }
}

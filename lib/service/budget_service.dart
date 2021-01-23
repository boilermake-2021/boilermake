import 'package:boilermake/models/budget_category_model.dart';
import 'package:money2/money2.dart';

class BudgetService {
  Map<String, BudgetCategoryModel> categoryBudgets;
  Money totalSpending;

  BudgetService() {
    totalSpending = Money.fromInt(0, CommonCurrencies().usd);
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

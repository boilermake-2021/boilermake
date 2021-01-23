class BudgetService {
  Map<String, double> spending;
  Map<String, double> budget;
  double totalSpending;

  BudgetService() {
    totalSpending = 0;
  }

  double getSpendingInCategory(String category) {
    if (!spending.containsKey(category))
      return 0.0;
    else
      return spending[category];
  }

  void addSpendingToCategories(double amount, List<String> categories) {
    totalSpending += amount;

    for (String category in categories)
      _addSpendingInCategory(amount, category);
  }

  void _addSpendingInCategory(double amount, String category) {
    if (!spending.containsKey(category))
      spending[category] = amount;
    else
      spending[category] += amount;
  }
}
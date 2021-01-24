import 'package:money2/money2.dart';

class BudgetCategoryModel {
  BudgetCategoryModel({
    this.limit,
    this.amountSpent,
  });

  Money limit;
  Money amountSpent;
}

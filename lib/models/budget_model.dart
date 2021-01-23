import 'package:boilermake/models/budget_category_model.dart';
import 'package:boilermake/models/loan_model.dart';
import 'package:money2/money2.dart';

class BudgetModel {
  List<LoanModel> debts;
  List<BudgetCategoryModel> categories;
  Money monthlyIncome;
  Money moneySpent;
}

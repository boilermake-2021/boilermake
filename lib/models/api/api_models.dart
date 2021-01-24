import 'package:money2/money2.dart';

class CustomerModel {
  String id;
  List<PurchaseModel> purchases;
  CustomerModel();

  void update(CustomerModel model) {
    this.purchases = model.purchases;
    this.id = model.id;
  }
}

class PurchaseModel {
  String id;
  String merchantId;
  DateTime purchaseDate;
  String payerId;
  Money amount;
  String description;
  List<String> categories;
  PurchaseModel(this.id, this.merchantId, this.amount);
}

class MerchantModel {
  String id;
  String name;
  List<String> categories;

  MerchantModel(this.id) {
    categories = new List<String>();
  }

  void setName(String name) {
    this.name = name;
  }

  void addCategory(String category) {
    categories.add(category);
  }
}

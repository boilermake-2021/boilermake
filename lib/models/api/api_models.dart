import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class CustomerModel {
  List<AccountModel> accountIds;
  String id;
}

class AccountModel {
  String id;
  List<PurchaseModel> purchases;
}

class PurchaseModel {
  String id;
  String merchantId;
  DateTime purchaseDate;
  String payerId;
  Money amount;
  String description;
}

class MerchantModel {
  String id;
  String name;
  List<String> categories;
}

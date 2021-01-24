import 'dart:convert';

import 'package:boilermake/models/budget_category_model.dart';
import 'package:boilermake/models/budget_model.dart';
import 'package:boilermake/services/budget_service.dart';
import 'package:boilermake/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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

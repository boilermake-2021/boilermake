import 'dart:convert';

import 'package:boilermake/models/api/api_models.dart';
import 'package:boilermake/models/budget_model.dart';
import 'package:boilermake/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:money2/money2.dart';

class BudgetService {
  BudgetModel budgetModel;

  BudgetService() {
    budgetModel = new BudgetModel();
  }

  Future<CustomerModel> getCustomerObject() async {
    List<PurchaseModel> purchases = new List<PurchaseModel>();
    CustomerModel customer = await _getCustomer();
    List<String> accountIds = await _getAccountIds(customer.id);
    for (String accountId in accountIds)
      purchases.addAll(await _getPurchases(accountId));

    customer.purchases = purchases;

    return customer;
  }

  Future<CustomerModel> _getCustomer() async {
    var response = await http
        .get(Constants.nessie_endpoint_url + "/customers?key=" + Constants.nessie_api_key);
    List body = jsonDecode(response.body);
    String id = body.first["_id"];
    return CustomerModel(id);
  }

  Future<List<String>> _getAccountIds(String custId) async {
    List<String> result = new List();

    var response = await http.get(Constants.nessie_endpoint_url + "/accounts?key="
        + Constants.nessie_api_key);
    List body = jsonDecode(response.body);

    for (Map account in body) {
      result.add(account["_id"]);
    }

    return result;
  }

  Future<List<PurchaseModel>> _getPurchases(String accountId) async {
    List<PurchaseModel> purchases = new List();

    var response = await http.get(Constants.nessie_endpoint_url + "/accounts/" +
      accountId + "/purchases?key=" + Constants.nessie_api_key);
    List body = jsonDecode(response.body);

    for (Map purchase in body) {
      String id = purchase["_id"];
      String merchantId = purchase["merchant_id"];
      Money amount = Money.parse("\$" + purchase["amount"].toString(),
          CommonCurrencies().usd);
      PurchaseModel pm = new PurchaseModel(id, merchantId, amount);
      purchases.add(pm);
    }

    return purchases;
  }

  Future<MerchantModel> getMerchant(String id) async {
    MerchantModel merchant = new MerchantModel(id);

    var response = await http.get(Constants.nessie_endpoint_url +
        "/merchants/" + id + "?key=" + Constants.nessie_api_key);
    Map body = jsonDecode(response.body);

    merchant.setName(body["name"]);

    if (body.containsKey("category")) {
      List categories = body["category"];
      for (dynamic category in categories)
        merchant.addCategory(category.toString());
    }

    return merchant;
  }

  // Future<bool> deleteAllData(String type) async {
  //   var response = await http.delete(endpoint_url + "/data?key="
  //     + Constants.nessie_api_key + "&type=" + type);
  //
  //   return response.statusCode != 404;
  // }

}

import 'dart:convert';

import 'package:boilermake/models/api/api_models.dart';
import 'package:boilermake/services/constants.dart';
import 'package:http/http.dart' as http;
import 'package:money2/money2.dart';

class BudgetService {
  Future<CustomerModel> getCustomerObject() async {
    CustomerModel customer = new CustomerModel();
    List<PurchaseModel> purchases = new List<PurchaseModel>();

    String customerId = await _getCustomer();
    customer.id = customerId;

    List<String> accountIds = await _getAccountIds(customer.id);
    for (String accountId in accountIds) {
      List<PurchaseModel> newPurchases = await _getPurchases(accountId);
      purchases += newPurchases;
    }

    customer.purchases = purchases;
    return customer;
  }

  Future<String> _getCustomer() async {
    var response = await http.get(Constants.nessieEndpointUrl +
        "/customers?key=" +
        Constants.nessieApiKey);
    List body = jsonDecode(response.body);
    String id = body.first["_id"];
    print(body);
    return id;
  }

  Future<List<String>> _getAccountIds(String custId) async {
    List<String> result = new List();

    var response = await http.get(Constants.nessieEndpointUrl +
        "/accounts?key=" +
        Constants.nessieApiKey);
    List body = jsonDecode(response.body);

    for (Map account in body) {
      result.add(account["_id"]);
    }

    return result;
  }

  Future<List<PurchaseModel>> _getPurchases(String accountId) async {
    List<PurchaseModel> purchases = new List();

    var response = await http.get(Constants.nessieEndpointUrl +
        "/accounts/" +
        accountId +
        "/purchases?key=" +
        Constants.nessieApiKey);
    List body = jsonDecode(response.body);

    for (Map purchase in body) {
      print(purchase);
      String id = purchase["_id"];
      String merchantId = purchase["merchant_id"];
      double amountStr = double.parse(purchase["amount"].toString());
      Money amount = Money.from(amountStr, CommonCurrencies().usd);
      PurchaseModel purchaseModel = new PurchaseModel(id, merchantId, amount);
      MerchantModel merchantModel =
          await getCategoriesByMerchantId(purchaseModel.merchantId);
      purchaseModel.categories = merchantModel.categories;
      purchases.add(purchaseModel);
    }

    return purchases;
  }

  Future<MerchantModel> getCategoriesByMerchantId(String id) async {
    MerchantModel merchant = new MerchantModel(id);

    var response = await http.get(Constants.nessieEndpointUrl +
        "/merchants/" +
        id +
        "?key=" +
        Constants.nessieApiKey);
    Map body = jsonDecode(response.body);

    merchant.setName(body["name"]);

    if (body.containsKey("category")) {
      List categories = body["category"];
      for (dynamic category in categories)
        merchant.addCategory(category.toString());
    }

    return merchant;
  }
}

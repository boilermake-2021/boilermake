import 'dart:convert';

import 'package:boilermake/models/budget_model.dart';
import 'package:boilermake/services/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class BudgetService {
  final String endpoint_url = "http://api.nessieisreal.com";
  BudgetModel budgetModel;

  BudgetService() {
    budgetModel = new BudgetModel();
  }

  Future<String> getCustomerId() async {
    var response = await http.get(endpoint_url + "/customers?key="
        + Constants.nessie_api_key);
    List body = jsonDecode(response.body);
    return body.first["_id"];
  }

  // Future<bool> deleteAllData(String type) async {
  //   var response = await http.delete(endpoint_url + "/data?key="
  //     + Constants.nessie_api_key + "&type=" + type);
  //
  //   return response.statusCode != 404;
  // }


}

import 'package:dio/dio.dart';
import 'package:finapp/models/account.dart';
import 'package:finapp/models/history.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import "../constants/apiConstants.dart";

List<Account> parseCurrentAmount(String responseBody) {
  return [];
}

Future<RecentDepositsAndWithdrawals> getRecentDepositsAndWithdrawals() async {
  var dio = new Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("bearerToken");

  dio.options.headers["Authorization"] = "Bearer $token";

  try {
    var response = await dio.get(
      "$apiUrl/history/recent-deposits-and-withdrawals",
      queryParameters: {
        "userId": userId,
      },
    );

    return RecentDepositsAndWithdrawals(
      deposits: response.data["deposits"].toDouble(),
      withdrawals: response.data["withdrawals"].toDouble(),
    );
  } finally {
    dio.close();
  }
}

Future<List<Account>> getCurrentAmount() async {
  var client = http.Client();
  try {
    var uriResponse = await client.post(Uri.parse(apiUrl));
    return parseCurrentAmount(uriResponse.body);
  } finally {
    client.close();
  }
}

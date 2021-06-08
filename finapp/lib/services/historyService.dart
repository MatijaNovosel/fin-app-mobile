import 'package:dio/dio.dart';
import 'package:finapp/helpers/helpers.dart';
import 'package:finapp/models/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "../constants/apiConstants.dart";

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

Future<List<HistoryModel>> getTotalHistory() async {
  var dio = new Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("bearerToken");

  dio.options.headers["Authorization"] = "Bearer $token";

  List<HistoryModel> data = [];

  try {
    var response = await dio.get(
      "$apiUrl/history/total",
      queryParameters: {
        "userId": userId,
        "from": DateTime.now().subtract(
          Duration(
            days: 30,
          ),
        ),
        "to": DateTime.now(),
      },
    );

    for (var history in response.data) {
      data.add(
        new HistoryModel(
          amount: history["amount"].toDouble(),
          createdAt: history["createdAt"],
        ),
      );
    }

    return data;
  } finally {
    dio.close();
  }
}

Future<List<HistoryModel>> getTotalHistoryForAccount(int accountId) async {
  var dio = new Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("bearerToken");

  dio.options.headers["Authorization"] = "Bearer $token";

  List<HistoryModel> data = [];

  try {
    var response = await dio.get(
      "$apiUrl/history/account/$accountId",
      queryParameters: {
        "userId": userId,
        "from": DateTime.now().subtract(
          Duration(
            days: 30,
          ),
        ),
        "to": DateTime.now(),
      },
    );

    for (var history in response.data) {
      data.add(
        new HistoryModel(
          amount: history["amount"].toDouble(),
          createdAt: history["createdAt"],
        ),
      );
    }

    return data;
  } finally {
    dio.close();
  }
}

Future<List<TagPercentageModel>> getTagPercentages() async {
  var dio = new Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("bearerToken");

  dio.options.headers["Authorization"] = "Bearer $token";

  List<TagPercentageModel> data = [];

  try {
    var response = await dio.get(
      "$apiUrl/history/tag-percentages",
      queryParameters: {
        "userId": userId,
      },
    );

    for (var tagPercentage in response.data) {
      var randColor = randomColor();
      data.add(
        new TagPercentageModel(
          percentage: tagPercentage["percentage"].toDouble(),
          description: tagPercentage["description"],
          color: randColor,
        ),
      );
    }

    data.sort((a, b) => a.percentage.compareTo(b.percentage));

    return data.reversed.toList();
  } finally {
    dio.close();
  }
}

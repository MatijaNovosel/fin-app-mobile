library transaction_service;

import 'package:dio/dio.dart';
import 'package:finapp/constants/apiConstants.dart';
import 'package:finapp/models/tag.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';

Future<List<Transaction>> getTransactions() async {
  var dio = new Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("bearerToken");

  dio.options.headers["Authorization"] = "Bearer $token";

  try {
    List<Transaction> data = [];

    var response = await dio.get(
      "$apiUrl/transaction",
      queryParameters: {
        "userId": userId,
        "skip": 0,
        "take": 25,
      },
    );

    for (var transaction in response.data["results"]) {
      data.add(
        new Transaction(
          amount: transaction["amount"]
              .toDouble(), // Dynamic types may be binded to an int instead of a double ...
          description: transaction["description"],
          id: transaction["id"],
          accountDescription: transaction["account"]["description"],
          createdAt: transaction["createdAt"],
          expense: transaction["expense"],
          tags: transaction["tags"]
              .map<Tag>(
                (x) => new Tag(
                  description: x["description"],
                  id: x["id"],
                ),
              )
              .toList(),
        ),
      );
    }

    return data;
  } finally {
    dio.close();
  }
}

Future addTransaction(NewTransaction payload) async {
  var dio = new Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("bearerToken");

  dio.options.headers["Authorization"] = "Bearer $token";

  try {
    await dio.post(
      "$apiUrl/transaction",
      data: {
        "amount": payload.amount,
        "description": payload.description,
        "accountId": payload.accountId,
        "createdAt": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(
          DateTime.now(),
        ),
        "expense": payload.expense,
        "tagIds": payload.tags,
        "userId": userId
      },
    );
  } catch (e) {
    print(e);
  } finally {
    dio.close();
  }
}

Future addTransfer(NewTransfer payload) async {
  var dio = new Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.get("bearerToken");

  dio.options.headers["Authorization"] = "Bearer $token";

  try {
    await dio.post(
      "$apiUrl/transaction/transfer",
      data: {
        "amount": payload.amount,
        "accountFromId": payload.accountFromId,
        "accountToId": payload.accountToId,
        "createdAt": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(
          DateTime.now(),
        ),
        "userId": userId
      },
    );
  } catch (e) {
    print(e);
  } finally {
    dio.close();
  }
}

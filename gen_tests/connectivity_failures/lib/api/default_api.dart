import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_failures/api_client.dart';
import 'package:connectivity_failures/api_exception.dart';
import 'package:connectivity_failures/model/item.dart';
import 'package:connectivity_failures/model/problem.dart';

/// Endpoints with tag Default
class DefaultApi {
  DefaultApi(ApiClient? client) : client = client ?? ApiClient();

  final ApiClient client;

  Future<Item> getItem() async {
    final response = await client.invokeApi(method: Method.get, path: '/item');

    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException<Problem>(
        response.statusCode,
        response.body,
        body: Problem.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        ),
      );
    }

    if (response.body.isNotEmpty) {
      return Item.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw ApiException<Object?>.unhandled(response.statusCode);
  }
}

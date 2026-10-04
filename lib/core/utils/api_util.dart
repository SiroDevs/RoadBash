// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'app_util.dart';

Future<http.Response> makeApiGetRequest(
  String endpoint,
  Map<String, String> headers,
) async {
  try {
    logger('Api Request [GET]: $endpoint \nHeaders: ${json.encode(headers)}');

    final response = await http
        .get(
      Uri.parse(endpoint),
      headers: headers,
    )
        .timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        logger('Timeout occurred. Please try again later.');
        return http.Response('Timeout occurred', 504);
      },
    );

    logger('Api Response: [${response.statusCode}] ${response.body}');

    return response;
  } catch (e) {
    if (e is TimeoutException) {
      logger('Timeout occurred. Please try again later.');
      return http.Response('Timeout occurred', 504);
    } else {
      logger('An error occurred during the HTTP request: $e');
      return http.Response('Internal server error', 500);
    }
  }
}

Future<http.Response> makeApiPostRequest(
  String endpoint,
  Map<String, String> headers,
  dynamic requestBody, {
  bool isEncoded = false,
}) async {
  var requestBodyFinal = isEncoded ? requestBody : json.encode(requestBody);

  try {
    logger(
        'Api Request [POST]: $endpoint\n Headers: ${json.encode(headers)} \nJsonData: ${requestBodyFinal ?? ''}');

    final response = await http
        .post(
      Uri.parse(endpoint),
      headers: headers,
      body: requestBodyFinal ?? '',
    )
        .timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        logger('Timeout occurred. Please try again later.');
        return http.Response('Timeout occurred', 504);
      },
    );

    logger('Api Response: [${response.statusCode}] ${response.body}');

    return response;
  } catch (e) {
    if (e is TimeoutException) {
      logger('Timeout occurred. Please try again later.');
      return http.Response('Timeout occurred', 504);
    } else {
      logger('An error occurred during the HTTP request: $e');
      return http.Response('Internal server error', 500);
    }
  }
}

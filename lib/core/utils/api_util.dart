// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'app_util.dart';

const _timeout = Duration(seconds: 60);

http.Response _timeoutResponse() {
  logger('Timeout occurred. Please try again later.');
  return http.Response('Timeout occurred', 504);
}

Future<http.Response> _send(
  String requestLog,
  Future<http.Response> Function() request,
) async {
  try {
    logger(requestLog);
    final response = await request().timeout(_timeout, onTimeout: _timeoutResponse);
    logger('Api Response: [${response.statusCode}] ${response.body}');
    return response;
  } on TimeoutException {
    return _timeoutResponse();
  } catch (e) {
    logger('An error occurred during the HTTP request: $e');
    return http.Response('Internal server error', 500);
  }
}

Future<http.Response> makeApiGetRequest(
  String endpoint,
  Map<String, String> headers,
) =>
    _send(
      'Api Request [GET]: $endpoint \nHeaders: ${json.encode(headers)}',
      () => http.get(Uri.parse(endpoint), headers: headers),
    );

Future<http.Response> makeApiPostRequest(
  String endpoint,
  Map<String, String> headers,
  dynamic requestBody, {
  bool isEncoded = false,
}) {
  final body = isEncoded ? requestBody : json.encode(requestBody);
  return _send(
    'Api Request [POST]: $endpoint\n Headers: ${json.encode(headers)} \nJsonData: ${body ?? ''}',
    () => http.post(Uri.parse(endpoint), headers: headers, body: body ?? ''),
  );
}

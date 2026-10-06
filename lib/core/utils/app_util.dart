// Dart imports:
import 'dart:async';
import 'dart:developer' as logging show log;
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';

bool isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
bool isMobile = Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;

void logger(String message) {
  return logging.log('''
$message
  ''');
}

String getThemeModeString(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.light:
      return 'Light';

    case ThemeMode.dark:
      return 'Dark';

    default:
      return 'System Theme';
  }
}

String dateNow() {
  return DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
}

Future<bool> _hostResolves(String host) async {
  try {
    final result = await InternetAddress.lookup(host);
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

Future<bool> isConnected() => _hostResolves('google.com');

String extractMessage(String error) {
  final regex = RegExp(r'AuthException\(message:\s*(.*?),\s*statusCode:');
  final match = regex.firstMatch(error);
  return match?.group(1) ?? 'Unknown error';
}

List<String> generateDropDownItems({
  String initial = '',
  int? lowerLimit,
  int? upperLimit,
  bool incremental = true,
  int minLength = 2,
}) {
  List<String> temp = [], items = [];
  temp.add(initial);
  if (incremental) {
    for (int i = lowerLimit!; i < upperLimit! + 1; i++) {
      temp.add(i.toString());
    }
  } else {
    for (int i = upperLimit!; i > lowerLimit! - 1; i--) {
      temp.add(i.toString());
    }
  }
  for (var item in temp) {
    if (item.length < minLength) {
      items.add('0$item');
    } else {
      items.add(item);
    }
  }
  return items;
}

Future<bool> isConnectedToInternet() async {
  try {
    final result = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (result == ConnectivityResult.none) return false;
  } catch (_) {
    return false;
  }
  return _hostResolves('example.com');
}

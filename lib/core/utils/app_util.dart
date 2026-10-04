import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as logging show log;
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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

Future<bool> isConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

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
    final connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) return false;

    // Verify actual internet connection
    const exampleHost = 'example.com'; // Or use your server
    final result = await InternetAddress.lookup(exampleHost);
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  } catch (_) {
    return false;
  }
}

String formatDoneAt(String doneAt) {
  DateTime dateTime = DateTime.parse(doneAt).toLocal();
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(const Duration(days: 1));

  if (dateTime.isAfter(today)) {
    return "Today at ${DateFormat.jm().format(dateTime)}";
  } else if (dateTime.isAfter(yesterday)) {
    return "Yesterday at ${DateFormat.jm().format(dateTime)}";
  } else {
    return "${DateFormat('MMMM d, y').format(dateTime)} at ${DateFormat.jm().format(dateTime)}";
  }
}

List<Uint8List> convertBase64ToImages(String base64String) {
  List<String> base64Images = base64String.split(';');

  return base64Images.map((String base64Image) {
    return base64Decode(base64Image);
  }).toList();
}

Image base64toImage(
  String base64String, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
}) {
  final bytes = base64Decode(base64String);
  return Image.memory(
    bytes,
    width: width,
    height: height,
    fit: fit,
  );
}

double getProgressValue(String status) {
  switch (status) {
    case 'requested':
      return 0.2;
    case 'assigned':
      return 0.4;
    case 'inProgress':
      return 0.7;
    case 'completed':
      return 1.0;
    default:
      return 0.0;
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'ongoing':
      return Colors.orange;
    case 'finished':
      return Colors.green;
    case 'pending':
      return Colors.grey;
    default:
      return Colors.blue;
  }
}

String formatDateTime(String dateString) {
  try {
    final dateTime = DateTime.parse(dateString);
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  } catch (e) {
    return dateString;
  }
}


String formatDateTimeSimple(String dateString) {
  try {
    final dateTime = DateTime.parse(dateString);
    return DateFormat('EEE, MMM d • h:mm a').format(dateTime);
  } catch (e) {
    return dateString;
  }
}

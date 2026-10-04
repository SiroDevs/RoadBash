import 'package:flutter/material.dart';

class Validation {
  bool validated;
  String error;

  Validation({this.validated = true, this.error = ''});
}

class RespModel {
  int status;
  String feedback;
  dynamic response;

  RespModel({this.status = 0, this.feedback = '', this.response});
}

enum PageType { home, habits, stats, profile }

List<PageType> pages = [
  PageType.home,
  PageType.habits,
  PageType.stats,
  PageType.profile,
];

class PageItem {
  const PageItem({
    required this.title,
    required this.icon,
    required this.screen,
  });
  final String title;
  final IconData icon;
  final Widget screen;
}

class MapBounds {
  final double north;
  final double south;
  final double east;
  final double west;

  MapBounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });
}
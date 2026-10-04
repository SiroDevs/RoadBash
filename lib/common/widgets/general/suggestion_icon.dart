// Flutter imports:
import 'package:flutter/material.dart';

class SuggestionIcon extends StatelessWidget {
  final String suggestionType;

  const SuggestionIcon({super.key, required this.suggestionType});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (suggestionType) {
      case 'city':
      case 'town':
      case 'village':
        icon = Icons.location_city;
        color = Colors.blue;
        break;
      case 'road':
      case 'street':
        icon = Icons.streetview;
        color = Colors.orange;
        break;
      case 'restaurant':
      case 'cafe':
      case 'bar':
        icon = Icons.restaurant;
        color = Colors.red;
        break;
      case 'hotel':
      case 'motel':
        icon = Icons.hotel;
        color = Colors.purple;
        break;
      case 'park':
      case 'garden':
        icon = Icons.park;
        color = Colors.green;
        break;
      default:
        icon = Icons.place;
        color = Colors.red;
    }

    return Icon(icon, color: color, size: 24);
  }
}

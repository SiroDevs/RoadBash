// Dart imports:
import 'dart:ui';

/// Parses 'x,y x,y' text into points.
List<Offset> parsePoints(String text) {
  if (text.isEmpty) return const [];
  return [
    for (final pair in text.split(' '))
      Offset(
        double.parse(pair.substring(0, pair.indexOf(','))),
        double.parse(pair.substring(pair.indexOf(',') + 1)),
      ),
  ];
}

/// Builds a closed path through the points.
Path pathOf(List<Offset> points) {
  final path = Path()..moveTo(points.first.dx, points.first.dy);
  for (var index = 1; index < points.length; index++) {
    path.lineTo(points[index].dx, points[index].dy);
  }
  return path..close();
}

/// One named polygon of the supplied artwork.
class ArtShape {
  ArtShape(this.name, this.points) : path = pathOf(points);

  /// Reads a 'Name|x,y x,y' row.
  factory ArtShape.parse(String row) {
    final cut = row.indexOf('|');
    return ArtShape(row.substring(0, cut), parsePoints(row.substring(cut + 1)));
  }

  final String name;
  final List<Offset> points;
  final Path path;
}

/// A group of shapes that moves as one rigid piece.
class ArtPart {
  ArtPart(this.id, List<String> rows)
    : shapes = [for (final row in rows) ArtShape.parse(row)];

  final String id;
  final List<ArtShape> shapes;

  /// The kind of body piece, taken from the start of the id.
  String get kind {
    for (final prefix in const ['helmet', 'torso', 'arm', 'leg', 'boot']) {
      if (id.startsWith(prefix)) return prefix;
    }
    return id;
  }
}

/// Every part and joint position of one artwork view.
class ArtSheet {
  ArtSheet(Map<String, List<String>> rows, Map<String, List<double>> joints)
    : parts = {
        for (final entry in rows.entries)
          entry.key: ArtPart(entry.key, entry.value),
      },
      anchors = {
        for (final entry in joints.entries)
          entry.key: Offset(entry.value[0], entry.value[1]),
      };

  final Map<String, ArtPart> parts;
  final Map<String, Offset> anchors;

  /// Returns a joint position, or the design box centre when unknown.
  Offset anchor(String name) => anchors[name] ?? const Offset(60, 85);
}

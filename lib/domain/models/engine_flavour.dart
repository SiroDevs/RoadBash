/// Engine sound styles the player can choose.
enum EngineFlavour {
  classic('classic', 'Classic'),
  vTwin('vtwin', 'V-Twin'),
  superbike('superbike', 'Superbike'),
  twoStroke('twostroke', 'Two-Stroke'),
  arcade('arcade', 'Arcade');

  const EngineFlavour(this.id, this.label);

  final String id;
  final String label;

  /// Returns the flavour with the given id, or classic.
  static EngineFlavour fromId(String id) =>
      values.firstWhere((f) => f.id == id, orElse: () => classic);

  /// The next flavour, wrapping around.
  EngineFlavour get next => values[(index + 1) % values.length];

  /// The previous flavour, wrapping around.
  EngineFlavour get previous =>
      values[(index - 1 + values.length) % values.length];
}

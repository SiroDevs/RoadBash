enum EngineFlavour {
  classic('classic', 'Classic'),
  vTwin('vtwin', 'V-Twin'),
  superbike('superbike', 'Superbike'),
  twoStroke('twostroke', 'Two-Stroke'),
  arcade('arcade', 'Arcade');

  const EngineFlavour(this.id, this.label);

  final String id;
  final String label;

  static EngineFlavour fromId(String id) =>
      values.firstWhere((f) => f.id == id, orElse: () => classic);

  EngineFlavour get next => values[(index + 1) % values.length];

  EngineFlavour get previous =>
      values[(index - 1 + values.length) % values.length];
}

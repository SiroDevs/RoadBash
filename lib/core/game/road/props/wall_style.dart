enum WallStyle {
  block(300),
  concrete(1800),
  rock(2200),
  white(520),
  parapet(360),
  hoarding(1000);

  const WallStyle(this.height);

  final double height;
}

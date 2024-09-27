enum Panel { upper, lower }

typedef PanelLocation = (int, Panel);

extension CopyablePanelLocation on PanelLocation {
  PanelLocation copyWith({int? index, Panel? panel}) =>
  (index ?? this.$1, panel ?? this.$2);
}
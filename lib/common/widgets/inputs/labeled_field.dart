// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../core/theme/theme_colors.dart';
import '../../../core/theme/theme_styles.dart';

/// A field with its label above and a rounded border around it. When
/// [inline] is true the field is returned as-is (it draws its own label).
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.field,
    required this.borderRadius,
    this.inline = false,
  });

  final String label;
  final Widget field;
  final BorderRadius borderRadius;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    if (inline) return field;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ThemeColors.blackText,
              fontWeight: FontWeight.bold,
            ),
          ).padding(top: Sizes.sm),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: ThemeColors.darkGray, width: 1),
          ),
          child: field,
        ),
      ],
    );
  }
}

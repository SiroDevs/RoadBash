// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../core/theme/theme_colors.dart';
import '../../../core/theme/theme_styles.dart';

class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String label;
  final String Function(T) getItemLabel;
  final void Function(T?)? onChanged;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool inline;

  const AppDropdown({
    super.key,
    required this.items,
    required this.getItemLabel,
    this.value,
    this.label = '',
    this.onChanged,
    this.margin,
    this.borderRadius = 6,
    this.inline = true,
  });

  @override
  AppDropdownState<T> createState() => AppDropdownState<T>();
}

class AppDropdownState<T> extends State<AppDropdown<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    var labelWidget = Text(
      widget.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: ThemeColors.blackText,
        fontWeight: FontWeight.bold,
      ),
    ).padding(top: Sizes.sm);

    var inlineDecoration = InputDecoration(
      labelText: widget.label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: Sizes.sm),
    );
    var fieldWidget = DropdownButtonFormField<T>(
      initialValue: selectedValue,
      isExpanded: !widget.inline,
      decoration: widget.inline ? inlineDecoration : null,
      items: widget.items.map<DropdownMenuItem<T>>((value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(
            widget.getItemLabel(value),
            style: const TextStyle(
              fontSize: 16,
              color: ThemeColors.blackText,
              fontWeight: FontWeight.w600,
            ),
          ).padding(left: 10),
        );
      }).toList(),
      onChanged: (T? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
      },
    );

    if (widget.inline) {
      return fieldWidget;
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty) ...[labelWidget],
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: ThemeColors.darkGray, width: 1),
            ),
            child: fieldWidget,
          ),
        ],
      );
    }
  }
}

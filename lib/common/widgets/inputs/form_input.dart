// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../../../core/theme/theme_colors.dart';
import '../../../core/theme/theme_styles.dart';
import 'labeled_field.dart';

class FormInput extends StatefulWidget {
  final String label;
  final String hint;
  final String error;
  final TextEditingController? controller;
  final TextInputType type;
  final AutovalidateMode? validationMode;
  final bool? isReadOnly;
  final bool? isLight;
  final bool? isEnabled;
  final bool? executeValueChange;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final Function()? onClear;
  final Widget? prefix;
  final Widget? suffix;
  final bool isPassword;
  final bool showBoarder;
  final double bdRadius;
  final int maxInput;
  final String? initialValue;
  final TextInputAction next;
  final FocusNode? focus;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? inputPadding;
  final EdgeInsetsGeometry? margin;
  final List<TextInputFormatter> inputFormatters;
  final BorderRadius borderRadius;
  final bool showClearButton;
  final bool inline;

  const FormInput({
    super.key,
    this.label = '',
    this.hint = '',
    this.error = '',
    this.type = TextInputType.text,
    this.controller,
    this.validationMode = AutovalidateMode.disabled,
    this.isReadOnly = false,
    this.isLight = false,
    this.isEnabled = true,
    this.executeValueChange = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onTap,
    this.prefix,
    this.suffix,
    this.isPassword = false,
    this.showBoarder = true,
    this.bdRadius = 10,
    this.maxInput = 20000,
    this.next = TextInputAction.next,
    this.focus,
    this.padding = const EdgeInsets.only(left: 5, top: 5, bottom: 10),
    this.inputPadding,
    this.initialValue,
    this.borderRadius = const BorderRadius.all(Radius.circular(Sizes.sm)),
    this.margin = const EdgeInsets.symmetric(horizontal: 10),
    this.inputFormatters = const [],
    this.showClearButton = true,
    this.inline = true,
  });

  @override
  FormInputState createState() => FormInputState();
}

class FormInputState extends State<FormInput> {
  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _clearText() {
    if (widget.controller != null) {
      widget.controller!.clear();
    } else {
      widget.onClear?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color foreColor = widget.isLight! ? Colors.white : ThemeColors.blackText;
    var inlineDecoration = InputDecoration(
      labelText: widget.label,
      prefixIcon: widget.prefix,
      hintText: widget.hint,
      hintStyle: const TextStyle(fontSize: 14),
      suffix: widget.suffix,
      suffixIcon: widget.isPassword
          ? IconButton(
              onPressed: _togglePasswordVisibility,
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
                color: foreColor,
              ),
            )
          : (widget.showClearButton || !widget.isReadOnly!
              ? IconButton(
                  onPressed: _clearText,
                  icon: Icon(Icons.clear, color: foreColor),
                )
              : null),
      labelStyle: TextStyle(fontSize: 16, /*color: foreColor*/),
      isDense: false,
      contentPadding: widget.inputPadding ??
          const EdgeInsets.symmetric(horizontal: Sizes.m, vertical: Sizes.xs),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.bdRadius),
        borderSide: BorderSide(
            color: widget.isReadOnly!
                ? Colors.grey
                : (widget.showBoarder ? foreColor : Colors.white)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.bdRadius),
        borderSide:
            BorderSide(color: widget.showBoarder ? foreColor : Colors.white),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.bdRadius),
      ),
      focusColor: widget.isReadOnly!
          ? Colors.grey
          : (widget.showBoarder ? foreColor : Colors.white),
    );

    var fieldWidget = TextFormField(
      controller: widget.controller,
      keyboardType: widget.type,
      obscureText: widget.isPassword ? _isObscured : false,
      autovalidateMode: widget.validationMode,
      validator: widget.validator,
      enabled: widget.isEnabled,
      initialValue: widget.initialValue,
      readOnly: widget.isReadOnly!,
      onTap: widget.onTap,
      textInputAction: widget.next,
      inputFormatters: [
        ...widget.inputFormatters,
        LengthLimitingTextInputFormatter(widget.maxInput),
      ],
      decoration: widget.inline ? inlineDecoration : null,
      style: TextStyle(
          fontSize: 18,
          // color: widget.isReadOnly! ? ThemeColors.primaryDark : foreColor),
      ),
      onChanged: widget.onChanged,
      focusNode: widget.focus,
      onFieldSubmitted: widget.onSubmitted,
    );

    return LabeledField(
      label: widget.label,
      field: fieldWidget,
      borderRadius: widget.borderRadius,
      inline: widget.inline,
    );
  }
}

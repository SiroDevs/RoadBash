// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../layout/retro_sizes.dart';
import 'retro_style.dart';

class RetroField extends StatefulWidget {
  const RetroField({
    super.key,
    required this.controller,
    required this.label,
    this.secret = false,
    this.maxLength,
    this.maxLines = 1,
    this.autofocus = false,
    this.onSubmitted,
    this.action = TextInputAction.next,
  });

  final TextEditingController controller;
  final String label;
  final bool secret;
  final int? maxLength;
  final int maxLines;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction action;

  @override
  State<RetroField> createState() => _RetroFieldState();
}

class _RetroFieldState extends State<RetroField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final s = context.sizes;
    return TextField(
      controller: widget.controller,
      obscureText: widget.secret && _hidden,
      enableSuggestions: !widget.secret,
      autocorrect: !widget.secret,
      maxLength: widget.maxLength,
      maxLines: widget.secret ? 1 : widget.maxLines,
      minLines: 1,
      autofocus: widget.autofocus,
      textInputAction: widget.action,
      onSubmitted: widget.onSubmitted,
      cursorColor: Retro.orange,
      style: TextStyle(color: Colors.white, fontSize: s.body),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: Retro.dim, fontSize: s.small),
        floatingLabelStyle: const TextStyle(color: Retro.orange),
        counterStyle: const TextStyle(color: Retro.dim),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Retro.dim),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Retro.orange),
        ),
        suffixIcon: widget.secret
            ? IconButton(
                icon: Icon(
                  _hidden ? Icons.visibility_off : Icons.visibility,
                  color: Retro.dim,
                ),
                onPressed: () => setState(() => _hidden = !_hidden),
              )
            : null,
      ),
    );
  }
}

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../layout/retro_sizes.dart';
import 'retro_controls.dart';
import 'retro_field.dart';

/// Text field with a send button; clears itself once [onSend] returns true.
class RetroSendBox extends StatefulWidget {
  const RetroSendBox({
    super.key,
    required this.label,
    required this.sendLabel,
    required this.onSend,
    this.maxLines = 3,
    this.maxLength = 1000,
  });

  final String label;
  final String sendLabel;
  final Future<bool> Function(String text) onSend;
  final int maxLines;
  final int maxLength;

  @override
  State<RetroSendBox> createState() => _RetroSendBoxState();
}

/// State for [RetroSendBox]; owns the text controller.
class _RetroSendBoxState extends State<RetroSendBox> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  /// Sends the text and clears the field when it was accepted.
  Future<void> _send() async {
    final sent = await widget.onSend(_text.text);
    if (sent && mounted) _text.clear();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RetroField(
          controller: _text,
          label: widget.label,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          action: TextInputAction.newline,
        ),
        SizedBox(height: sizes.gapSmall),
        RetroButton(widget.sendLabel, onTap: _send),
      ],
    );
  }
}

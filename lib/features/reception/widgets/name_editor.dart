// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../common/widgets/retro/retro_style.dart';
import '../../../l10n/l10n_extension.dart';
import '../../settings/cubit/settings_cubit.dart';

class NameEditor extends StatefulWidget {
  const NameEditor({super.key});

  @override
  State<NameEditor> createState() => _NameEditorState();
}

class _NameEditorState extends State<NameEditor> {
  late final _controller = TextEditingController(
    text: context.read<SettingsCubit>().state.profile.name,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.nameHint, style: retroBody()),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          maxLength: 12,
          style: const TextStyle(color: Colors.white, fontSize: 24),
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Retro.dim)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Retro.orange)),
            counterStyle: TextStyle(color: Retro.dim),
          ),
          onChanged: (v) => context.read<SettingsCubit>().setName(v.trim()),
        ),
      ],
    );
  }
}

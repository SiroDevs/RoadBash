// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../l10n/l10n_extension.dart';

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
        Text(
          context.l10n.nameHint,
          style: retroBody(size: context.sizes.small),
        ),
        SizedBox(height: context.sizes.gap * 0.75),
        TextField(
          controller: _controller,
          maxLength: 12,
          style: TextStyle(color: Colors.white, fontSize: context.sizes.body),
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

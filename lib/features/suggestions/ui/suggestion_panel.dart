// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/l10n/l10n_extension.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/controls/retro_controls.dart';
import '../../../common/widgets/retro/controls/retro_field.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/di/injectable.dart';
import '../../../domain/models/suggestion.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../cubit/suggestion_cubit.dart';

/// Panel for sending a suggestion and, for admins, reading the inbox.
class SuggestionPanel extends StatelessWidget {
  const SuggestionPanel({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SuggestionCubit>()..loadInbox(),
    child: BlocBuilder<SuggestionCubit, SuggestionState>(
      builder: (context, st) =>
          st.admin ? _Inbox(state: st) : _Form(state: st),
    ),
  );
}

/// Returns the localized text for a suggestion error.
String? _errorText(AppLocalizations l10n, SuggestionError? error) =>
    switch (error) {
      null => null,
      SuggestionError.tooShort => l10n.suggestionTooShort,
      SuggestionError.rateLimited => l10n.suggestionRateLimited,
      SuggestionError.signIn => l10n.suggestionSignIn,
      SuggestionError.network => l10n.errNetwork,
    };

/// Form for typing and sending a suggestion.
class _Form extends StatefulWidget {
  const _Form({required this.state});

  final SuggestionState state;

  @override
  State<_Form> createState() => _FormState();
}

/// State for [_Form]; owns the text controller.
class _FormState extends State<_Form> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final st = widget.state;
    final error = _errorText(l10n, st.error);
    return BlocListener<SuggestionCubit, SuggestionState>(
      listenWhen: (a, b) => b.sent,
      listener: (_, __) => _text.clear(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.suggestionHint, style: retroBody(size: sizes.small)),
          SizedBox(height: sizes.gap),
          RetroField(
            controller: _text,
            label: l10n.suggestionLabel,
            maxLength: 1000,
            maxLines: 5,
            action: TextInputAction.newline,
          ),
          if (error != null)
            Text(error, style: retroBody(size: sizes.small, color: Retro.red)),
          if (st.sent)
            Text(
              l10n.suggestionThanks,
              style: retroBody(size: sizes.small, color: Colors.lightGreenAccent),
            ),
          if (st.busy) const LinearProgressIndicator(color: Retro.orange),
          SizedBox(height: sizes.gap),
          RetroButton(
            l10n.suggestionSend,
            onTap: () {
              if (!st.busy) context.read<SuggestionCubit>().send(_text.text);
            },
          ),
        ],
      ),
    );
  }
}

/// List of received suggestions for admins.
class _Inbox extends StatelessWidget {
  const _Inbox({required this.state});

  final SuggestionState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final error = _errorText(l10n, state.error);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.suggestionInbox, style: retroBody(size: sizes.body, color: Retro.yellow)),
        SizedBox(height: sizes.gap),
        RetroButton(
          l10n.commonRefresh,
          onTap: context.read<SuggestionCubit>().loadInbox,
        ),
        SizedBox(height: sizes.gap),
        if (error != null)
          Text(error, style: retroBody(size: sizes.small, color: Retro.red)),
        if (state.busy) const LinearProgressIndicator(color: Retro.orange),
        if (!state.busy && state.inbox.isEmpty && error == null)
          Text(l10n.suggestionInboxEmpty, style: retroBody(size: sizes.small)),
        for (final item in state.inbox) _tile(context, item),
      ],
    );
  }

  /// Builds one suggestion entry with its date.
  Widget _tile(BuildContext context, Suggestion item) {
    final sizes = context.sizes;
    final when = DateFormat('d MMM, HH:mm').format(item.createdAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${item.playerName}  ·  $when',
          style: retroBody(size: sizes.caption, color: Retro.orange),
        ),
        SizedBox(height: sizes.gapSmall * 0.5),
        Text(item.message, style: retroBody(size: sizes.small)),
      ],
    )
        .padding(all: sizes.gap)
        .decorated(
          color: const Color(0x66000000),
          borderRadius: BorderRadius.circular(10),
        )
        .padding(bottom: sizes.gapSmall);
  }
}

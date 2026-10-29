// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/l10n/l10n_extension.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/controls/retro_controls.dart';
import '../../../common/widgets/retro/controls/retro_field.dart';
import '../../../common/widgets/retro/page/retro_page.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/sign_in_cubit.dart';
import 'anonymous_warning.dart';
import 'sign_in_texts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final _name = TextEditingController(text: _savedName());
  final _answer = TextEditingController();
  final _confirm = TextEditingController();
  final _question = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _answer.dispose();
    _confirm.dispose();
    _question.dispose();
    super.dispose();
  }

  String _savedName() {
    final saved = context.read<SettingsCubit>().state.profile.name;
    return saved == AppConstants.anonymousName ? '' : saved;
  }
  void _clear() {
    _answer.clear();
    _confirm.clear();
    _question.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, auth) {
        if (auth.isSignedIn) context.goNamed(RouteNames.menu);
      },
      child: RetroPage(
        child: ResponsiveScrollBody(
          child: BlocConsumer<SignInCubit, SignInState>(
            listenWhen: (a, b) => a.stage != b.stage,
            listener: (_, __) => _clear(),
            builder: (context, st) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RetroTitle(l10n.signInTitle),
                SizedBox(height: sizes.gap),
                _panel(context, st),
              ],
            ).constrained(maxWidth: 560).center(),
          ),
        ),
      ),
    );
  }

  Widget _panel(BuildContext context, SignInState st) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final cubit = context.read<SignInCubit>();
    final error = l10n.signInErrorText(st);
    final gap = SizedBox(height: sizes.gap);
    final children = <Widget>[
      Text(l10n.signInHint(st), style: retroBody(size: sizes.small)),
      gap,
      ...switch (st.stage) {
        SignInStage.name => [
          RetroField(
            controller: _name,
            label: l10n.signInNameLabel,
            maxLength: 12,
            autofocus: true,
            action: TextInputAction.done,
            onSubmitted: cubit.submitName,
          ),
        ],
        SignInStage.answer || SignInStage.challenge => [
          Text(
            st.stage == SignInStage.answer
                ? st.question
                : l10n.signInChallengeQuestion,
            style: retroBody(size: sizes.body, color: Retro.yellow),
          ),
          gap,
          RetroField(
            controller: _answer,
            label: l10n.signInAnswerLabel,
            secret: true,
            autofocus: true,
            action: TextInputAction.done,
            onSubmitted: st.stage == SignInStage.answer
                ? cubit.submitAnswer
                : cubit.submitChallenge,
          ),
        ],
        SignInStage.create => [
          RetroField(
            controller: _question,
            label: l10n.signInQuestionLabel,
            maxLength: 80,
          ),
          SizedBox(height: sizes.gapSmall),
          RetroField(
            controller: _answer,
            label: l10n.signInAnswerLabel,
            secret: true,
          ),
          SizedBox(height: sizes.gap),
          RetroField(
            controller: _confirm,
            label: l10n.signInConfirmLabel,
            secret: true,
            action: TextInputAction.done,
            onSubmitted: (_) => _create(cubit),
          ),
        ],
      },
      if (error != null) ...[
        gap,
        Text(error, style: retroBody(size: sizes.small, color: Retro.red)),
      ],
      if (st.busy) ...[
        gap,
        const LinearProgressIndicator(color: Retro.orange),
      ],
      gap,
      _actions(context, st),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ).padding(all: sizes.gap * 1.2).decorated(
      color: Retro.panel,
      borderRadius: BorderRadius.circular(16),
    );
  }

  void _create(SignInCubit cubit) => cubit.submitCreate(
    question: _question.text,
    answer: _answer.text,
    confirm: _confirm.text,
  );

  Widget _actions(BuildContext context, SignInState st) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final cubit = context.read<SignInCubit>();
    void guarded(VoidCallback action) {
      if (!st.busy) action();
    }
    return Wrap(
      spacing: sizes.gap * 0.75,
      runSpacing: sizes.gap * 0.75,
      children: [
        if (st.stage != SignInStage.name)
          RetroButton(l10n.commonBack, onTap: () => guarded(cubit.back)),
        RetroButton(
          switch (st.stage) {
            SignInStage.name || SignInStage.challenge => l10n.signInContinue,
            SignInStage.answer => l10n.signInStart,
            SignInStage.create => l10n.signInCreate,
          },
          onTap: () => guarded(() {
            switch (st.stage) {
              case SignInStage.name:
                cubit.submitName(_name.text);
              case SignInStage.answer:
                cubit.submitAnswer(_answer.text);
              case SignInStage.challenge:
                cubit.submitChallenge(_answer.text);
              case SignInStage.create:
                _create(cubit);
            }
          }),
        ),
        if (st.stage == SignInStage.name)
          RetroButton(
            l10n.signInAnonymous,
            onTap: () => confirmAnonymous(context, cubit.playAnonymously),
          ),
      ],
    );
  }
}

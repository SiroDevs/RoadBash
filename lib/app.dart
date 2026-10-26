// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'core/router/app_router.dart';
import 'common/widgets/text_scale_factor.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/audio/cubit/audio_cubit.dart';
import 'core/audio/sound_player.dart';
import 'core/di/injectable.dart';
import 'features/progress/cubit/progress_cubit.dart';
import 'features/settings/cubit/settings_cubit.dart';
import 'common/theme/theme_data.dart';
import 'l10n/gen/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const AppView();
}

class AppView extends StatefulWidget {
  final GoRouter? router;
  const AppView({super.key, this.router});

  @override
  State<AppView> createState() => AppViewState();
}

class AppViewState extends State<AppView> {
  late final GoRouter _router = widget.router ?? AppRouter.create();

  @override
  void dispose() {
    if (widget.router == null) _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<SettingsCubit>()),
        BlocProvider.value(value: getIt<ProgressCubit>()),
        BlocProvider.value(value: getIt<AudioCubit>()),
        BlocProvider.value(value: getIt<AuthCubit>()),
      ],
      child: RepositoryProvider<SoundPlayer>.value(
        value: getIt<AudioCubit>(),
        child: Builder(
          builder: (context) {
            final language = context.select<SettingsCubit, String>(
              (c) => c.state.profile.language,
            );
            return MaterialApp.router(
              locale: language.isEmpty ? null : Locale(language),
              routerConfig: _router,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              supportedLocales: const [Locale('en'), Locale('sw')],
              debugShowCheckedModeBanner: false,
              builder: (context, child) =>
                  TextScaleFactor(child: child ?? const SizedBox.shrink()),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }
}

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'common/app_router/app_router.dart';
import 'common/widgets/text_scale_factor.dart';
import 'core/audio/cubit/audio_cubit.dart';
import 'core/di/injectable.dart';
import 'core/progress/progress_cubit.dart';
import 'core/settings/settings_cubit.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/theme_data.dart';
import 'domain/repos/prefs_repo.dart';
import 'l10n/app_localizations.dart';

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
    final prefsRepo = getIt<PrefsRepo>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider.value(value: getIt<SettingsCubit>()),
        BlocProvider.value(value: getIt<ProgressCubit>()),
        BlocProvider.value(value: getIt<AudioCubit>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            routerConfig: _router,
            themeMode: prefsRepo.getThemeMode(),
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
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'RoadBash'**
  String get appName;

  /// Feedback label
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// Studio line on the title screen
  ///
  /// In en, this message translates to:
  /// **'{studio} presents'**
  String splashPresents(String studio);

  /// Tagline on the title screen
  ///
  /// In en, this message translates to:
  /// **'Bring back the vibes'**
  String get splashTagline;

  /// Copyright line on the title screen
  ///
  /// In en, this message translates to:
  /// **'{credits}. All rights reserved.'**
  String splashRights(String credits);

  /// Heading of the ride-safe notice
  ///
  /// In en, this message translates to:
  /// **'Road Bash™ PC\n© 2026 Siro Devs and Okiang\'o'**
  String get noticeTitle;

  /// First notice paragraph
  ///
  /// In en, this message translates to:
  /// **'I hope you find Road Bash as entertaining as I do. Games are a great way to act out fantasies in a virtual environment where no one gets hurt.\n\nThe game is meant for entertaining purposes only. Events in the game and in the video are fantasy and are not meant to model reality in any way.'**
  String get noticeFun;

  /// Safety warning paragraph
  ///
  /// In en, this message translates to:
  /// **'In the real world, if you run from the police you\'ll got to jail; if you ride recklessly and fall off your bike, you might not get back up. There\'s only one place for racing: a closed-circuit race track. There\'s only one way to ride: within the limits of your abilities and with full protective gear. Use your head.'**
  String get noticeWarning;

  /// Hint to continue
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get tapToContinue;

  /// Name of the city scene
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get sceneCity;

  /// Name of the suburbs scene
  ///
  /// In en, this message translates to:
  /// **'Suburbs'**
  String get sceneSuburbs;

  /// Name of the settings desk
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get receptionTitle;

  /// City description
  ///
  /// In en, this message translates to:
  /// **'Downtown streets, steep hills and walls of glass. Hold your line between the kerbs.'**
  String get blurbCity;

  /// Suburbs description
  ///
  /// In en, this message translates to:
  /// **'Rolling hills and sweeping bends at the edge of town. Fast, flowing and easy to run wide.'**
  String get blurbSuburbs;

  /// Reception description
  ///
  /// In en, this message translates to:
  /// **'Pop in to set your rider name, mix the sound and check the controls.'**
  String get blurbReception;

  /// Race length
  ///
  /// In en, this message translates to:
  /// **'Length: {km} km, {laps} laps'**
  String lengthLabel(String km, int laps);

  /// Player level
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabel(int level);

  /// Best time on a scene
  ///
  /// In en, this message translates to:
  /// **'Best {time}'**
  String bestTimeLabel(String time);

  /// Shown before the first race
  ///
  /// In en, this message translates to:
  /// **'No time yet'**
  String get noTimeYet;

  /// Race and win counts
  ///
  /// In en, this message translates to:
  /// **'{races} races, {wins} wins'**
  String racesWinsLabel(int races, int wins);

  /// Start button
  ///
  /// In en, this message translates to:
  /// **'Start race'**
  String get startRace;

  /// Enter button
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enterLabel;

  /// Name used until the player sets one
  ///
  /// In en, this message translates to:
  /// **'Player 1'**
  String get defaultPlayerName;

  /// Results heading
  ///
  /// In en, this message translates to:
  /// **'Race Results'**
  String get resultsTitle;

  /// Race again button
  ///
  /// In en, this message translates to:
  /// **'Race again'**
  String get raceAgain;

  /// Back to menu button
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get backToMenu;

  /// Shown on a personal best
  ///
  /// In en, this message translates to:
  /// **'New best time!'**
  String get newBestTime;

  /// Reception item
  ///
  /// In en, this message translates to:
  /// **'Player Name'**
  String get receptionName;

  /// Reception item
  ///
  /// In en, this message translates to:
  /// **'Sound Mix'**
  String get receptionSound;

  /// Reception item
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get receptionControls;

  /// Reception item
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get receptionDone;

  /// Name editor hint
  ///
  /// In en, this message translates to:
  /// **'Pick the name shown on your dashboard and in the results.'**
  String get nameHint;

  /// Volume slider
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get volumeMaster;

  /// Volume slider
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get volumeMusic;

  /// Volume slider
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get volumeEngine;

  /// Volume slider
  ///
  /// In en, this message translates to:
  /// **'Effects'**
  String get volumeEffects;

  /// Controls help text
  ///
  /// In en, this message translates to:
  /// **'Hold up (or W) for the throttle. Let go and the bike rolls to a stop.\n\nLeft and right (or A and D) steer. Down, S or Space brakes.\n\nTouch: use the arrows on the left to steer, and the gas and brake pedals on the right.'**
  String get controlsHelp;

  /// Race start banner
  ///
  /// In en, this message translates to:
  /// **'GO!'**
  String get hudGo;

  /// Race finish banner
  ///
  /// In en, this message translates to:
  /// **'FINISH!'**
  String get hudFinish;

  /// Hint when stopped
  ///
  /// In en, this message translates to:
  /// **'Hold the gas to ride'**
  String get hudHoldGas;

  /// Lap counter
  ///
  /// In en, this message translates to:
  /// **'LAP {lap}/{laps}'**
  String hudLap(int lap, int laps);

  /// Speedometer unit
  ///
  /// In en, this message translates to:
  /// **'KM/H'**
  String get hudSpeedUnit;

  /// Rev counter unit
  ///
  /// In en, this message translates to:
  /// **'RPM x1000'**
  String get hudRpmUnit;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Quit race'**
  String get quitRace;

  /// Touch control label
  ///
  /// In en, this message translates to:
  /// **'Steer left'**
  String get touchLeft;

  /// Touch control label
  ///
  /// In en, this message translates to:
  /// **'Steer right'**
  String get touchRight;

  /// Touch control label
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get touchGas;

  /// Touch control label
  ///
  /// In en, this message translates to:
  /// **'Brake'**
  String get touchBrake;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

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
/// import 'gen/app_localizations.dart';
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
  /// **'Road Bash™ 2026'**
  String get noticeTitle;

  /// First notice paragraph
  ///
  /// In en, this message translates to:
  /// **'I developed this game to recreate the childhood memories of the classic Road Rash Game by EA Sports specifically the 1991 version. Games like this are a great way to enjoy virtual realities without the risks of getting hurt.\n\nI hope you enjoy playing this game as I do both developing and playing it. Please share it with your family and friends so that you may not enjoy alone not unless you are greedy.'**
  String get noticeFun;

  /// Safety warning paragraph
  ///
  /// In en, this message translates to:
  /// **'This game is work in progress and because of that it may be having a shitty UI and controls. If you have suggestions or complaints feel free to text me on X or email me on sirodevske@gmail.com.\n\nIf you are a developer head over to my Github @SiroDevs and start contributing. Use your head!'**
  String get noticeWarning;

  /// Hint to continue
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get tapToContinue;

  /// Name of the city scene
  ///
  /// In en, this message translates to:
  /// **'The City'**
  String get sceneCity;

  /// Name of the suburbs scene
  ///
  /// In en, this message translates to:
  /// **'The Suburbs'**
  String get sceneSuburbs;

  /// Name of the Thika Rd scene
  ///
  /// In en, this message translates to:
  /// **'Thika Road'**
  String get sceneThikaRoad;

  /// Name of the jungle scene
  ///
  /// In en, this message translates to:
  /// **'The Jungle'**
  String get sceneJungle;

  /// Name of the dirt road scene
  ///
  /// In en, this message translates to:
  /// **'Dirt Road'**
  String get sceneDirtRoad;

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

  /// Thika Rd description
  ///
  /// In en, this message translates to:
  /// **'Blue Post to Museum Hill, the whole Thika Rd run through Juja, Kimbo, Ruiru, Kahawa, Githurai and Roysambu, then down the Pangani underpass. Flyovers, footbridges and slip roads. Keep it clean to the finish.'**
  String get blurbThikaRoad;

  /// Jungle description
  ///
  /// In en, this message translates to:
  /// **'Thick rainforest on a narrow, twisting blacktop. Steep climbs, tight bends and trees right at the edge. Brake early, stay on the tarmac.'**
  String get blurbJungle;

  /// Dirt road description
  ///
  /// In en, this message translates to:
  /// **'Red murram through open dry country. Long straights, rolling crests and wide, dusty bends. No lines to follow, so pick your rut.'**
  String get blurbDirtRoad;

  /// Reception description
  ///
  /// In en, this message translates to:
  /// **'Set your player name, mix the sound, check the controls, pick a language, or see your stats and the leaderboard.'**
  String get blurbReception;

  /// Race length
  ///
  /// In en, this message translates to:
  /// **'Length: {km} km, {laps} laps'**
  String lengthLabel(String km, int laps);

  /// Race length for a one-way scene
  ///
  /// In en, this message translates to:
  /// **'Length: {km} km, one way'**
  String lengthOneWayLabel(String km);

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

  /// Small badge on the scene the player has raced most
  ///
  /// In en, this message translates to:
  /// **'Most played'**
  String get mostPlayed;

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
  /// **'Hold up (or W) for the throttle. Let go and the bike rolls to a stop.\n\nLeft and right (or A and D) steer. Down or S brakes, and Space pauses.\n\nPhones and tablets: hold either handlebar (GAS) to ride and release both to brake. Drag either handlebar to turn: right bar down (left bar up) steers right, left bar down (right bar up) steers left. Use Boost and Attack in the accessory row below the dashboard while moving; Attack unlocks in level 4.\n\nController: left stick or D-pad steers, RT accelerates, LT brakes, A/Cross attacks (level 4+), X/Square boosts, and Start pauses.\n\nYou can also tilt the device like a steering wheel, or switch on Use Screentouch in the race controls menu (top right) to steer with the handlebars only.'**
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

  /// Label printed on both handlebar grips
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get hudGasLabel;

  /// Label for the attack accessory control
  ///
  /// In en, this message translates to:
  /// **'HIT'**
  String get hudAttackLabel;

  /// Label for the boost accessory control
  ///
  /// In en, this message translates to:
  /// **'BOOST'**
  String get hudBoostLabel;

  /// Label for an empty accessory item slot
  ///
  /// In en, this message translates to:
  /// **'ITEM'**
  String get hudItemLabel;

  /// Accessible label for an empty accessory item slot
  ///
  /// In en, this message translates to:
  /// **'Empty item slot {slot}'**
  String hudItemSlot(int slot);

  /// Lap counter
  ///
  /// In en, this message translates to:
  /// **'LAP {lap}/{laps}'**
  String hudLap(int lap, int laps);

  /// Kilometres left on a scene without laps
  ///
  /// In en, this message translates to:
  /// **'-{km} KM'**
  String hudRemaining(String km);

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

  /// Warning shown while a cop chases the player
  ///
  /// In en, this message translates to:
  /// **'POLICE!'**
  String get hudPolice;

  /// Shown while the cop is arresting the player
  ///
  /// In en, this message translates to:
  /// **'PULL OVER!'**
  String get hudPullOver;

  /// Banner and title when the player is arrested
  ///
  /// In en, this message translates to:
  /// **'BUSTED!'**
  String get hudBusted;

  /// Results text after an arrest
  ///
  /// In en, this message translates to:
  /// **'A cop caught up with you. Race over.'**
  String get bustedNote;

  /// Fine after an arrest
  ///
  /// In en, this message translates to:
  /// **'Fine: KSh {amount}'**
  String bustedFine(String amount);

  /// Banner and title after a nasty crash
  ///
  /// In en, this message translates to:
  /// **'CRASHED!'**
  String get hudCrashed;

  /// Results text after a nasty crash
  ///
  /// In en, this message translates to:
  /// **'You went down at {kmh} km/h and did not get up. Race over.'**
  String crashedNote(int kmh);

  /// Hospital bill after a nasty crash
  ///
  /// In en, this message translates to:
  /// **'Hospital: {amount}'**
  String crashHospital(String amount);

  /// Garage bill after a nasty crash
  ///
  /// In en, this message translates to:
  /// **'Garage: {amount}'**
  String crashGarage(String amount);

  /// Prize money line on the results screen
  ///
  /// In en, this message translates to:
  /// **'Prize: {amount}'**
  String resultsPrize(String amount);

  /// Wallet balance line on the results screen
  ///
  /// In en, this message translates to:
  /// **'Wallet: {amount}'**
  String resultsWallet(String amount);

  /// A wallet amount in shillings
  ///
  /// In en, this message translates to:
  /// **'KSh {amount}'**
  String walletAmount(String amount);

  /// A negative wallet amount in shillings
  ///
  /// In en, this message translates to:
  /// **'-KSh {amount}'**
  String walletDebt(String amount);

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Quit race'**
  String get quitRace;

  /// Left handlebar label
  ///
  /// In en, this message translates to:
  /// **'Left handlebar, GAS: hold to ride; drag down to steer left, up to steer right'**
  String get handlebarLeft;

  /// Right handlebar label
  ///
  /// In en, this message translates to:
  /// **'Right handlebar, GAS: hold to ride; release both grips to brake, drag down to steer right'**
  String get handlebarRight;

  /// Controls menu title
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get controlsTitle;

  /// Shown while the race is paused
  ///
  /// In en, this message translates to:
  /// **'Race paused'**
  String get racePaused;

  /// Resume button label
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get raceResume;

  /// Switch label for on-screen steering
  ///
  /// In en, this message translates to:
  /// **'Use Screentouch'**
  String get useScreenTouch;

  /// Hint under the screentouch switch
  ///
  /// In en, this message translates to:
  /// **'Steer with the on-screen handlebars only, without tilting (phones and tablets)'**
  String get useScreenTouchHint;

  /// Mute switch label
  ///
  /// In en, this message translates to:
  /// **'Mute Sound'**
  String get muteSound;

  /// Unmute button tooltip
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmuteSound;

  /// Music switch label
  ///
  /// In en, this message translates to:
  /// **'Play Music'**
  String get playMusic;

  /// Sound effects switch label
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// Engine sound switch label
  ///
  /// In en, this message translates to:
  /// **'Engine Sound'**
  String get engineSound;

  /// Invert tilt switch label
  ///
  /// In en, this message translates to:
  /// **'Invert Tilt'**
  String get invertTilt;

  /// Hint under the invert tilt switch
  ///
  /// In en, this message translates to:
  /// **'Flip left and right if tilt steering feels reversed'**
  String get invertTiltHint;

  /// Language tab label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// Language tab hint
  ///
  /// In en, this message translates to:
  /// **'Pick the language the game is shown in'**
  String get languageHint;

  /// Exit tab and button label
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitLabel;

  /// Exit tab description
  ///
  /// In en, this message translates to:
  /// **'Wimp out and go home'**
  String get exitHint;

  /// Pause button tooltip
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseRace;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// Refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// Sign-in heading
  ///
  /// In en, this message translates to:
  /// **'Who\'s riding?'**
  String get signInTitle;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Rider name'**
  String get signInNameLabel;

  /// Name step hint
  ///
  /// In en, this message translates to:
  /// **'Enter your rider name to play: 3 to 12 letters, numbers, spaces or underscores.'**
  String get signInNameHint;

  /// New name hint
  ///
  /// In en, this message translates to:
  /// **'{name} is free. Set a security question and answer to protect it. You will need the answer every time you come back.'**
  String signInNewHint(String name);

  /// Existing name hint
  ///
  /// In en, this message translates to:
  /// **'Welcome back {name}. Answer your security question to ride.'**
  String signInAnswerHint(String name);

  /// Reserved name hint
  ///
  /// In en, this message translates to:
  /// **'{name} is a reserved name. Answer this to claim it:'**
  String signInChallengeHint(String name);

  /// Reserved name question
  ///
  /// In en, this message translates to:
  /// **'Do you know when this game was first written?'**
  String get signInChallengeQuestion;

  /// Security question field
  ///
  /// In en, this message translates to:
  /// **'Your security question'**
  String get signInQuestionLabel;

  /// Answer field
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get signInAnswerLabel;

  /// Repeat answer field
  ///
  /// In en, this message translates to:
  /// **'Repeat the answer'**
  String get signInConfirmLabel;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get signInContinue;

  /// Create player button
  ///
  /// In en, this message translates to:
  /// **'Create player'**
  String get signInCreate;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Let\'s ride'**
  String get signInStart;

  /// Anonymous button
  ///
  /// In en, this message translates to:
  /// **'Play anonymously'**
  String get signInAnonymous;

  /// Invalid name
  ///
  /// In en, this message translates to:
  /// **'Use 3 to 12 letters, numbers, spaces or underscores.'**
  String get errInvalidName;

  /// Wrong answer
  ///
  /// In en, this message translates to:
  /// **'Wrong answer. {remaining} tries left.'**
  String errWrongAnswer(int remaining);

  /// Locked
  ///
  /// In en, this message translates to:
  /// **'Too many wrong answers. Try again in {minutes} min.'**
  String errLocked(int minutes);

  /// Network error
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection.'**
  String get errNetwork;

  /// Backend missing
  ///
  /// In en, this message translates to:
  /// **'Online services are not set up in this build.'**
  String get errNotConfigured;

  /// Name taken
  ///
  /// In en, this message translates to:
  /// **'That name was just taken. Pick another.'**
  String get errNameTaken;

  /// Wrong challenge
  ///
  /// In en, this message translates to:
  /// **'Wrong answer. {remaining} tries left.'**
  String errWrongChallenge(int remaining);

  /// Bad question
  ///
  /// In en, this message translates to:
  /// **'The question needs 5 to 80 characters.'**
  String get errInvalidQuestion;

  /// Bad answer
  ///
  /// In en, this message translates to:
  /// **'The answer needs 2 to 60 characters.'**
  String get errInvalidAnswer;

  /// Answers differ
  ///
  /// In en, this message translates to:
  /// **'The two answers do not match.'**
  String get errMismatch;

  /// Generic error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errGeneric;

  /// Account line
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name}'**
  String accountSignedInAs(String name);

  /// Anonymous account line
  ///
  /// In en, this message translates to:
  /// **'Playing anonymously. Sign in to be counted on the leaderboard.'**
  String get accountAnonymous;

  /// Admin badge
  ///
  /// In en, this message translates to:
  /// **'Admin: you run the boardroom.'**
  String get accountAdmin;

  /// Switch player button
  ///
  /// In en, this message translates to:
  /// **'Switch player'**
  String get switchPlayer;

  /// Reception item
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get receptionStats;

  /// Reception item
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get receptionLeaderboard;

  /// Stats heading
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsTitle;

  /// Online line
  ///
  /// In en, this message translates to:
  /// **'Online now: {online} ({players} players)'**
  String statsOnlineLine(int online, int players);

  /// Highest value shown on a stats chart
  ///
  /// In en, this message translates to:
  /// **'Max {peak}'**
  String statsPeak(int peak);

  /// Visitors label
  ///
  /// In en, this message translates to:
  /// **'Visitors'**
  String get statsVisitors;

  /// Players label
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get statsPlayers;

  /// Games label
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get statsGames;

  /// All time label
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get statsAllTime;

  /// Range
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statsRangeToday;

  /// Range
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get statsRange7;

  /// Range
  ///
  /// In en, this message translates to:
  /// **'28 days'**
  String get statsRange28;

  /// Range
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get statsRange90;

  /// Range
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get statsRange365;

  /// Heatmap heading
  ///
  /// In en, this message translates to:
  /// **'When people ride'**
  String get statsHeatmapTitle;

  /// Heatmap note
  ///
  /// In en, this message translates to:
  /// **'Rows are days (Monday first), columns are hours of the day in your local time. Brighter means busier.'**
  String get statsHeatmapNote;

  /// Heading of the visitor places section
  ///
  /// In en, this message translates to:
  /// **'Where visitors come from'**
  String get statsPlacesTitle;

  /// Tab showing visitors by country
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get statsPlacesCountries;

  /// Tab showing visitors by city
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get statsPlacesCities;

  /// Visitors whose place is not known
  ///
  /// In en, this message translates to:
  /// **'Location unknown: {count}'**
  String statsPlacesUnknown(int count);

  /// No visitor places
  ///
  /// In en, this message translates to:
  /// **'No locations recorded for this period yet.'**
  String get statsPlacesEmpty;

  /// Visitor map note
  ///
  /// In en, this message translates to:
  /// **'Brighter dots mean more visitors. Places are approximate, to about city level, and no addresses are kept.'**
  String get statsPlacesNote;

  /// More countries or places not shown
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String statsPlacesMore(int count);

  /// Leaderboard heading
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardTitle;

  /// Column
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get leaderboardPlayer;

  /// Column
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get leaderboardGames;

  /// Column
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get leaderboardWins;

  /// Empty board
  ///
  /// In en, this message translates to:
  /// **'No races finished yet. Be the first!'**
  String get leaderboardEmpty;

  /// Menu section label
  ///
  /// In en, this message translates to:
  /// **'Scenes'**
  String get menuScenes;

  /// Boardroom title
  ///
  /// In en, this message translates to:
  /// **'Boardroom'**
  String get boardroomTitle;

  /// Boardroom blurb
  ///
  /// In en, this message translates to:
  /// **'Read announcements, send me a suggestion, and join the conversation under the public posts.'**
  String get blurbBoardroom;

  /// Announcements filter strip
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get boardroomAnnouncements;

  /// Suggestions filter strip
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get boardroomSuggestions;

  /// Announcements hint for players
  ///
  /// In en, this message translates to:
  /// **'News from the admins. Reply to join the conversation.'**
  String get boardroomAnnouncementsHint;

  /// Announcements hint for admins
  ///
  /// In en, this message translates to:
  /// **'Post an announcement for everyone. Players can reply under it, and you can delete anything inappropriate.'**
  String get boardroomAdminAnnounceHint;

  /// Boardroom hint
  ///
  /// In en, this message translates to:
  /// **'Tell me what to fix, add or remove. Suggestions stay private until an admin makes them public.'**
  String get boardroomHint;

  /// Boardroom admin hint
  ///
  /// In en, this message translates to:
  /// **'Reply to suggestions, make them public or delete what is not appropriate.'**
  String get boardroomAdminHint;

  /// Leaderboard tab
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get leaderboardThisWeek;

  /// Leaderboard tab
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get leaderboardLastWeek;

  /// Leaderboard tab
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get leaderboardAllTime;

  /// Dates a weekly leaderboard covers
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String leaderboardRange(String from, String to);

  /// Suggestion field
  ///
  /// In en, this message translates to:
  /// **'Your suggestion'**
  String get boardroomSuggestionLabel;

  /// Announcement field
  ///
  /// In en, this message translates to:
  /// **'Your announcement'**
  String get boardroomAnnouncementLabel;

  /// Send suggestion button
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get boardroomSend;

  /// Post announcement button
  ///
  /// In en, this message translates to:
  /// **'Announce'**
  String get boardroomAnnounce;

  /// Empty boardroom
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get boardroomEmpty;

  /// Reply button
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get boardroomReply;

  /// Reply field
  ///
  /// In en, this message translates to:
  /// **'Your reply'**
  String get boardroomReplyLabel;

  /// Make a suggestion public
  ///
  /// In en, this message translates to:
  /// **'Make public'**
  String get boardroomMakePublic;

  /// Make a suggestion private
  ///
  /// In en, this message translates to:
  /// **'Make private'**
  String get boardroomMakePrivate;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get boardroomDelete;

  /// Delete dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete this?'**
  String get boardroomDeleteTitle;

  /// Delete dialog body
  ///
  /// In en, this message translates to:
  /// **'It will be removed for everyone, together with any replies under it.'**
  String get boardroomDeleteBody;

  /// Admin tag
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get boardroomAdminTag;

  /// Announcement tag
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get boardroomAnnouncementTag;

  /// Public tag
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get boardroomPublicTag;

  /// Private tag
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get boardroomPrivateTag;

  /// Sign in error
  ///
  /// In en, this message translates to:
  /// **'Sign in to use the boardroom.'**
  String get boardroomSignIn;

  /// Too short error
  ///
  /// In en, this message translates to:
  /// **'Write a few more words.'**
  String get boardroomTooShort;

  /// Rate limit error
  ///
  /// In en, this message translates to:
  /// **'That is enough for now. Try again in a while.'**
  String get boardroomRateLimited;

  /// Forbidden error
  ///
  /// In en, this message translates to:
  /// **'Only admins can do that.'**
  String get boardroomForbidden;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Anonymous warning title
  ///
  /// In en, this message translates to:
  /// **'Play anonymously?'**
  String get anonymousWarningTitle;

  /// Anonymous warning body
  ///
  /// In en, this message translates to:
  /// **'You will ride as AnonPlayer. Your games will not be recorded, so you will not appear on our leaderboard. Sign in with a name if you want to be counted.'**
  String get anonymousWarningBody;

  /// Anonymous warning confirm
  ///
  /// In en, this message translates to:
  /// **'Play anyway'**
  String get anonymousWarningConfirm;

  /// Players online badge
  ///
  /// In en, this message translates to:
  /// **'{count} online'**
  String menuOnline(int count);

  /// Shown when a win unlocks the next level
  ///
  /// In en, this message translates to:
  /// **'Level up! You are now Level {level}.'**
  String levelUpNote(int level);

  /// Shown for a scene the level has not opened
  ///
  /// In en, this message translates to:
  /// **'Reach Level {level} to unlock this scene'**
  String sceneLocked(int level);

  /// Pre-race hint: what it takes to reach the next level
  ///
  /// In en, this message translates to:
  /// **'Win {wins} in a row for Level {level} ({done}/{wins})'**
  String hintNextLevel(int wins, int level, int done);

  /// Pre-race hint at the top level
  ///
  /// In en, this message translates to:
  /// **'Top level. Keep winning!'**
  String get hintTopLevel;

  /// Pre-race hint: scenes the next level opens
  ///
  /// In en, this message translates to:
  /// **'Unlocks: {places}'**
  String hintUnlocks(String places);

  /// Pre-race hint: prize and bonuses
  ///
  /// In en, this message translates to:
  /// **'Win KSh {amount} · best +{best}% · clean +{clean}%'**
  String hintPrize(String amount, int best, int clean);

  /// Pre-race hint on the first level
  ///
  /// In en, this message translates to:
  /// **'Practice level: no prize money'**
  String get hintNoPrize;

  /// Money line: bonus for a new best time
  ///
  /// In en, this message translates to:
  /// **'New best bonus: {amount}'**
  String resultsBestBonus(String amount);

  /// Money line: bonus for not bashing rivals
  ///
  /// In en, this message translates to:
  /// **'Clean race bonus: {amount}'**
  String resultsCleanBonus(String amount);

  /// Money line: fines for hitting traffic
  ///
  /// In en, this message translates to:
  /// **'Traffic fines: {amount}'**
  String resultsTraffic(String amount);

  /// Heading of the traffic offences list on the results screen
  ///
  /// In en, this message translates to:
  /// **'Traffic offences'**
  String get resultsOffencesTitle;

  /// Results line: riding on the wrong side of the road, with how many times
  ///
  /// In en, this message translates to:
  /// **'Riding on the wrong side: {count}'**
  String offenceWrongSide(int count);
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

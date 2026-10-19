// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RoadBash';

  @override
  String get feedback => 'Feedback';

  @override
  String splashPresents(String studio) {
    return '$studio presents';
  }

  @override
  String get splashTagline => 'Bring back the vibes';

  @override
  String splashRights(String credits) {
    return '$credits. All rights reserved.';
  }

  @override
  String get noticeTitle => 'Road Bash™ Game 2026';

  @override
  String get noticeFun =>
      'I developed this game to recreate the childhood memories of the classic Road Rash Game by EA Sports specifically the 1991 version. Games like this are a great way to enjoy virtual realities without the risks of getting hurt.\n\nI hope you enjoy playing this game as I do both developing and playing it. Please share it with your family and friends so that you may not enjoy alone not unless you are greedy.';

  @override
  String get noticeWarning =>
      'This game is work in progress and because of that it may be having a shitty UI and controls. If you have suggestions or complaints feel free to text me on X or email me on sirodevske@gmail.com.\n\nIf you are a developer head over to my Github @SiroDevs and start contributing. Use your head!';

  @override
  String get tapToContinue => 'Tap to continue';

  @override
  String get sceneCity => 'The City';

  @override
  String get sceneSuburbs => 'The Suburbs';

  @override
  String get receptionTitle => 'Reception';

  @override
  String get blurbCity =>
      'Downtown streets, steep hills and walls of glass. Hold your line between the kerbs.';

  @override
  String get blurbSuburbs =>
      'Rolling hills and sweeping bends at the edge of town. Fast, flowing and easy to run wide.';

  @override
  String get blurbReception =>
      'Pop in to set your rider name, mix the sound and check the controls.';

  @override
  String lengthLabel(String km, int laps) {
    return 'Length: $km km, $laps laps';
  }

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String bestTimeLabel(String time) {
    return 'Best $time';
  }

  @override
  String get noTimeYet => 'No time yet';

  @override
  String racesWinsLabel(int races, int wins) {
    return '$races races, $wins wins';
  }

  @override
  String get startRace => 'Start race';

  @override
  String get enterLabel => 'Enter';

  @override
  String get defaultPlayerName => 'Player 1';

  @override
  String get resultsTitle => 'Race Results';

  @override
  String get raceAgain => 'Race again';

  @override
  String get backToMenu => 'Menu';

  @override
  String get newBestTime => 'New best time!';

  @override
  String get receptionName => 'Player Name';

  @override
  String get receptionSound => 'Sound Mix';

  @override
  String get receptionControls => 'Controls';

  @override
  String get receptionDone => 'Done';

  @override
  String get nameHint =>
      'Pick the name shown on your dashboard and in the results.';

  @override
  String get volumeMaster => 'Master';

  @override
  String get volumeMusic => 'Music';

  @override
  String get volumeEngine => 'Engine';

  @override
  String get volumeEffects => 'Effects';

  @override
  String get controlsHelp =>
      'Hold up (or W) for the throttle. Let go and the bike rolls to a stop.\n\nLeft and right (or A and D) steer. Down, S or Space brakes.\n\nTouch: use the arrows on the left to steer, and the gas and brake pedals on the right.';

  @override
  String get hudGo => 'GO!';

  @override
  String get hudFinish => 'FINISH!';

  @override
  String get hudHoldGas => 'Hold the gas to ride';

  @override
  String hudLap(int lap, int laps) {
    return 'LAP $lap/$laps';
  }

  @override
  String get hudSpeedUnit => 'KM/H';

  @override
  String get hudRpmUnit => 'RPM x1000';

  @override
  String get quitRace => 'Quit race';

  @override
  String get touchLeft => 'Steer left';

  @override
  String get touchRight => 'Steer right';

  @override
  String get touchGas => 'Gas';

  @override
  String get touchBrake => 'Brake';
}

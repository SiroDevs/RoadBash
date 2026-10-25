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
  String get noticeTitle => 'Road Bash™ 2026';

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
      'Hold up (or W) for the throttle. Let go and the bike rolls to a stop.\n\nLeft and right (or A and D) steer. Down or S brakes, and Space pauses.\n\nPhones and tablets: hold the gas pedal (bottom right) to ride and the brake pedal (bottom left) to stop. Tilt the device like a steering wheel to turn, or switch on Use Screentouch in the race controls menu (top right) to steer with on-screen arrows.';

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

  @override
  String get controlsTitle => 'Controls';

  @override
  String get racePaused => 'Race paused';

  @override
  String get raceResume => 'Resume';

  @override
  String get useScreenTouch => 'Use Screentouch';

  @override
  String get useScreenTouchHint =>
      'Steer with on-screen arrows instead of tilting (phones and tablets)';

  @override
  String get muteSound => 'Mute Sound';

  @override
  String get unmuteSound => 'Unmute';

  @override
  String get playMusic => 'Play Music';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get engineSound => 'Engine Sound';

  @override
  String get invertTilt => 'Invert Tilt';

  @override
  String get invertTiltHint =>
      'Flip left and right if tilt steering feels reversed';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageHint => 'Pick the language the game is shown in';

  @override
  String get exitLabel => 'Exit';

  @override
  String get exitHint => 'Wimp out and go home';

  @override
  String get pauseRace => 'Pause';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get signInTitle => 'Who\'s riding?';

  @override
  String get signInNameLabel => 'Rider name';

  @override
  String get signInNameHint =>
      'Enter your rider name to play: 3 to 12 letters, numbers, spaces or underscores.';

  @override
  String signInNewHint(String name) {
    return '$name is free. Set a security question and answer to protect it. You will need the answer every time you come back.';
  }

  @override
  String signInAnswerHint(String name) {
    return 'Welcome back $name. Answer your security question to ride.';
  }

  @override
  String signInChallengeHint(String name) {
    return '$name is a reserved name. Answer this to claim it:';
  }

  @override
  String get signInChallengeQuestion =>
      'Do you know when this game was first written?';

  @override
  String get signInQuestionLabel => 'Your security question';

  @override
  String get signInAnswerLabel => 'Answer';

  @override
  String get signInConfirmLabel => 'Repeat the answer';

  @override
  String get signInContinue => 'Continue';

  @override
  String get signInCreate => 'Create player';

  @override
  String get signInStart => 'Let\'s ride';

  @override
  String get signInAnonymous => 'Play anonymously';

  @override
  String get errInvalidName =>
      'Use 3 to 12 letters, numbers, spaces or underscores.';

  @override
  String errWrongAnswer(int remaining) {
    return 'Wrong answer. $remaining tries left.';
  }

  @override
  String errLocked(int minutes) {
    return 'Too many wrong answers. Try again in $minutes min.';
  }

  @override
  String get errNetwork => 'Could not reach the server. Check your connection.';

  @override
  String get errNotConfigured =>
      'Online services are not set up in this build.';

  @override
  String get errNameTaken => 'That name was just taken. Pick another.';

  @override
  String errWrongChallenge(int remaining) {
    return 'Wrong answer. $remaining tries left.';
  }

  @override
  String get errInvalidQuestion => 'The question needs 5 to 80 characters.';

  @override
  String get errInvalidAnswer => 'The answer needs 2 to 60 characters.';

  @override
  String get errMismatch => 'The two answers do not match.';

  @override
  String get errGeneric => 'Something went wrong. Try again.';

  @override
  String accountSignedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get accountAnonymous =>
      'Playing anonymously. Sign in to be counted on the leaderboard.';

  @override
  String get accountAdmin => 'Admin: you can read the suggestion box.';

  @override
  String get switchPlayer => 'Switch player';

  @override
  String get receptionStats => 'Stats';

  @override
  String get receptionLeaderboard => 'Leaderboard';

  @override
  String get receptionSuggestions => 'Suggestion Box';

  @override
  String get statsTitle => 'Stats';

  @override
  String statsOnlineLine(int online, int players) {
    return 'Online now: $online ($players players)';
  }

  @override
  String get statsVisitors => 'Visitors';

  @override
  String get statsPlayers => 'Players';

  @override
  String get statsGames => 'Games';

  @override
  String get statsAllTime => 'All time';

  @override
  String get statsRangeToday => 'Today';

  @override
  String get statsRange7 => '7 days';

  @override
  String get statsRange28 => '28 days';

  @override
  String get statsRange90 => '3 months';

  @override
  String get statsRange365 => '1 year';

  @override
  String get statsHeatmapTitle => 'When people ride';

  @override
  String get statsHeatmapNote =>
      'Rows are days (Monday first), columns are hours of the day in your local time. Brighter means busier.';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get leaderboardPlayer => 'Player';

  @override
  String get leaderboardGames => 'Games';

  @override
  String get leaderboardWins => 'Wins';

  @override
  String get leaderboardEmpty => 'No races finished yet. Be the first!';

  @override
  String get suggestionHint =>
      'Tell me what to fix, add or remove. Every suggestion lands in my inbox.';

  @override
  String get suggestionLabel => 'Your suggestion';

  @override
  String get suggestionSend => 'Send';

  @override
  String get suggestionThanks => 'Thanks, it is in the box!';

  @override
  String get suggestionSignIn => 'Sign in to leave a suggestion.';

  @override
  String get suggestionTooShort => 'Write a few more words.';

  @override
  String get suggestionRateLimited =>
      'That is enough for now. Try again in a while.';

  @override
  String get suggestionInbox => 'Suggestions received';

  @override
  String get suggestionInboxEmpty => 'The box is empty.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get anonymousWarningTitle => 'Play anonymously?';

  @override
  String get anonymousWarningBody =>
      'You will ride as AnonPlayer. Your games will not be recorded, so you will not appear on our leaderboard. Sign in with a name if you want to be counted.';

  @override
  String get anonymousWarningConfirm => 'Play anyway';

  @override
  String menuOnline(int count) {
    return '$count online';
  }
}

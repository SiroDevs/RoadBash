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
  String get sceneThikaRoad => 'Thika Road';

  @override
  String get sceneJungle => 'The Jungle';

  @override
  String get sceneDirtRoad => 'Dirt Road';

  @override
  String get receptionTitle => 'Reception';

  @override
  String get blurbCity =>
      'Downtown streets, steep hills and walls of glass. Hold your line between the kerbs.';

  @override
  String get blurbSuburbs =>
      'Rolling hills and sweeping bends at the edge of town. Fast, flowing and easy to run wide.';

  @override
  String get blurbThikaRoad =>
      'Blue Post to Museum Hill, the whole Thika Rd run through Juja, Kimbo, Ruiru, Kahawa, Githurai and Roysambu, then down the Pangani underpass. Flyovers, footbridges and slip roads. Keep it clean to the finish.';

  @override
  String get blurbJungle =>
      'Thick rainforest on a narrow, twisting blacktop. Steep climbs, tight bends and trees right at the edge. Brake early, stay on the tarmac.';

  @override
  String get blurbDirtRoad =>
      'Red murram through open dry country. Long straights, rolling crests and wide, dusty bends. No lines to follow, so pick your rut.';

  @override
  String get blurbReception =>
      'Set your player name, mix the sound, check the controls, pick a language, or see your stats and the leaderboard.';

  @override
  String lengthLabel(String km, int laps) {
    return 'Length: $km km, $laps laps';
  }

  @override
  String lengthOneWayLabel(String km) {
    return 'Length: $km km, one way';
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
  String get mostPlayed => 'Most played';

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
      'Hold up (or W) for the throttle. Let go and the bike rolls to a stop.\n\nLeft and right (or A and D) steer. Down or S brakes, and Space pauses.\n\nPhones and tablets: hold either handlebar (GAS) to ride and release both to brake. Drag either handlebar to turn: right bar down (left bar up) steers right, left bar down (right bar up) steers left. Use Boost and Attack in the accessory row below the dashboard while moving; Attack unlocks in level 4. You can also tilt the device like a steering wheel, or switch on Use Screentouch in the race controls menu (top right) to steer with the handlebars only.';

  @override
  String get hudGo => 'GO!';

  @override
  String get hudFinish => 'FINISH!';

  @override
  String get hudHoldGas => 'Hold the gas to ride';

  @override
  String get hudGasLabel => 'Gas';

  @override
  String get hudAttackLabel => 'HIT';

  @override
  String get hudBoostLabel => 'BOOST';

  @override
  String get hudItemLabel => 'ITEM';

  @override
  String hudItemSlot(int slot) {
    return 'Empty item slot $slot';
  }

  @override
  String hudLap(int lap, int laps) {
    return 'LAP $lap/$laps';
  }

  @override
  String hudRemaining(String km) {
    return '-$km KM';
  }

  @override
  String get hudSpeedUnit => 'KM/H';

  @override
  String get hudRpmUnit => 'RPM x1000';

  @override
  String get hudPolice => 'POLICE!';

  @override
  String get hudPullOver => 'PULL OVER!';

  @override
  String get hudBusted => 'BUSTED!';

  @override
  String get bustedNote => 'A cop caught up with you. Race over.';

  @override
  String bustedFine(String amount) {
    return 'Fine: KSh $amount';
  }

  @override
  String get hudCrashed => 'CRASHED!';

  @override
  String crashedNote(int kmh) {
    return 'You went down at $kmh km/h and did not get up. Race over.';
  }

  @override
  String crashHospital(String amount) {
    return 'Hospital: $amount';
  }

  @override
  String crashGarage(String amount) {
    return 'Garage: $amount';
  }

  @override
  String resultsPrize(String amount) {
    return 'Prize: $amount';
  }

  @override
  String resultsWallet(String amount) {
    return 'Wallet: $amount';
  }

  @override
  String walletAmount(String amount) {
    return 'KSh $amount';
  }

  @override
  String walletDebt(String amount) {
    return '-KSh $amount';
  }

  @override
  String get quitRace => 'Quit race';

  @override
  String get handlebarLeft =>
      'Left handlebar, GAS: hold to ride; drag down to steer left, up to steer right';

  @override
  String get handlebarRight =>
      'Right handlebar, GAS: hold to ride; release both grips to brake, drag down to steer right';

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
      'Steer with the on-screen handlebars only, without tilting (phones and tablets)';

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
  String get accountAdmin => 'Admin: you run the boardroom.';

  @override
  String get switchPlayer => 'Switch player';

  @override
  String get receptionStats => 'Stats';

  @override
  String get receptionLeaderboard => 'Leaderboard';

  @override
  String get statsTitle => 'Stats';

  @override
  String statsOnlineLine(int online, int players) {
    return 'Online now: $online ($players players)';
  }

  @override
  String statsPeak(int peak) {
    return 'Max $peak';
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
  String get statsPlacesTitle => 'Where visitors come from';

  @override
  String get statsPlacesCountries => 'Countries';

  @override
  String get statsPlacesCities => 'Places';

  @override
  String statsPlacesUnknown(int count) {
    return 'Location unknown: $count';
  }

  @override
  String get statsPlacesEmpty => 'No locations recorded for this period yet.';

  @override
  String get statsPlacesNote =>
      'Brighter dots mean more visitors. Places are approximate, to about city level, and no addresses are kept.';

  @override
  String statsPlacesMore(int count) {
    return '+$count more';
  }

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
  String get menuScenes => 'Scenes';

  @override
  String get boardroomTitle => 'Boardroom';

  @override
  String get blurbBoardroom =>
      'Read announcements, send me a suggestion, and join the conversation under the public posts.';

  @override
  String get boardroomAnnouncements => 'Announcements';

  @override
  String get boardroomSuggestions => 'Suggestions';

  @override
  String get boardroomAnnouncementsHint =>
      'News from the admins. Reply to join the conversation.';

  @override
  String get boardroomAdminAnnounceHint =>
      'Post an announcement for everyone. Players can reply under it, and you can delete anything inappropriate.';

  @override
  String get boardroomHint =>
      'Tell me what to fix, add or remove. Suggestions stay private until an admin makes them public.';

  @override
  String get boardroomAdminHint =>
      'Reply to suggestions, make them public or delete what is not appropriate.';

  @override
  String get leaderboardThisWeek => 'This week';

  @override
  String get leaderboardLastWeek => 'Last week';

  @override
  String get leaderboardAllTime => 'All time';

  @override
  String leaderboardRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get boardroomSuggestionLabel => 'Your suggestion';

  @override
  String get boardroomAnnouncementLabel => 'Your announcement';

  @override
  String get boardroomSend => 'Send';

  @override
  String get boardroomAnnounce => 'Announce';

  @override
  String get boardroomEmpty => 'Nothing here yet.';

  @override
  String get boardroomReply => 'Reply';

  @override
  String get boardroomReplyLabel => 'Your reply';

  @override
  String get boardroomMakePublic => 'Make public';

  @override
  String get boardroomMakePrivate => 'Make private';

  @override
  String get boardroomDelete => 'Delete';

  @override
  String get boardroomDeleteTitle => 'Delete this?';

  @override
  String get boardroomDeleteBody =>
      'It will be removed for everyone, together with any replies under it.';

  @override
  String get boardroomAdminTag => 'Admin';

  @override
  String get boardroomAnnouncementTag => 'Announcement';

  @override
  String get boardroomPublicTag => 'Public';

  @override
  String get boardroomPrivateTag => 'Private';

  @override
  String get boardroomSignIn => 'Sign in to use the boardroom.';

  @override
  String get boardroomTooShort => 'Write a few more words.';

  @override
  String get boardroomRateLimited =>
      'That is enough for now. Try again in a while.';

  @override
  String get boardroomForbidden => 'Only admins can do that.';

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

  @override
  String levelUpNote(int level) {
    return 'Level up! You are now Level $level.';
  }

  @override
  String sceneLocked(int level) {
    return 'Reach Level $level to unlock this scene';
  }

  @override
  String hintNextLevel(int wins, int level, int done) {
    return 'Win $wins in a row for Level $level ($done/$wins)';
  }

  @override
  String get hintTopLevel => 'Top level. Keep winning!';

  @override
  String hintUnlocks(String places) {
    return 'Unlocks: $places';
  }

  @override
  String hintPrize(String amount, int best, int clean) {
    return 'Win KSh $amount · best +$best% · clean +$clean%';
  }

  @override
  String get hintNoPrize => 'Practice level: no prize money';

  @override
  String resultsBestBonus(String amount) {
    return 'New best bonus: $amount';
  }

  @override
  String resultsCleanBonus(String amount) {
    return 'Clean race bonus: $amount';
  }

  @override
  String resultsTraffic(String amount) {
    return 'Traffic fines: $amount';
  }

  @override
  String get resultsOffencesTitle => 'Traffic offences';

  @override
  String offenceWrongSide(int count) {
    return 'Riding on the wrong side: $count';
  }
}

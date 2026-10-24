// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appName => 'RoadBash';

  @override
  String get feedback => 'Maoni';

  @override
  String splashPresents(String studio) {
    return '$studio wanawasilisha';
  }

  @override
  String get splashTagline => 'Rudisha vibe za kitambo';

  @override
  String splashRights(String credits) {
    return '$credits. Haki zote zimehifadhiwa.';
  }

  @override
  String get noticeTitle => 'Ni mchezo tu';

  @override
  String get noticeFun =>
      'RoadBash imetengenezwa kwa burudani. Mashindano, ajali na vituko vyote ni vya kubuni, na hakuna kinachoonyesha jinsi uendeshaji halisi ulivyo.';

  @override
  String get noticeWarning =>
      'Barabarani, kasi na uendeshaji hatari huumiza watu: wewe na wote wanaokuzunguka. Shindana tu kwenye uwanja uliofungwa, vaa vifaa kamili vya kujilinda na endesha ndani ya uwezo wako. Tumia akili.';

  @override
  String get tapToContinue => 'Gusa kuendelea';

  @override
  String get sceneCity => 'Jiji';

  @override
  String get sceneSuburbs => 'Vitongoji';

  @override
  String get receptionTitle => 'Mapokezi';

  @override
  String get blurbCity =>
      'Mitaa ya katikati ya jiji, milima mikali na kuta za vioo. Shikilia njia yako kati ya kingo.';

  @override
  String get blurbSuburbs =>
      'Vilima vinavyopinda na mikunjo mipana pembezoni mwa mji. Kasi, mtiririko, na ni rahisi kutoka nje ya njia.';

  @override
  String get blurbReception =>
      'Njoo uweke jina la mwendeshaji, rekebisha sauti na uangalie vidhibiti.';

  @override
  String lengthLabel(String km, int laps) {
    return 'Urefu: km $km, mizunguko $laps';
  }

  @override
  String levelLabel(int level) {
    return 'Ngazi $level';
  }

  @override
  String bestTimeLabel(String time) {
    return 'Bora $time';
  }

  @override
  String get noTimeYet => 'Bado hakuna muda';

  @override
  String racesWinsLabel(int races, int wins) {
    return 'Mashindano $races, ushindi $wins';
  }

  @override
  String get startRace => 'Anza shindano';

  @override
  String get enterLabel => 'Ingia';

  @override
  String get defaultPlayerName => 'Mchezaji 1';

  @override
  String get resultsTitle => 'Matokeo ya Shindano';

  @override
  String get raceAgain => 'Shindana tena';

  @override
  String get backToMenu => 'Menyu';

  @override
  String get newBestTime => 'Muda mpya bora!';

  @override
  String get receptionName => 'Jina la Mchezaji';

  @override
  String get receptionSound => 'Mchanganyiko wa Sauti';

  @override
  String get receptionControls => 'Vidhibiti';

  @override
  String get receptionDone => 'Maliza';

  @override
  String get nameHint =>
      'Chagua jina litakaloonekana kwenye dashibodi na kwenye matokeo.';

  @override
  String get volumeMaster => 'Jumla';

  @override
  String get volumeMusic => 'Muziki';

  @override
  String get volumeEngine => 'Injini';

  @override
  String get volumeEffects => 'Athari';

  @override
  String get controlsHelp =>
      'Shikilia juu (au W) kuongeza kasi. Achilia na pikipiki itasimama polepole.\n\nKushoto na kulia (au A na D) huongoza. Chini au S hufunga breki, na Space husimamisha.\n\nSimu na tableti: shikilia pedali ya mafuta (chini kulia) kuendesha na pedali ya breki (chini kushoto) kusimama. Inamisha kifaa kama usukani kugeuka, au washa Tumia Mguso wa Skrini kwenye menyu ya vidhibiti (juu kulia) kuelekeza kwa mishale ya skrini.';

  @override
  String get hudGo => 'ANZA!';

  @override
  String get hudFinish => 'MWISHO!';

  @override
  String get hudHoldGas => 'Shikilia mafuta kuendesha';

  @override
  String hudLap(int lap, int laps) {
    return 'MZUNGUKO $lap/$laps';
  }

  @override
  String get hudSpeedUnit => 'KM/H';

  @override
  String get hudRpmUnit => 'RPM x1000';

  @override
  String get quitRace => 'Acha shindano';

  @override
  String get touchLeft => 'Elekea kushoto';

  @override
  String get touchRight => 'Elekea kulia';

  @override
  String get touchGas => 'Mafuta';

  @override
  String get touchBrake => 'Breki';

  @override
  String get controlsTitle => 'Vidhibiti';

  @override
  String get racePaused => 'Shindano limesimamishwa';

  @override
  String get raceResume => 'Endelea';

  @override
  String get useScreenTouch => 'Tumia Mguso wa Skrini';

  @override
  String get useScreenTouchHint =>
      'Elekeza kwa mishale ya skrini badala ya kuinamisha (simu na tableti)';

  @override
  String get muteSound => 'Nyamazisha Sauti';

  @override
  String get unmuteSound => 'Washa Sauti';

  @override
  String get playMusic => 'Cheza Muziki';

  @override
  String get soundEffects => 'Athari za Sauti';

  @override
  String get engineSound => 'Sauti ya Injini';

  @override
  String get invertTilt => 'Geuza Mwelekeo wa Kuinamisha';

  @override
  String get invertTiltHint =>
      'Geuza kushoto na kulia ikiwa kuinamisha kunahisi kinyume';

  @override
  String get languageTitle => 'Lugha';

  @override
  String get languageHint => 'Chagua lugha ya kuonyesha mchezo';

  @override
  String get exitLabel => 'Toka';

  @override
  String get exitHint => 'Kimbia kama mwoga na urudi nyumbani';

  @override
  String get pauseRace => 'Simamisha';
}

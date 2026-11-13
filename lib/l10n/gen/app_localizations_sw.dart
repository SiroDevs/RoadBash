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
  String get sceneThikaRoad => 'Barabara ya Thika';

  @override
  String get sceneJungle => 'Msituni';

  @override
  String get sceneDirtRoad => 'Barabara ya Vumbi';

  @override
  String get receptionTitle => 'Mapokezi';

  @override
  String get blurbCity =>
      'Mitaa ya katikati ya jiji, milima mikali na kuta za vioo. Shikilia njia yako kati ya kingo.';

  @override
  String get blurbSuburbs =>
      'Vilima vinavyopinda na mikunjo mipana pembezoni mwa mji. Kasi, mtiririko, na ni rahisi kutoka nje ya njia.';

  @override
  String get blurbThikaRoad =>
      'Kutoka Blue Post hadi Museum Hill kupitia Juja, Kimbo, Ruiru, Kahawa, Githurai na Roysambu, kisha chini ya handaki la Pangani. Vivuko vya juu, madaraja ya waenda kwa miguu na njia za kutoka. Kaa safi hadi mwisho.';

  @override
  String get blurbJungle =>
      'Msitu mnene wa kitropiki kwenye barabara nyembamba ya lami yenye mikunjo. Miinuko mikali, kona kali na miti ukingoni mwa barabara. Kanyaga breki mapema, baki kwenye lami.';

  @override
  String get blurbDirtRoad =>
      'Murram nyekundu katika nchi kavu iliyo wazi. Nyoofu ndefu, miinuko laini na mikunjo mipana yenye vumbi. Hakuna mistari ya kufuata, chagua njia yako.';

  @override
  String get blurbReception =>
      'Weka jina la mchezaji, rekebisha sauti, angalia vidhibiti, chagua lugha, au tazama takwimu na washindi.';

  @override
  String lengthLabel(String km, int laps) {
    return 'Urefu: km $km, mizunguko $laps';
  }

  @override
  String lengthOneWayLabel(String km) {
    return 'Urefu: km $km, njia moja';
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
      'Shikilia juu (au W) kuongeza kasi. Achilia na pikipiki itasimama polepole.\n\nKushoto na kulia (au A na D) huongoza. Chini au S hufunga breki, na Space husimamisha.\n\nSimu na tableti: shikilia mpini wowote (MAFUTA) kuendesha, na uachilie yote miwili kufunga breki. Buruta mpini wowote kugeuka: wa kulia ukishuka (wa kushoto ukipanda) unaelekea kulia; wa kushoto ukishuka (wa kulia ukipanda) unaelekea kushoto. Tumia vitufe vya kuongeza kasi na kushambulia kwenye safu ya vifaa chini ya dashibodi unapoendesha; kushambulia hufunguliwa kiwango cha 4.\n\nKidhibiti: fimbo ya kushoto au D-pad kuelekeza, RT kuongeza kasi, LT kufunga breki, A/Cross kushambulia (kiwango cha 4+), X/Square kuongeza nguvu, na Start kusitisha.\n\nUnaweza pia kuinamisha kifaa kama usukani, au kuwasha Tumia Mguso wa Skrini kwenye menyu ya vidhibiti (juu kulia) kuelekeza kwa usukani wa skrini pekee.';

  @override
  String get hudGo => 'ANZA!';

  @override
  String get hudFinish => 'MWISHO!';

  @override
  String get hudHoldGas => 'Shikilia mafuta kuendesha';

  @override
  String get hudGasLabel => 'Mafuta';

  @override
  String get hudAttackLabel => 'PIGA';

  @override
  String get hudBoostLabel => 'ONGEZA';

  @override
  String get hudItemLabel => 'KITU';

  @override
  String hudItemSlot(int slot) {
    return 'Nafasi ya kitu $slot';
  }

  @override
  String hudLap(int lap, int laps) {
    return 'MZUNGUKO $lap/$laps';
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
  String get hudPolice => 'POLISI!';

  @override
  String get hudPullOver => 'SIMAMA!';

  @override
  String get hudBusted => 'UMEKAMATWA!';

  @override
  String get bustedNote => 'Polisi wamekufikia. Shindano limeisha.';

  @override
  String bustedFine(String amount) {
    return 'Faini: KSh $amount';
  }

  @override
  String get hudCrashed => 'UMEANGUKA!';

  @override
  String crashedNote(int kmh) {
    return 'Umeanguka kwa $kmh km/h na hukuamka. Mbio zimeisha.';
  }

  @override
  String crashHospital(String amount) {
    return 'Hospitali: $amount';
  }

  @override
  String crashGarage(String amount) {
    return 'Gereji: $amount';
  }

  @override
  String resultsPrize(String amount) {
    return 'Zawadi: $amount';
  }

  @override
  String resultsWallet(String amount) {
    return 'Pochi: $amount';
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
  String get quitRace => 'Acha shindano';

  @override
  String get handlebarLeft =>
      'Upande wa kushoto wa usukani, MAFUTA: shikilia kuendesha; buruta chini kuelekea kushoto, juu kuelekea kulia';

  @override
  String get handlebarRight =>
      'Upande wa kulia wa usukani, MAFUTA: shikilia kuendesha; achilia mipini yote miwili kufunga breki, buruta chini kuelekea kulia';

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
      'Elekeza kwa usukani wa skrini pekee, bila kuinamisha (simu na tableti)';

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

  @override
  String get commonBack => 'Rudi';

  @override
  String get commonRetry => 'Jaribu tena';

  @override
  String get commonRefresh => 'Onyesha upya';

  @override
  String get signInTitle => 'Nani anaendesha?';

  @override
  String get signInNameLabel => 'Jina la mwendeshaji';

  @override
  String get signInNameHint =>
      'Weka jina lako la mwendeshaji ili kucheza: herufi, namba, nafasi au _ (3 hadi 12).';

  @override
  String signInNewHint(String name) {
    return '$name liko wazi. Weka swali la usalama na jibu ili kulilinda. Utahitaji jibu kila unaporudi.';
  }

  @override
  String signInAnswerHint(String name) {
    return 'Karibu tena $name. Jibu swali lako la usalama ili uendeshe.';
  }

  @override
  String signInChallengeHint(String name) {
    return '$name ni jina lililohifadhiwa. Jibu hili ili ulidai:';
  }

  @override
  String get signInChallengeQuestion =>
      'Je, unajua mchezo huu uliandikwa lini kwa mara ya kwanza?';

  @override
  String get signInQuestionLabel => 'Swali lako la usalama';

  @override
  String get signInAnswerLabel => 'Jibu';

  @override
  String get signInConfirmLabel => 'Rudia jibu';

  @override
  String get signInContinue => 'Endelea';

  @override
  String get signInCreate => 'Unda mchezaji';

  @override
  String get signInStart => 'Tuanze';

  @override
  String get signInAnonymous => 'Cheza bila kujulikana';

  @override
  String get errInvalidName => 'Tumia herufi, namba, nafasi au _ (3 hadi 12).';

  @override
  String errWrongAnswer(int remaining) {
    return 'Jibu si sahihi. Umebakiwa na majaribio $remaining.';
  }

  @override
  String errLocked(int minutes) {
    return 'Majibu mengi yasiyo sahihi. Jaribu tena baada ya dakika $minutes.';
  }

  @override
  String get errNetwork => 'Imeshindwa kufikia seva. Angalia mtandao wako.';

  @override
  String get errNotConfigured =>
      'Huduma za mtandaoni hazijawekwa kwenye toleo hili.';

  @override
  String get errNameTaken => 'Jina hilo limechukuliwa. Chagua lingine.';

  @override
  String errWrongChallenge(int remaining) {
    return 'Jibu si sahihi. Umebakiwa na majaribio $remaining.';
  }

  @override
  String get errInvalidQuestion => 'Swali linahitaji herufi 5 hadi 80.';

  @override
  String get errInvalidAnswer => 'Jibu linahitaji herufi 2 hadi 60.';

  @override
  String get errMismatch => 'Majibu mawili hayalingani.';

  @override
  String get errGeneric => 'Hitilafu imetokea. Jaribu tena.';

  @override
  String accountSignedInAs(String name) {
    return 'Umeingia kama $name';
  }

  @override
  String get accountAnonymous =>
      'Unacheza bila kujulikana. Ingia ili uhesabiwe kwenye orodha ya washindi.';

  @override
  String get accountAdmin => 'Msimamizi: unaendesha boardroom.';

  @override
  String get switchPlayer => 'Badili mchezaji';

  @override
  String get receptionStats => 'Takwimu';

  @override
  String get receptionLeaderboard => 'Washindi';

  @override
  String get statsTitle => 'Takwimu';

  @override
  String statsOnlineLine(int online, int players) {
    return 'Mtandaoni sasa: $online (wachezaji $players)';
  }

  @override
  String statsPeak(int peak) {
    return 'Upeo $peak';
  }

  @override
  String get statsVisitors => 'Wageni';

  @override
  String get statsPlayers => 'Wachezaji';

  @override
  String get statsGames => 'Michezo';

  @override
  String get statsAllTime => 'Jumla';

  @override
  String get statsRangeToday => 'Leo';

  @override
  String get statsRange7 => 'Siku 7';

  @override
  String get statsRange28 => 'Siku 28';

  @override
  String get statsRange90 => 'Miezi 3';

  @override
  String get statsRange365 => 'Mwaka 1';

  @override
  String get statsHeatmapTitle => 'Wakati watu wanaendesha';

  @override
  String get statsHeatmapNote =>
      'Safu ni siku (Jumatatu kwanza), nguzo ni saa za siku kwa saa za eneo lako. Mwangaza zaidi inamaanisha shughuli zaidi.';

  @override
  String get statsPlacesTitle => 'Wageni wanatoka wapi';

  @override
  String get statsPlacesCountries => 'Nchi';

  @override
  String get statsPlacesCities => 'Maeneo';

  @override
  String statsPlacesUnknown(int count) {
    return 'Mahali haijulikani: $count';
  }

  @override
  String get statsPlacesEmpty =>
      'Hakuna mahali paliporekodiwa kwa kipindi hiki bado.';

  @override
  String get statsPlacesNote =>
      'Vitone vinavyong\'aa zaidi vinamaanisha wageni zaidi. Mahali ni makadirio hadi kiwango cha jiji, na hakuna anwani zinazohifadhiwa.';

  @override
  String statsPlacesMore(int count) {
    return '+$count zaidi';
  }

  @override
  String get leaderboardTitle => 'Orodha ya Washindi';

  @override
  String get leaderboardPlayer => 'Mchezaji';

  @override
  String get leaderboardGames => 'Michezo';

  @override
  String get leaderboardWins => 'Ushindi';

  @override
  String get leaderboardEmpty =>
      'Hakuna aliyemaliza mbio bado. Kuwa wa kwanza!';

  @override
  String get menuScenes => 'Chagua mandhari ya kucheza';

  @override
  String get menuStartRide => 'Anza Mbio';

  @override
  String get menuHowToPlay => 'Jinsi ya kucheza';

  @override
  String get boardroomTitle => 'Boardroom';

  @override
  String get blurbBoardroom =>
      'Soma matangazo, nitumie pendekezo, na ujiunge na mazungumzo chini ya machapisho ya wazi.';

  @override
  String get boardroomAnnouncements => 'Matangazo';

  @override
  String get boardroomSuggestions => 'Mapendekezo';

  @override
  String get boardroomAnnouncementsHint =>
      'Habari kutoka kwa wasimamizi. Jibu ili kujiunga na mazungumzo.';

  @override
  String get boardroomAdminAnnounceHint =>
      'Weka tangazo kwa wote. Wachezaji wanaweza kujibu chini yake, na unaweza kufuta yasiyofaa.';

  @override
  String get boardroomHint =>
      'Niambie nini cha kurekebisha, kuongeza au kuondoa. Mapendekezo hubaki ya faragha hadi msimamizi ayaweke wazi.';

  @override
  String get boardroomAdminHint =>
      'Jibu mapendekezo, yaweke wazi au futa yasiyofaa.';

  @override
  String get leaderboardThisWeek => 'Wiki hii';

  @override
  String get leaderboardLastWeek => 'Wiki iliyopita';

  @override
  String get leaderboardAllTime => 'Wakati wote';

  @override
  String leaderboardRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get boardroomSuggestionLabel => 'Pendekezo lako';

  @override
  String get boardroomAnnouncementLabel => 'Tangazo lako';

  @override
  String get boardroomSend => 'Tuma';

  @override
  String get boardroomAnnounce => 'Tangaza';

  @override
  String get boardroomEmpty => 'Hakuna kitu hapa bado.';

  @override
  String get boardroomReply => 'Jibu';

  @override
  String get boardroomReplyLabel => 'Jibu lako';

  @override
  String get boardroomMakePublic => 'Weka wazi';

  @override
  String get boardroomMakePrivate => 'Rudisha faragha';

  @override
  String get boardroomDelete => 'Futa';

  @override
  String get boardroomDeleteTitle => 'Futa hii?';

  @override
  String get boardroomDeleteBody =>
      'Itaondolewa kwa kila mtu, pamoja na majibu yote chini yake.';

  @override
  String get boardroomAdminTag => 'Msimamizi';

  @override
  String get boardroomAnnouncementTag => 'Tangazo';

  @override
  String get boardroomPublicTag => 'Wazi';

  @override
  String get boardroomPrivateTag => 'Faragha';

  @override
  String get boardroomSignIn => 'Ingia ili kutumia boardroom.';

  @override
  String get boardroomTooShort => 'Andika maneno machache zaidi.';

  @override
  String get boardroomRateLimited => 'Inatosha kwa sasa. Jaribu tena baadaye.';

  @override
  String get boardroomForbidden => 'Wasimamizi pekee wanaweza kufanya hivyo.';

  @override
  String get commonCancel => 'Ghairi';

  @override
  String get anonymousWarningTitle => 'Cheza bila kujulikana?';

  @override
  String get anonymousWarningBody =>
      'Utaendesha kama AnonPlayer. Michezo yako haitarekodiwa, kwa hivyo hutaonekana kwenye orodha yetu ya washindi. Ingia kwa jina ukitaka kuhesabiwa.';

  @override
  String get anonymousWarningConfirm => 'Cheza hivyo hivyo';

  @override
  String menuOnline(int count) {
    return '$count mtandaoni';
  }

  @override
  String levelUpNote(int level) {
    return 'Umepanda ngazi! Sasa uko Ngazi $level.';
  }

  @override
  String sceneLocked(int level) {
    return 'Fikia Ngazi $level kufungua eneo hili';
  }

  @override
  String hintNextLevel(int wins, int level, int done) {
    return 'Shinda $wins mfululizo kwa Ngazi $level ($done/$wins)';
  }

  @override
  String get hintTopLevel => 'Ngazi ya juu. Endelea kushinda!';

  @override
  String hintUnlocks(String places) {
    return 'Hufungua: $places';
  }

  @override
  String hintPrize(String amount, int best, int clean) {
    return 'Shinda KSh $amount · muda bora +$best% · mbio safi +$clean%';
  }

  @override
  String get hintNoPrize => 'Ngazi ya mazoezi: hakuna zawadi';

  @override
  String resultsBestBonus(String amount) {
    return 'Bonasi ya muda bora: $amount';
  }

  @override
  String resultsCleanBonus(String amount) {
    return 'Bonasi ya mbio safi: $amount';
  }

  @override
  String resultsTraffic(String amount) {
    return 'Faini za trafiki: $amount';
  }

  @override
  String get resultsOffencesTitle => 'Makosa ya trafiki';

  @override
  String offenceWrongSide(int count) {
    return 'Kuendesha upande usio sahihi: $count';
  }
}

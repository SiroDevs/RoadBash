// Flutter imports:
import 'package:flutter/widgets.dart';

/// Text for the touch controls and the in-race controls menu.
///
/// Kept here instead of the .arb files so no generated l10n file has to be
/// edited by hand. Move these into the .arb files when convenient (the keys
/// are the getter names); until then English and Swahili are covered.
class ControlsStrings {
  const ControlsStrings._(this._sw);

  final bool _sw;

  static ControlsStrings of(BuildContext context) => ControlsStrings._(
    Localizations.localeOf(context).languageCode == 'sw',
  );

  String _t(String en, String sw) => _sw ? sw : en;

  String get title => _t('Controls', 'Vidhibiti');
  String get paused => _t('Race paused', 'Shindano limesimamishwa');
  String get resume => _t('Resume', 'Endelea');

  String get useScreenTouch => _t('Use Screentouch', 'Tumia Mguso wa Skrini');
  String get useScreenTouchHint => _t(
    'Steer with on-screen arrows instead of tilting (phones and tablets)',
    'Elekeza kwa mishale ya skrini badala ya kuinamisha (simu na tableti)',
  );

  String get muteSound => _t('Mute Sound', 'Nyamazisha Sauti');
  String get playMusic => _t('Play Music', 'Cheza Muziki');
  String get soundEffects => _t('Sound Effects', 'Athari za Sauti');
  String get engineSound => _t('Engine Sound', 'Sauti ya Injini');

  String get invertTilt => _t('Invert Tilt', 'Geuza Mwelekeo wa Kuinamisha');
  String get invertTiltHint => _t(
    'Flip left and right if tilt steering feels reversed',
    'Geuza kushoto na kulia ikiwa kuinamisha kunahisi kinyume',
  );

  String get enableTilt =>
      _t('Tap to enable tilt steering', 'Gusa kuwasha uelekezaji wa kuinamisha');

  /// Replaces the old "Touch: ..." paragraph of the Controls help text.
  String get touchHelp => _t(
    'Phones and tablets: hold the gas pedal (bottom right) to ride and the brake pedal (bottom left) to stop. Tilt the device like a steering wheel to turn, or switch on Use Screentouch in the race controls menu (top right) to steer with on-screen arrows.',
    'Simu na tableti: shikilia pedali ya mafuta (chini kulia) kuendesha na pedali ya breki (chini kushoto) kusimama. Inamisha kifaa kama usukani kugeuka, au washa Tumia Mguso wa Skrini kwenye menyu ya vidhibiti (juu kulia) kuelekeza kwa mishale ya skrini.',
  );
}

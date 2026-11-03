# Police, busted and civilian traffic

## What was added
- **Civilian traffic** (`lib/core/game/road/traffic/`): cars, matatus and trucks drive the
  same way as the race, one steady speed per lane (slow lane on the left, trucks favour it).
  `TrafficProfile` sets density, speeds and vehicle mix per scene; jungle and dirt road are
  sparse and have no police. `TrafficFlow` keeps a fixed pool alive by recycling vehicles
  that fall behind to the front of the pack.
- **Collisions** (`race/traffic_contacts.dart`): hitting the back of a vehicle at more than
  ~28% of top speed relative closing speed throws the player off; slower touches bump and
  hold you back; side contact shoves you away. Rivals avoid traffic (they pick a free lane
  and brake behind slow vehicles) and can crash into it.
- **Police** (`lib/core/game/police/police_chase.dart`):
  - *Heat* builds while riding above 80% speed (~26 s to fill) and jumps when you hit traffic.
  - A full heat bar sends a cop from behind, out of sight; the siren and the flashing red/blue
    screen edges are the warning. First patrol never before 16 s into the race.
  - The cop rides up beside you. While it is within range the arrest meter fills (4 s; faster
    if you are down or stopped). A full meter means **BUSTED**: the race ends, a fine is shown
    and nothing is recorded as a time.
  - Ride at (almost) full throttle and the cop falls behind; after ~4 s more than ~6,800 units
    back it gives up, and the next patrol is 22-36 s away.
- **Busted flow**: `RaceController.bust()`, `RaceResult.busted/fine`, BUSTED banner, siren +
  `busted.wav`, a results screen with the fine (KSh 1,000 + 500 per traffic hit, capped at 9,500).
  The fine is display-only; there is no economy yet to charge it to.
- New assets: `assets/audio/loops/siren.wav`, `assets/audio/sfx/busted.wav`.
- New strings (en + sw): `hudPolice`, `hudPullOver`, `hudBusted`, `bustedNote`, `bustedFine`.

## Tuning knobs
| What | Where |
|---|---|
| Traffic density / speeds / mix per scene | `TrafficProfile.of` |
| Knock-off threshold, hit strength | `TrafficContacts._fallClosing`, `_strengthSpan` |
| How quickly heat builds | `PoliceChase._speedingSeconds`, `_speedingShare` |
| First patrol delay, gap between patrols | `_firstDelay`, `_release()` |
| Cop top speed (escape difficulty) | `PoliceChase._topShare` (0.975 = escapable only flat out) |
| Arrest time / range | `_bustSeconds`, `_rangeBehind`, `_rangeAhead` |
| Fine | `PoliceChase.fine` |

## Not verified
This was written without a Flutter SDK, so it has only been syntax-checked (Dart parser), not
compiled or played. Expect to run `flutter analyze` and fix any small type slips, then tune the
numbers above by feel.

## Where things live after the merge
- `police/police_cop.dart` the cop rider and its flashing lights; `police/police_chase.dart` the heat, chase and arrest logic.
- `hud/police_warning_hud.dart` the flashing screen edges, POLICE! text and arrest meter.
- `race/scene_traffic.dart` builds the traffic flow and police patrol for a scene.
- `road/traffic/civilian_car.dart` the traffic vehicle; `road/vehicle/` holds how each vehicle is drawn
  (`sedan_painter`, `matatu_painter`, `truck_painter`, `vehicle_canvas`, `civilian_kind`).
- New sounds go in `assets/audio/loops/siren.wav` and `assets/audio/sfx/busted.wav`.

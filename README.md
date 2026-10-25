# Road Bash™ 2026

A pseudo-3D racing game built with Flutter and Flame, made as a love letter to the 1991 classic Road Rash. Ride through the city and the suburbs, keep to the left like we do in Kenya, and try to beat your rivals across the line.

**Play it:** https://roadbash.sirodevs.com

> Work in progress. Controls and UI are still being polished. Suggestions and complaints are welcome.

## Features

- Classic pseudo-3D road rendering with hills, bends, haze, and roadside scenery (buildings, trees, lamps, signs) that keeps a fixed size and scales with distance on any screen shape
- Two tracks: **The City** and **The Suburbs**, three laps each
- Left-hand driving, as on Kenyan roads
- Rival riders, live race position, lap counter, and a results screen
- Procedural engine sound with selectable engine flavours, plus music and sound effects mixed in real time (`flutter_soloud`)
- Tilt steering on phones and tablets, with on-screen pedals, pause, and mute
- English and Kiswahili, switchable from the Reception screen
- Player accounts on Supabase: pick a name, protect it with your own security question
- Public stats (visitors, players, games, who is online, activity heatmap), a leaderboard and a suggestion box, all reached from the Reception screen
- Runs on Android, iOS, web, Windows, Linux, and macOS

## Controls

| Action | Keyboard | Touch |
| --- | --- | --- |
| Throttle | Up / W | Gas pedal (bottom right) |
| Brake | Down / S | Brake pedal (bottom left) |
| Steer | Left / Right or A / D | Tilt the device like a steering wheel |
| Pause | Space | Pause icon (top right) |
| Mute | | Speaker icon (top right) |

Turn on **Use Screentouch** in the controls menu to steer with on-screen arrows instead of tilting. This also shows the touch controls on desktop. If tilt feels reversed, switch on **Invert Tilt**.

On iPhone Safari, motion access needs one tap. The game asks the first time you touch the screen.

## Reception

The Reception screen (the restroom) is where you check who you are signed in as and switch player, mix the sound, read the controls, change the language, open the **Stats** and **Leaderboard** screens, drop a note in the **Suggestion Box**, or **Exit** if you want to wimp out and go home.

## Online features (Supabase)

1. Create a Supabase project and run `supabase/roadbash.sql` once in the SQL editor. It creates the `rb_*` tables, locks them down with row level security, and exposes everything through `rb_*` functions.
2. Pass the project URL and anon key when you build or run:

```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR-ANON-KEY
```

For Vercel, add the same two `--dart-define` flags to the `flutter build web` step in the GitHub Actions workflow (store the values as repository secrets).

Without those flags the game still runs: the sign-in screen offers **Play offline** and nothing is recorded.

How it behaves:

- Every launch asks for a rider name. A new name gets a security question and answer; an existing name must answer its question. Answers are hashed in the database and five wrong tries lock the name for ten minutes.
- `admin`, `siro`, `sirodevs` and `sirodevske` are reserved (table `rb_reserved_names`). A guest who types one has to pass a challenge question first, then sets their own security question. Those accounts see the received suggestions in the Suggestion Box. The challenge answer is stored only as a hash in `rb_config`.
- Visits are counted once per launch per device, and a heartbeat every 30 seconds drives the "online now" count.
- Finished races are saved per player and feed the leaderboard and each player's level and best times.

## Getting started

You need the Flutter SDK (Dart 3.13 or newer).

```bash
git clone <your-repo-url>
cd roadbash
flutter pub get
flutter run
```

Run on the web with `flutter run -d chrome`, or on desktop with `flutter run -d windows`, `-d macos`, or `-d linux`.

### Localisation

Strings live in `l10n/app_en.arb` and `l10n/app_sw.arb`. Controls-menu and Reception labels are in `lib/common/strings/controls_strings.dart`. After editing the `.arb` files, regenerate with:

```bash
flutter gen-l10n
```

### Placeholder audio

`tools/generate_audio.py` synthesises placeholder music and sound effects (needs `numpy`):

```bash
python tools/generate_audio.py assets/audio
```

Replace any generated file with a real recording of the same name.

## Project structure

```
lib/
  app.dart             App shell, theme, locale
  common/              Router, layout helpers, retro widgets, strings
  core/
    audio/             Music, effects, engine synthesizer
    game/              Flame game: road, props, rider, HUD, input, race logic
    progress/          Player level
    settings/          Persisted player settings
  domain/              Models and repositories
  feature/             Splash, notice, sign-in, menu, reception, race, results, stats, leaderboard, suggestions
supabase/
  roadbash.sql         Tables, security and functions for the online features
```

Built with clean architecture and BLoC (`flutter_bloc`), dependency injection with `get_it` and `injectable`, and routing with `go_router`.

## Deployment

Pushes to `main` build the Flutter web app and deploy it to Vercel through GitHub Actions (`.github/workflows/deploy-vercel.yml`). Pull requests get a preview deployment.

Add these repository secrets before the first run:

- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

The workflow writes `.vercel/output/config.json` with a `filesystem` handler ahead of the catch-all route. Without it, Vercel answers script requests with `index.html` and the game shows a white screen.

## Contributing

Issues and pull requests are welcome. If you are a developer, head over to GitHub at [@SiroDevs](https://github.com/SiroDevs) and start contributing.

Questions or feedback: sirodevske@gmail.com

## Credits

Fonts: Anton and Rajdhani, both under the SIL Open Font License (see `assets/fonts/`).

Inspired by Road Rash by EA. Road Bash is an independent, original project and is not affiliated with or endorsed by Electronic Arts.

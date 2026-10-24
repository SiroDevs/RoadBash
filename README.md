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

The Reception screen (the restroom) is where you set your rider name, mix the sound, read the controls, change the language, or **Exit** if you want to wimp out and go home.

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
  feature/             Splash, notice, menu, reception, race, results
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
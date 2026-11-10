# RoadBash: Visual and Animation Roadmap

Prepared 10 November 2026 from a code audit of the RoadBash archive, your .flp artwork, your original brief and the five-bike start-line reference image.

## 1. Purpose and how to use this document

This document merges three things: your original brief to the previous model, what the code audit found, and your latest decision that the reference image is the look for the entire game, not just the start line. It lists what is wrong, what must be decided, what must be built, in what order, and how each step is verified. Nothing has been changed in the code yet.

Two caveats up front. First, the audit was done by reading code and rendering your .flp layers; Flutter was not run, so behaviour claims come from the code and should be confirmed on a device. Second, some parts of the code (crash and recovery, running) were not read in depth and are marked as audit items below.

## 2. The target

The reference image defines the target for the whole game:

- A low camera directly behind the riders, with the horizon high in the frame (about 14% from the top).
- Riders large in frame: the player fills roughly 60% of the screen height, with tyres near the bottom (about 86% down).
- The player in the centre, rivals on either side, all the same size when level with the player.
- Every rider seen from behind with only a slight turn of the head and bike toward the player.
- Clean road at the bottom of the screen, no cockpit covering the player's bike.
- Five distinct colours: yellow, blue, red (player, with white stripes), green and purple.

Your original brief adds the behaviour that must sit on top of that look: component-based 3D-like depth, smooth cornering perspective, dynamic rival angles, a physical crash and recovery sequence, real running animation and a correct stationary foot pose.

## 3. What the audit found

### 3.1 Your artwork is used; the pipeline is sound

The real pipeline is: Rider.flp and Bike.flp, then tool/pack\_art.py, then the generated sheet data in lib/core/game/rider/art/sheet/data, then SeatedRiderFigure and BikeFigure at runtime. Re-running the packer reproduced the committed data exactly, so your current drawings are what the game draws. Your separate-parts approach is respected: helmet, torso, arms, thighs, shins and boots are separate parts, and the bike has named shapes with a morph between straight and slight-left or slight-right views.

Two mechanisms to remember:

- Colour comes from name tables (rider\_tones.dart, bike\_tones.dart). A shape name that is not listed silently falls back to one flat default colour. Every new shape you draw needs a tone entry.
- Pose comes from one RiderPose object (lean, perspective, steer, foot, pitch, bob, tumble) shared by the player and rivals.

### 3.2 Dead code

These are never called and hide what is live:

- RoadBashRiderPainter, RoadBashBikePainter and everything under rider/art/layers and bike/art/layers, about 25,000 generated lines from an older export whose layer names do not match your artwork folder.
- The older procedural painters (rider/body, rider/bike, RiderPainter drawing), which only run when useSuppliedArt is false; every caller sets it true.
- The Dart exports under artwork/rider/layers and artwork/bike/layers, which the pipeline does not read.

### 3.3 Gaps between the vision and the game

**Rival helmet direction (bug).** In rival\_racer.dart, \_updateFacing gives a rival on the right a positive perspective. In seated\_rider.dart a positive value is drawn unmirrored, and your side helmet has its visor on the right. So rivals on the right look right and rivals on the left look left, away from the player. The sign is inverted.

**Head turn is far too strong.** Rivals turn up to 0.82 at the start while the rider reaches full side profile at 0.7, so they show your full side view. The reference shows only a slight turn.

**Missing in-between art.** Your brief says you drew helmet and arm variations for slightly left and slightly right. The Rider.flp in the archive has layers SideWays, BackFacing, Side Standing, FrontFacing and Side Running, with only a full rear helmet and a full side helmet. I found no slight-left or slight-right helmet or arm variants. Bike.flp has StraightForward, SlightLeftForward and SlightRightForward but no complete side-view bike. Either those files were not included or they were not exported.

**Start formation.** Rivals start 520 and 1040 units ahead (2.6 and 5.2 road segments) in staggered rows, and that lead only starts shrinking after GO because the race clock is 0 during the countdown. The lateral slots (-0.75, 0.1, 0.75, -0.45, 0.45) are not symmetric, and the player starts at playerX = -0.25 rather than the centre.

**Camera and layout.** Horizon ratio is 0.42; player height is capped near 20% of the screen (sizeFactor 0.65 times screenFill 0.30); player tyres are capped at 73% down; a dashboard and handlebar HUD covers the bottom. Rival size is derived from the player's, with a 1.6 times cap.

**Look and colour.** Parts are flat polygons with a 0.4 pixel edge, against the thick ink outlines and highlights in your image. The rival colours (red, blue, orange, white and green, teal and yellow) do not match your five-colour lineup, and the player is black with red.

**Housekeeping.** Over the 220-line limit: road\_game.dart (262), dashboard\_hud.dart (250), rival\_racer.dart (249), road\_renderer.dart (235), race\_screen.dart (232).

### 3.4 Requirements that look partly or fully in place, to verify

- Stationary foot pose: SeatedRiderFigure lowers one foot as pose.foot rises when the bike stops. Verify it is always the left foot on screen, that the right foot stays on the footrest, and that it applies at game start and after any stop.
- Main-rider cornering perspective: RiderComponent already adds a perspective when steering is hard, speed is high and the curve is sharp. It is gated by a hard threshold and may be too large.
- Rival perspective by relative position: the code already uses gap to the player, but its rules differ from the reference image (see section 4).
- Crash and recovery, and the runner figure: RecoveryPainter, CrashState, runner\_pose.dart and runner\_figure.dart exist but were not audited against the eight-step recovery sequence.

## 4. Working rules

These come from your coding standards and your brief and apply to every change.

- Source files stay at or under 220 lines. Decide with you whether generated data files are excluded.
- Reuse before creating: check for an existing helper (PartMotion, ArtSheet, InkedSheet and similar) and put new shared helpers in a common utilities folder.
- Any user-facing text, including debug screens, goes through the localization system, with English as default.
- Comments are short, single-line for functions and classes, and none on variables or constants; names must be self-explanatory and never single-letter outside loops.
- UI: do not choose fonts, corner radii, gradients or shadows without asking; borders subtle; shimmer skeletons while data loads; shared component library instead of per-screen widgets; styled\_widget for Flutter composition.
- Keep parts separate. Never merge independently animated parts, and keep polygons, rectangles and ellipses distinct.
- Your .flp files stay the single source of truth. Change art there, run the packer, never edit generated data by hand.
- One change set per phase, each checked against the reference before the next begins.

## 5. The depth model: how 2D parts become 3D-like

The core idea is a single yaw value per rider, from -1 (fully turned left) to +1 (fully turned right), with 0 meaning straight from behind. Every part responds to yaw on its own curve, which is what creates depth without a 3D engine.

- **Helmet.** Leads the body. Between 0 and a small yaw, rotate and shift the rear helmet slightly and squash it horizontally. If slight-turn helmet art exists, crossfade to it. Beyond that, crossfade to the full side helmet. Mirror for the other direction.
- **Torso.** Squashes a little and shifts toward the turn, lagging the helmet.
- **Arms.** The near arm swings forward, the far arm tucks behind the torso, using the arm variants if available. Steering sway stays separate from yaw.
- **Legs and boots.** Shift and squash slightly with yaw; the footrest-side boot stays attached to the bike.
- **Bike.** Uses the existing morph rows between StraightForward and the slight views, driven by the same yaw but with its own response curve so the bike and rider do not turn in perfect lockstep.
- **Layer order.** Define it per yaw range so the far-side arm and leg sit behind the torso and the near-side ones in front. Never reorder during a transition.
- **Smoothing.** Yaw is always eased toward its target. No part jumps.

This model is built once and then driven by rules for the player and for rivals.

## 6. Phased plan

### Phase 0: Safety net

Create a branch or tag. Build a visual test screen that draws a rider and bike at a fixed grid of yaws, with foot up and down, and mid-run frames, next to the reference image. There is a rider\_view\_gallery.dart and a scene\_snapshot.dart in the project that look like starting points; check whether they are wired up. Acceptance: you can see any pose on a device in one tap.

### Phase 1: Quick fixes

- Flip the rival facing sign so rivals turn toward the player, including the fallback when they are exactly level.
- Cap yaw so the maximum at the start is a slight turn, matching the reference, and decouple the helmet turn curve from the bike curve.
- Rebuild the start grid from the rival count: symmetric lateral slots around a centred player, no lead offset, no stagger. Remove the visual lead that currently decays after GO, or replace it with a real start-line offset of zero.
- Start the player at the centre.

Acceptance: the start screen shows a row abreast with the correct look directions at the current camera.

### Phase 2: Camera and layout

This is the biggest structural change, and the dashboard decision in section 4 comes first.

- Retune horizonRatio, cameraHeight, cameraDepth, riderTyresGround, roadSpread, lanePx and RiderRig.heightFor together; they depend on each other and must change as one set.
- Re-lay out the backdrop, mountains, skyline and scene layouts for a sky area of about 14% instead of 42%.
- Re-check traffic and rival placement in RoadTraffic.\_place, because every size is derived from the player's height.
- Move or redesign the HUD per your decision.
- Handle portrait per your decision.

Acceptance: with riders level, a screenshot matches the reference framing for horizon, rider size and tyre line, on at least one phone and one tablet size.

### Phase 3: Depth model

Implement section 6 for the player and rivals in SeatedRiderFigure and BikeFigure, split into small files to stay under 220 lines. Add the art tone entries for any new shapes first.

Acceptance: the test screen sweeps yaw from -1 to 1 smoothly with no pops, and mirrored left and right look identical.

### Phase 4: Player cornering

Replace the hard on/off gate with a continuous yaw driven by steering, speed and curve, with a modest maximum so the bike stays mostly from behind. Keep lean and yaw separate. Ease in and out.

Acceptance: sharp, fast corners show a visible but slight side perspective on both rider and bike; straights show none; the change is smooth.

### Phase 5: Rival perspective rules

One function turns the relationship to the player into a yaw:

- Direction is always toward the player: rivals on the left turn slightly right, rivals on the right turn slightly left.
- At the start: slight turn toward the player, per the reference.
- When a rival is ahead: ease to straight, with the amount rising as the gap grows.
- When the player is catching up: ease back to a slight turn, rising as the gap closes.
- A rival level with the player uses the start-line look.

Acceptance: in a recorded race, no rival ever faces away from the player, and angles change smoothly with the gap.

### Phase 6: Stationary pose

Verify and fix: left foot on the ground, right foot on the footrest, seated posture, at game start and at every stop. Applies to the player, rivals that stop, and the finish.

Acceptance: screenshots at the start, after braking to a halt, and at the finish all show one foot down on the left only.

### Phase 7: Running animation

Audit runner\_pose.dart and runner\_figure.dart, then make sure that:

- The legs alternate, using the thigh and shin parts you separated, with knee bend and natural foot placement.
- The body bob matches the stride.
- The ground scrolls beneath the runner in step with the stride, so the feet do not slide.
- The rider is not simply translated with static legs.

Acceptance: a captured sequence of frames shows alternating legs with correct knee bend, and foot contact matches ground speed.

### Phase 8: Crash, dismount and recovery

Audit RecoveryPainter and CrashState against these steps and fix any deviations:

1. The rider is thrown from the bike on a crash.
2. The rider lands off the road on either side.
3. The bike rests separately, fully off the road, and does not move by itself.
4. The rider stands and tiptoes toward the bike.
5. The legs run with real alternating movement.
6. The ground moves beneath the rider as he approaches.
7. A proper mounting and sitting animation plays on arrival.
8. Rider and bike return to the road together by a smooth transition.

Keep a strict world-space rule: the rider and the bike each have their own position, and the rider must visibly reach the bike. There is no teleporting and the bike never moves toward the rider.

Acceptance: you can step through the sequence on the test screen and the spatial relationship holds at every frame.

### Phase 9: Look and colour

Apply your five-colour lineup. Decide on outline weight and highlights per your answer in section 4. Fill in tone entries for every shape that currently falls back to the default. Apply the same colour mapping to the helmet and suit so a rider reads from far away.

Acceptance: a screenshot beside the reference shows matching colours and a comparable level of detail.

### Phase 10: Cleanup

Only after you approve the result:

- Delete the dead generated layer code and the unused painters.
- Split the five files over 220 lines.
- Run the packer once more and confirm the generated data is unchanged.

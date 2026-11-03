# Rider and bike

The rider (the person) and the bike are drawn by separate painters, one pair
per view. A view is one of `rear`, `front`, `left`, `right` (`view/rider_view.dart`).

```
rider/
  rider_painter.dart      puts the pieces together for a view
  rider_sprite.dart       a rider + bike you can paint anywhere (takes a view)
  rider_pose.dart         lean, steer, speed ... shared by every view
  look/                   colours
  view/
    rider_view.dart       RiderView and RiderCanvas (size and ground line per view)
    bike_anchors.dart     where hands, feet and hips attach to the bike
    bike_view_painter.dart / body_view_painter.dart   the two contracts
    placeholder_*.dart    schematic drawing used until a view is drawn
    rider_view_gallery.dart   widget showing all four views together
  bike/{rear,front,left,right}/   the bike, one painter per view
  body/{rear,front,left,right}/   the rider, one painter per view
  profile/                the menu's side drawing (separate, older code)
```

## Drawing a view

1. Open `bike/<view>/<view>_bike_painter.dart` and `body/<view>/<view>_body_painter.dart`.
   They start as schematics (`Placeholder*Painter`).
2. Override the layers you want to draw. The bike paints in four steps around the
   rider: `paintShadow`, `paintBehindRider`, (rider), `paintInFrontOfRider`,
   `paintOverRider`.
3. `anchors(pose)` on the bike gives the hands, feet, seat and ground contact for
   that view; the rider painter reads them, so the two never need to know each
   other's drawing.
4. The size of the drawing area and the ground line are in `RiderView.canvas`.
   Change them there if a view needs more room. The right view can mirror the left
   one with `RiderCanvas.mirror`.
5. Drop `RiderViewGallery()` onto any screen to see all views together.

The rear view is the finished drawing used in the race (`bike/rear`, `body/rear`).

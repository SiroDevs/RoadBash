"""Builds the bike rows, from the combi artwork or the older straight-to-turn views."""
from art_geometry import *

ALIASES = {
    'StraightForward': {'Trye': 'Tyre'},
    'StraightFoward': {'Trye': 'Tyre', 'NumberPlate': 'NumberPlatePanel'},
    'SlightRightForward': {
        'Tyre2': 'Tyre', 'Tyre1': 'TyreWall', 'HandleBarPipes': 'HandleBar', 'FrontShieldView': 'FrontShield',
        'FrontShieldViewLeftPipe': 'LeftFrontShieldPipe', 'FrontShieldViewRightPipe': 'RightFrontShieldPipe',
        'OuterHole': 'ExhaustOuterHole', 'InnerHole': 'ExhaustInnerHole', 'BackPipeRight': 'RightBackPipe',
        'BackPipeLeft': 'LeftBackPipe', 'UnderBodyPanel': 'BigUnderPanel', 'LeftSideStep': 'LeftSideStepper',
        'LeftSidePanel1': 'LeftMidPanel', 'LeftSidePanel2': 'LowerSidePanel', 'LeftSidePanel3': 'UpperSidePanel'},
    'SlightLeftForward': {
        'MainFrame': 'BikeFrame', 'Tyre1': 'Tyre', 'Tyre2': 'TyreWall', 'HandleBarPipe': 'HandleBar',
        'FrontShieldPanel': 'FrontShield', 'RightFontShieldPanelPipe': 'RightFrontShieldPipe',
        'OuterHole': 'ExhaustOuterHole', 'InnerHole': 'ExhaustInnerHole', 'UnderBodyPanel': 'BigUnderPanel',
        'BackPipe': 'RightBackPipe', 'LeftSideStep': 'LeftSideStepper', 'RightSideStep': 'RightSideStepper',
        'LeftSidePanel2': 'RightMidPanel', 'LeftSidePanel1': 'LowerSidePanel', 'LeftSidePanel3': 'UpperSidePanel',
        'LeftSidePanel4': 'TopSidePanel'},
}
GROUP_ALIAS = {'HandleBars': 'bars'}


def sheet_shapes(flp, layer_name):
    layer = [l for l in flp['layers'] if l['name'] == layer_name][0]
    names = ALIASES.get(layer_name, {})
    items = [dict(name=names.get(s['name'], s['name']), group=GROUP_ALIAS.get(s.get('groupName'), 'body'),
                  gid=s.get('groupId'), poly=shape_points(s, 40)) for s in layer['shapes']]
    gids = []
    for s in items:
        if s['gid'] not in gids:
            gids.append(s['gid'])
    return [s for gid in gids for s in items if s['gid'] == gid]


def morph_rows(straight, target, count=40):
    """Pairs shapes by name; unmatched ones fade out or in."""
    by_name = {s['name']: s for s in target}
    used, rows = set(), []
    for s in straight:
        other = by_name.get(s['name'])
        if other is None:
            rows.append(('A', s['group'], s['name'], fmt(resample(s['poly'], 12)), ''))
            continue
        used.add(s['name'])
        a, b = align_pair(resample(s['poly'], count), resample(other['poly'], count))
        rows.append(('P', s['group'], s['name'], fmt(a), fmt(b)))
    for i, s in enumerate(target):
        if s['name'] in used:
            continue
        at = len(rows)
        for back in range(i - 1, -1, -1):
            prev = next((k for k, r in enumerate(rows) if r[2] == target[back]['name']), None)
            if prev is not None:
                at = prev + 1
                break
        rows.insert(at, ('B', s['group'], s['name'], '', fmt(resample(s['poly'], 12))))
    return rows


def build_bike(flp):
    straight = sheet_shapes(flp, 'StraightForward')
    base = [(s['group'], s['name'], fmt(s['poly'])) for s in straight]
    left = morph_rows(straight, sheet_shapes(flp, 'SlightLeftForward'))
    right = morph_rows(straight, sheet_shapes(flp, 'SlightRightForward'))
    return base, left, right


# Draw group of each bike group in artwork/combi/combi.flp: parts drawn before the
# rider ('body', 'bars') and parts drawn over his legs and boots ('over').
COMBI_BIKE_GROUPS = {'FrontPart': 'body', 'HandleBars': 'bars', 'BikeBody': 'body',
                     'MidSections': 'over', 'BackPart': 'over', 'Bottom': 'over', '': 'over'}
COMBI_ALIASES = {'Trye': 'Tyre', 'NumberPlate': 'NumberPlatePanel'}


# A shape that travels farther than this is a mismatched pair, so it stays put.
MAX_TURN_TRAVEL = 20


def union_box(rings):
    boxes = [bbox(ring) for ring in rings]
    return (min(b[0] for b in boxes), min(b[1] for b in boxes),
            max(b[2] for b in boxes), max(b[3] for b in boxes))


def combi_turn_rows(base, ref_straight, ref_turned, count=40):
    """Turns the combi bike like the reference bike turns: every shape moves by the
    change of the same-named reference shape, scaled to the combi bike's size. Shapes
    the reference does not turn, or that would travel too far, stay put."""
    ref_box = union_box([s['poly'] for s in ref_straight])
    own_box = union_box([[tuple(map(float, p.split(','))) for p in pts.split(' ')] for _, _, pts in base])
    sx = (own_box[2] - own_box[0]) / (ref_box[2] - ref_box[0])
    sy = (own_box[3] - own_box[1]) / (ref_box[3] - ref_box[1])

    def to_ref(p):
        return (ref_box[0] + (p[0] - own_box[0]) / sx, ref_box[1] + (p[1] - own_box[1]) / sy)

    straight_by_name = {s['name']: s for s in ref_straight}
    turned_by_name = {s['name']: s for s in ref_turned}
    rows = []
    for group, name, pts in base:
        ring = [tuple(map(float, p.split(','))) for p in pts.split(' ')]
        ref_s, ref_t = straight_by_name.get(name), turned_by_name.get(name)
        if ref_s is None:
            rows.append(('P', group, name, pts, pts))
            continue
        if ref_t is None:
            rows.append(('P', group, name, pts, pts))
            continue
        first, second = align_pair(resample(ref_s['poly'], count), resample(ref_t['poly'], count))
        own = resample(ring, count)
        shift = min(range(count), key=lambda k: sum(
            math.dist(first[i], to_ref(own[(i + k) % count])) for i in range(count)))
        own = [own[(i + shift) % count] for i in range(count)]
        target = [(p[0] + (second[i][0] - first[i][0]) * sx, p[1] + (second[i][1] - first[i][1]) * sy)
                  for i, p in enumerate(own)]
        travel = sum(math.dist(a, b) for a, b in zip(own, target)) / count
        if travel > MAX_TURN_TRAVEL:
            target = own
        rows.append(('P', group, name, fmt(own), fmt(target)))
    return rows


def build_combi_bike(flp, bike_flp=None):
    """Reads the bike of the RiderOnBike layer. Its turned views come from the
    reference bike (Bike.flp) when given, else the outlines just repeat."""
    layer = [l for l in flp['layers'] if l['name'] == 'RiderOnBike'][0]
    base = []
    for s in layer['shapes']:
        group = s.get('groupName') or ''
        if group in COMBI_BIKE_GROUPS:
            name = COMBI_ALIASES.get(s['name'], s['name'])
            base.append((COMBI_BIKE_GROUPS[group], name, fmt(shape_points(s, 40))))
    if bike_flp is None:
        turned = [('P', group, name, points, points) for group, name, points in base]
        return base, turned, turned
    straight = sheet_shapes(bike_flp, 'StraightFoward')
    left = combi_turn_rows(base, straight, sheet_shapes(bike_flp, 'SlightLeftForward'))
    right = combi_turn_rows(base, straight, sheet_shapes(bike_flp, 'SlightRightForward'))
    return base, left, right

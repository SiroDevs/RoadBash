"""Builds the bike rows, from the combi artwork or the older straight-to-turn views."""
from art_geometry import *

ALIASES = {
    'StraightForward': {'Trye': 'Tyre'},
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


def build_combi_bike(flp):
    """Reads the bike of the RiderOnBike layer; it has no turned views yet, so the
    left and right tables repeat the straight outlines."""
    layer = [l for l in flp['layers'] if l['name'] == 'RiderOnBike'][0]
    base = []
    for s in layer['shapes']:
        group = s.get('groupName') or ''
        if group in COMBI_BIKE_GROUPS:
            name = COMBI_ALIASES.get(s['name'], s['name'])
            base.append((COMBI_BIKE_GROUPS[group], name, fmt(shape_points(s, 40))))
    turned = [('P', group, name, points, points) for group, name, points in base]
    return base, turned, turned

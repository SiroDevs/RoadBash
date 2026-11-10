"""Builds rider parts, joints and glove/knee splits from Rider.flp."""
import math
from art_geometry import *

LEG_SILHOUETTES = {'FullLeg', 'RightLeg', 'LeftLeg', 'Leg'}
ARM_SILHOUETTES = {'FullHand', 'LeftHand', 'RightHand', 'Hand'}
CUFFS = {'GloveWrist', 'ArmWrist'}

# sheet -> ordered (partId, groupName, shape filter)
SHEETS = {
    'rear': ('BackFacing', [
        ('helmet', 'Helmet', None), ('bootL', 'RightBoot', 'L'), ('bootR', 'RightBoot', 'R'),
        ('legL', 'Legs', 'Left'), ('legR', 'Legs', 'Right'), ('torso', 'Torso', None),
        ('armR', 'RightHand', None), ('armL', 'LeftHand', None)]),
    'front': ('FrontFacing', [
        ('helmet', 'Helmet', None), ('bootR', 'LeftBoot', None), ('bootL', 'RightBoot', None),
        ('torso', 'Torso', None), ('armR', 'LeftHand', None), ('armL', 'RightHand', None),
        ('legL', 'RightLeg', None), ('legR', 'LeftLeg', None)]),
    'standing': ('Side Standing', [
        ('helmet', 'Helmet', None), ('torso', 'Torso', None), ('arm', 'RightHand', None),
        ('leg', 'RightLeg', None), ('boot', 'RightBoot', None)]),
    'running': ('Side Running', [
        ('bootNear', 'LeftBoot', None), ('legFar', 'RightLeg', None), ('armFar', 'RightHand', None),
        ('helmet', 'Helmet', None), ('bootFar', 'RightBoot', None), ('legNear', 'LeftLeg', None),
        ('armNear', 'LeftHand', None), ('torso', 'Torso', None)]),
    'sideways': ('SideWays', [
        ('helmet', 'Helmet', None), ('leg', 'Leg', 'leg'), ('boot', 'Leg', 'boot'), ('arm', 'Arm', None)]),
}


def layer_shapes(flp, layer_name):
    layer = [l for l in flp['layers'] if l['name'] == layer_name][0]
    return [dict(name=s['name'], group=s.get('groupName') or '', gid=s.get('groupId'),
                 poly=shape_points(s), kind=s['kind']) for s in layer['shapes']]


def pick(shapes, group, flt):
    out = [s for s in shapes if s['group'] == group]
    if flt in ('L', 'R'):
        gids = []
        for s in out:
            if s['gid'] not in gids:
                gids.append(s['gid'])
        mine = []
        for gid in gids:
            members = [s for s in out if s['gid'] == gid]
            cx = sum(centroid(m['poly'])[0] for m in members[:1]) / 1
            if (cx < 60) == (flt == 'L'):
                mine += members
        return mine
    if flt in ('Left', 'Right'):
        return [s for s in out if s['name'].startswith(flt)]
    if flt == 'boot':
        return [s for s in out if s['name'] in ('Boot', 'Sole')]
    if flt == 'leg':
        return [s for s in out if s['name'] not in ('Boot', 'Sole')]
    return out


def far_end(poly, origin):
    far = max(poly, key=lambda p: math.dist(p, origin))
    close = [p for p in poly if math.dist(p, far) < 6]
    return (sum(p[0] for p in close) / len(close), sum(p[1] for p in close) / len(close))


def near_end(poly, y_limit=6):
    top = min(p[1] for p in poly)
    close = [p for p in poly if p[1] <= top + y_limit]
    return (sum(p[0] for p in close) / len(close), sum(p[1] for p in close) / len(close))


def unit(v):
    n = math.hypot(*v) or 1
    return (v[0] / n, v[1] / n)


def knee_of(shapes):
    pads = [s for s in shapes if 'KneePad' in s['name']]
    pads.sort(key=lambda s: s['name'])
    return centroid(pads[-1]['poly']) if pads else None


def split_leg(shapes, anchors, pid, joint_cap=True):
    """Splits a leg into thigh and shin parts at its knee pad."""
    sil = [s for s in shapes if s['name'] in LEG_SILHOUETTES]
    knee = knee_of(shapes)
    if not sil or knee is None:
        return shapes, None
    hip = near_end(sil[0]['poly'])
    ankle = far_end(sil[0]['poly'], hip)
    normal = unit((unit((knee[0] - hip[0], knee[1] - hip[1]))[0] + unit((ankle[0] - knee[0], ankle[1] - knee[1]))[0],
                   unit((knee[0] - hip[0], knee[1] - hip[1]))[1] + unit((ankle[0] - knee[0], ankle[1] - knee[1]))[1]))
    anchors[pid + '.hip'], anchors[pid + '.knee'], anchors[pid + '.ankle'] = hip, knee, ankle
    overlap = (knee[0] - normal[0] * 2.0, knee[1] - normal[1] * 2.0)
    thigh, shin = [], []
    for s in shapes:
        c = centroid(s['poly'])
        side = (c[0] - knee[0]) * normal[0] + (c[1] - knee[1]) * normal[1]
        if s['name'] in LEG_SILHOUETTES:
            up = clip_half_plane(s['poly'], knee, normal, False)
            down = clip_half_plane(s['poly'], overlap, normal, True)
            thigh.append(dict(s, poly=up))
            shin.append(dict(s, poly=down))
            span = [p for p in s['poly'] if abs((p[0] - knee[0]) * normal[0] + (p[1] - knee[1]) * normal[1]) < 3]
            width = min(max([math.dist(a, b) for a in span for b in span] or [8]), 15)
            joint = [(knee[0] + math.cos(a * math.pi / 12) * width * 0.46, knee[1] + math.sin(a * math.pi / 12) * width * 0.46) for a in range(24)]
            if joint_cap:
                shin.append(dict(name='KneeJoint', group=s['group'], gid=s['gid'], poly=joint, kind='polygon'))
        elif 'KneePad' in s['name'] or side > 0:
            shin.append(s)
        else:
            thigh.append(s)
    return thigh, shin


def split_arm(shapes, anchors, pid, torso):
    """Adds a glove shape beyond the cuff and records the shoulder pivot."""
    sil = [s for s in shapes if s['name'] in ARM_SILHOUETTES]
    if not sil:
        return shapes
    poly = sil[0]['poly']
    tc = centroid(torso['poly']) if torso else (60, 60)
    shoulder = min(poly, key=lambda p: math.dist(p, tc))
    close = [p for p in poly if math.dist(p, shoulder) < 7]
    shoulder = (sum(p[0] for p in close) / len(close), sum(p[1] for p in close) / len(close))
    hand = max(poly, key=lambda p: math.dist(p, shoulder))
    axis = unit((hand[0] - shoulder[0], hand[1] - shoulder[1]))
    length = math.dist(hand, shoulder)
    anchors[pid + '.shoulder'] = shoulder
    cuffs = [s for s in shapes if s['name'] in CUFFS]
    if cuffs:
        c = centroid(cuffs[0]['poly'])
        t = (c[0] - shoulder[0]) * axis[0] + (c[1] - shoulder[1]) * axis[1] - 2.0
    else:
        t = length * 0.78
    cut = (shoulder[0] + axis[0] * t, shoulder[1] + axis[1] * t)
    glove = clip_half_plane(poly, cut, axis, True)
    out = []
    for s in shapes:
        out.append(s)
        if s is sil[0]:
            out.append(dict(name='Glove', group=s['group'], gid=s['gid'], poly=glove, kind='polygon'))
    return out


def build_sheet(flp, key):
    layer, spec = SHEETS[key]
    shapes = layer_shapes(flp, layer)
    anchors, parts = {}, []
    torso_shapes = pick(shapes, 'Torso', None)
    torso = [s for s in torso_shapes if s['name'] == 'Torso']
    for pid, group, flt in spec:
        members = pick(shapes, group, flt)
        if pid.startswith('leg'):
            thigh, shin = split_leg(members, anchors, pid, key != 'rear')
            if shin is None:
                parts.append((pid, members))
                continue
            parts.append((pid + 'Thigh', thigh))
            parts.append((pid + 'Shin', shin))
            continue
        if pid.startswith('arm'):
            members = split_arm(members, anchors, pid, torso[0] if torso else None)
        parts.append((pid, members))
    helmet = [s for s in shapes if s['group'] == 'Helmet' and s['name'] in ('Helmet', 'MainWrap')]
    if helmet:
        x0, y0, x1, y1 = bbox(helmet[0]['poly'])
        anchors['helmet.neck'] = ((x0 + x1) / 2, y1 - 2)
    if torso:
        x0, y0, x1, y1 = bbox(torso[0]['poly'])
        anchors['torso.waist'] = ((x0 + x1) / 2, y1)
    for pid, members in parts:
        if pid.startswith('boot'):
            x0, y0, x1, y1 = bbox(members[0]['poly'])
            anchors[pid + '.heel'] = ((x0 + x1) / 2, y1 - 0.18 * (y1 - y0))
    return parts, anchors

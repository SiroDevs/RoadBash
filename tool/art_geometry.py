"""Geometry helpers for the artwork packer."""
import math


def shape_points(shape, steps=36):
    """Returns the outline of a .flp shape as a polygon."""
    kind, pts = shape['kind'], shape['points']
    if kind == 'polygon':
        return [tuple(p) for p in pts]
    (x1, y1), (x2, y2) = pts
    left, right = min(x1, x2), max(x1, x2)
    top, bottom = min(y1, y2), max(y1, y2)
    cx, cy = (left + right) / 2, (top + bottom) / 2
    rot = shape.get('rotation') or 0
    if kind == 'ellipse':
        rx, ry = (right - left) / 2, (bottom - top) / 2
        raw = [(cx + rx * math.cos(2 * math.pi * i / steps),
                cy + ry * math.sin(2 * math.pi * i / steps)) for i in range(steps)]
    else:
        rad = min(shape.get('radius') or 0, (right - left) / 2, (bottom - top) / 2)
        raw = []
        if rad <= 0:
            raw = [(left, top), (right, top), (right, bottom), (left, bottom)]
        else:
            for ccx, ccy, start in [(right - rad, top + rad, -90), (right - rad, bottom - rad, 0),
                                    (left + rad, bottom - rad, 90), (left + rad, top + rad, 180)]:
                for i in range(9):
                    a = math.radians(start + 90 * i / 8)
                    raw.append((ccx + rad * math.cos(a), ccy + rad * math.sin(a)))
    c, s = math.cos(rot), math.sin(rot)
    return [(cx + (x - cx) * c - (y - cy) * s, cy + (x - cx) * s + (y - cy) * c) for x, y in raw]


def centroid(poly):
    area = signed_area(poly)
    if abs(area) < 1e-6:
        return (sum(p[0] for p in poly) / len(poly), sum(p[1] for p in poly) / len(poly))
    cx = cy = 0.0
    for i, (x0, y0) in enumerate(poly):
        x1, y1 = poly[(i + 1) % len(poly)]
        cross = x0 * y1 - x1 * y0
        cx += (x0 + x1) * cross
        cy += (y0 + y1) * cross
    return (cx / (6 * area), cy / (6 * area))


def signed_area(poly):
    return 0.5 * sum(poly[i][0] * poly[(i + 1) % len(poly)][1] - poly[(i + 1) % len(poly)][0] * poly[i][1]
                     for i in range(len(poly)))


def bbox(poly):
    xs, ys = [p[0] for p in poly], [p[1] for p in poly]
    return min(xs), min(ys), max(xs), max(ys)


def clip_half_plane(poly, point, normal, keep_positive=True):
    """Keeps the part of poly on one side of the line through point."""
    sign = 1 if keep_positive else -1

    def inside(p):
        return sign * ((p[0] - point[0]) * normal[0] + (p[1] - point[1]) * normal[1]) >= 0

    def cut(a, b):
        da = sign * ((a[0] - point[0]) * normal[0] + (a[1] - point[1]) * normal[1])
        db = sign * ((b[0] - point[0]) * normal[0] + (b[1] - point[1]) * normal[1])
        t = da / (da - db)
        return (a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t)

    out = []
    for i, cur in enumerate(poly):
        prev = poly[i - 1]
        if inside(cur):
            if not inside(prev):
                out.append(cut(prev, cur))
            out.append(cur)
        elif inside(prev):
            out.append(cut(prev, cur))
    return out


def resample(poly, count):
    """Returns count evenly spaced points along a polygon outline."""
    if signed_area(poly) < 0:
        poly = poly[::-1]
    start = min(range(len(poly)), key=lambda i: (poly[i][1] + poly[i][0] * 0.001))
    poly = poly[start:] + poly[:start]
    seg = [math.dist(poly[i], poly[(i + 1) % len(poly)]) for i in range(len(poly))]
    total, out, i, acc = sum(seg), [], 0, 0.0
    for j in range(count):
        target = total * j / count
        while acc + seg[i] < target:
            acc += seg[i]
            i += 1
        t = (target - acc) / seg[i] if seg[i] else 0
        a, b = poly[i], poly[(i + 1) % len(poly)]
        out.append((a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t))
    return out


def align_pair(first, second):
    """Rotates the second ring so both rings morph with least travel."""
    n = len(first)
    best = min(range(n), key=lambda s: sum(math.dist(first[i], second[(i + s) % n]) for i in range(n)))
    return first, [second[(i + best) % n] for i in range(n)]


def fmt(points):
    return ' '.join('%s,%s' % (('%.2f' % x).rstrip('0').rstrip('.'), ('%.2f' % y).rstrip('0').rstrip('.'))
                    for x, y in points)

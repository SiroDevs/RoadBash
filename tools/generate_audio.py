"""Synthesises the placeholder music and sound effects (needs numpy).

Usage: python tools/generate_audio.py assets/audio
Replace any generated file with a real recording of the same name.
"""
import os
import sys
import wave

import numpy as np

SR = 22050
rng = np.random.default_rng(11)
OUT = sys.argv[1] if len(sys.argv) > 1 else 'assets/audio'


def write(path, x, peak=0.85):
    x = np.tanh(1.2 * x / (np.max(np.abs(x)) + 1e-9)) 
    x = x / np.max(np.abs(x)) * peak
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with wave.open(path, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes((x * 32767).astype('<i2').tobytes())


def time(d):
    return np.arange(int(SR * d)) / SR


def mtof(m):
    return 440 * 2 ** ((m - 69) / 12)


def saw(f, t, h=8):
    return sum(np.sin(2 * np.pi * k * f * t) / k for k in range(1, h + 1))


def square(f, t, h=9):
    return sum(np.sin(2 * np.pi * k * f * t) / k for k in range(1, h + 1, 2))


def decay(t, tau, attack=0.004):
    return np.minimum(1, t / attack) * np.exp(-t / tau)


def noise(n):
    return rng.uniform(-1, 1, n)


def periodic_noise(dur, lo, hi, n=150, tilt=0.0):
    t = time(dur)
    out = np.zeros_like(t)
    for f in rng.integers(int(lo * dur), int(hi * dur), n) / dur:
        out += np.sin(2 * np.pi * f * t + rng.uniform(0, 2 * np.pi)) / (f ** tilt)
    return out / np.max(np.abs(out))


def place(buf, start, sig):
    n = len(buf)
    start %= n
    first = min(len(sig), n - start)
    buf[start:start + first] += sig[:first]
    if first < len(sig):
        buf[:len(sig) - first] += sig[first:]


def kick():
    t = time(0.3)
    f = 45 + 120 * np.exp(-t * 38)
    return np.sin(2 * np.pi * np.cumsum(f) / SR) * np.exp(-t * 9)


def snare():
    t = time(0.25)
    return 0.6 * noise(len(t)) * np.exp(-t * 22) + 0.5 * np.sin(2 * np.pi * 190 * t) * np.exp(-t * 28)


def hat():
    t = time(0.08)
    return np.diff(noise(len(t) + 1)) * np.exp(-t * 55) * 0.6


def bass(m, d):
    t = time(d)
    f = mtof(m)
    return (0.8 * saw(f, t, 6) + 0.7 * np.sin(np.pi * f * t)) * decay(t, d * 0.55)


def pad(notes, d):
    t = time(d)
    swell = np.minimum(1, t / (d * 0.3)) * np.minimum(1, (d - t) / (d * 0.25) + 0.0)
    out = np.zeros_like(t)
    for m in notes:
        for detune in (0.997, 1.0, 1.003):
            out += saw(mtof(m) * detune, t, 5)
    return out * swell / (len(notes) * 3)


def lead(m, d, shape=square):
    t = time(d)
    return shape(mtof(m), t, 7) * decay(t, d * 0.7)


def track(name, bpm, bars, chords, gains, drums, bass_steps, arp_steps, arp_octave=12):
    step = round(SR * 60 / bpm / 4)
    steps = bars * 16
    buf = np.zeros(step * steps + 1)[:-1]
    kd, sn, ht = kick(), snare(), hat()
    for s in range(steps):
        pos, b = s * step, s % 16
        root, notes = chords[(s // 16) % len(chords)]
        if b in drums['kick']:
            place(buf, pos, kd * gains['kick'])
        if b in drums['snare']:
            place(buf, pos, sn * gains['snare'])
        if b in drums['hat']:
            place(buf, pos, ht * gains['hat'])
        if b in bass_steps:
            off = bass_steps[b]
            place(buf, pos, bass(root + off, step * 2 / SR * 1.0) * gains['bass'])
        if b in arp_steps:
            n = notes[arp_steps[b] % len(notes)] + arp_octave
            place(buf, pos, lead(n, step * 3 / SR) * gains['lead'])
        if b == 0:
            place(buf, pos, pad(notes, step * 16 / SR) * gains['pad'])
    write(f'{OUT}/music/{name}.wav', buf)


A, F_, C, G, D, E = 'Am', 'F', 'C', 'G', 'D', 'Em'
am = (45, [57, 60, 64])
f = (41, [53, 57, 60])
c = (48, [55, 60, 64])
g = (43, [55, 59, 62])
gM = (43, [55, 59, 62])
dM = (50, [57, 62, 66])
em = (40, [55, 59, 64])
cM = (48, [55, 60, 64])

track('menu', 100, 8, [am, f, c, g],
      dict(kick=0.35, snare=0, hat=0.10, bass=0.30, lead=0.28, pad=0.9),
      dict(kick=[0, 8], snare=[], hat=[2, 6, 10, 14]),
      {0: 0, 8: 0}, {0: 0, 2: 1, 4: 2, 6: 1, 8: 0, 10: 1, 12: 2, 14: 1})

track('city', 138, 8, [am, am, f, g],
      dict(kick=0.9, snare=0.55, hat=0.22, bass=0.55, lead=0.30, pad=0.45),
      dict(kick=[0, 4, 8, 12], snare=[4, 12], hat=[2, 6, 10, 14]),
      {0: 0, 2: 0, 4: 12, 6: 0, 8: 0, 10: 0, 12: 12, 14: 7},
      {0: 0, 3: 1, 6: 2, 8: 1, 11: 2, 14: 0})

track('suburbs', 120, 8, [gM, dM, em, cM],
      dict(kick=0.8, snare=0.5, hat=0.18, bass=0.5, lead=0.30, pad=0.55),
      dict(kick=[0, 8, 10], snare=[4, 12], hat=[0, 2, 4, 6, 8, 10, 12, 14]),
      {0: 0, 6: 7, 8: 0, 14: 7}, {0: 2, 2: 1, 4: 0, 6: 1, 8: 2, 10: 1, 12: 0, 14: 1})

t = time(0.07)
write(f'{OUT}/sfx/click.wav', np.sin(2 * np.pi * 1800 * t) * np.exp(-t * 70) + 0.3 * noise(len(t)) * np.exp(-t * 200))

t = time(0.2)
write(f'{OUT}/sfx/beep.wav', square(660, t) * decay(t, 0.12))

t = time(0.55)
write(f'{OUT}/sfx/go.wav', (square(990, t) + 0.5 * square(1320, t)) * decay(t, 0.3))

t = time(0.16)
write(f'{OUT}/sfx/shift.wav', np.sin(2 * np.pi * 110 * t) * np.exp(-t * 35) + 0.5 * noise(len(t)) * np.exp(-t * 120) + 0.3 * np.sin(2 * np.pi * 520 * t) * np.exp(-t * 50))

t = time(0.25)
write(f'{OUT}/sfx/foot.wav', np.sin(2 * np.pi * 80 * t) * np.exp(-t * 18) + 0.4 * noise(len(t)) * np.exp(-t * 60))

fan = np.zeros(int(SR * 2.0))
for i, m in enumerate([72, 76, 79, 84, 79, 84]):
    place(fan, int(SR * 0.16 * i), (square(mtof(m), time(0.5)) + 0.4 * np.sin(2 * np.pi * mtof(m) * time(0.5))) * decay(time(0.5), 0.25))
for m in (72, 76, 79, 84):
    place(fan, int(SR * 0.16 * 6), square(mtof(m), time(1.0), 5) * decay(time(1.0), 0.5) * 0.6)
write(f'{OUT}/sfx/finish.wav', fan)

gv = periodic_noise(1.0, 200, 4000, 200) * (0.6 + 0.4 * periodic_noise(1.0, 20, 40, 20))
write(f'{OUT}/loops/gravel.wav', gv)
write(f'{OUT}/loops/wind.wav', periodic_noise(2.0, 40, 1200, 160, tilt=0.5))

for p in sorted(os.popen(f'find {OUT} -name "*.wav"').read().split()):
    with wave.open(p) as w:
        print(f'{os.path.relpath(p, OUT):22s} {w.getnframes() / SR:5.1f}s {os.path.getsize(p) / 1024:6.0f} KB')

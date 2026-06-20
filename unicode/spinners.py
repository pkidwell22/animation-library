"""Unicode spinner animations as raw frame data."""

import json
import os

# Source: https://github.com/gunnargray-dev/unicode-animations (MIT)
# Each spinner: {"frames": [str], "interval": int}

_SPINNERS_PATH = os.path.join(os.path.dirname(__file__), "spinners.json")

with open(_SPINNERS_PATH) as _f:
    SPINNERS = json.load(_f)

# Convenience: access as SPINNERS["helix"] or helix
braille = SPINNERS["braille"]
braillewave = SPINNERS["braillewave"]
dna = SPINNERS["dna"]
scan = SPINNERS["scan"]
rain = SPINNERS["rain"]
scanline = SPINNERS["scanline"]
pulse = SPINNERS["pulse"]
snake = SPINNERS["snake"]
sparkle = SPINNERS["sparkle"]
cascade = SPINNERS["cascade"]
columns = SPINNERS["columns"]
orbit = SPINNERS["orbit"]
breathe = SPINNERS["breathe"]
waverows = SPINNERS["waverows"]
checkerboard = SPINNERS["checkerboard"]
helix = SPINNERS["helix"]
fillsweep = SPINNERS["fillsweep"]
diagswipe = SPINNERS["diagswipe"]

__all__ = ["SPINNERS"] + [
    "braille",
    "braillewave",
    "dna",
    "scan",
    "rain",
    "scanline",
    "pulse",
    "snake",
    "sparkle",
    "cascade",
    "columns",
    "orbit",
    "breathe",
    "waverows",
    "checkerboard",
    "helix",
    "fillsweep",
    "diagswipe",
]

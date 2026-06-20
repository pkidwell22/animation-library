# Animation Library

A collection of open-source animation primitives for loading states, generating indicators, and UI feedback.

## Categories

| Directory | Description |
|-----------|-------------|
| `unicode/` | Braille-pattern spinner animations from [unicode-animations](https://github.com/gunnargray-dev/unicode-animations). 18 spinners as raw frame data (JSON), usable in any language or platform. |
| `ascii/` | ASCII-art loading animations and progress indicators (planned) |
| `lottie/` | Lottie JSON animations for web/mobile/native (planned) |
| `css/` | Pure CSS keyframe animations (planned) |
| `svg/` | SVG-based loaders and progress indicators (planned) |

## Usage

### Unicode spinners

Each spinner is a `{ frames: string[], interval: number }` object. Cycle through `frames` on a timer at `interval` ms.

**Browser (no dependencies):**
```html
<script src="unicode/spinners.js"></script>
<script>
  const s = Spinners.helix;
  let i = 0;
  setInterval(() => {
    document.getElementById('spinner').textContent = s.frames[i++ % s.frames.length];
  }, s.interval);
</script>
<span id="spinner" style="font-family: monospace"></span>
```

**Node.js / ESM:**
```js
import { helix, breathe, dna } from './unicode/spinners.js';
// or import everything:
import * as Spinners from './unicode/spinners.js';
```

**Python:**
```python
import json
with open('unicode/spinners.json') as f:
    spinners = json.load(f)
helix = spinners['helix']
# cycle: helix['frames'], helix['interval']
```

**Swift:**
```swift
// Load unicode/spinners.json and decode
struct Spinner: Codable {
    let frames: [String]
    let interval: Int
}
```

### Browse all spinners

Open `unicode/browser.html` in any browser to see all 18 spinners animating live with filter and preview controls.

## Hermes Desktop Categories

Hermes Agent uses these spinners from this library:

- **Thinking** (7): `helix`, `breathe`, `orbit`, `dna`, `waverows`, `snake`, `pulse`
- **Tool execution** (7): `cascade`, `scan`, `diagswipe`, `fillsweep`, `rain`, `columns`, `sparkle`

## License

- Unicode spinners: MIT (sourced from [unicode-animations](https://github.com/gunnargray-dev/unicode-animations) by Gunnar Gray)
- Browser tool: MIT
- This collection: MIT